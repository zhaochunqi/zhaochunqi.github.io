title: 如何使用 AWS 创建易于扩展的 Data PipeLine
date: 2018-10-15 1:12 AM
categories: ""
tags: [aws,]

---

> 本文是之前的补充升级版本.

<!--more-->

本文中将以我们实际线上的一个任务来说明应该如何使用 Batch

我们的场景类似上面的金融服务交易后分析:

1. 一个随时更新的 xml 文件。
2. 需要每天定时检查更新，发现 xml 更新后需要更新对应的文件到相关的 S3 中。
3. 更新完相关的文件之后，需要启动另一分析程序，分析更新后的 xml 文件，将相关的内容上传到另外的云服务中。

所以目前的结构是这样的:

```
+-----------+    +------+   +-----+    +---+    +------+    +-----+
|cloud watch+--> |lambda+-->+batch| +->+SNS| +> |lambda| +->+batch|
+-----------+    +------+   +-----+    +---+    +------+    +-----+

```

cloud watch 用来做定时任务，定时通过Lambda 触发相关的 Batch， batch 发现 xml 更新之后会发送通知到 SNS, 由 SNS 来触发 lambda, 然后由 lambda 启用 Batch 。

# 设定作业定义

在 Batch 任务运行之前,需要将任务的运行条件进行预定义,等到任务具体启动时 batch 会读取预定义的作业任务,然后执行.

## 创建

* 作业定义名称 名字可以任意起名
* 作业角色  指定的可以执行 batch 任务的 IAM 角色
* 容器映像 这里填写 docker image 的地址
* 在环境中根据需求填写 vcpu 和 内存
* 在环境变量中添加相关的运行时的环境变量即可

## 修订

* 修订指的是在已有的任务定义中进行修改和补充，修改之后，版本会+1，同时，之前的版本还会保留

# 创建作业队列

TODO//

# 通过 Lambda 实现自动化定时启动

## 定时启动原理

CloudWatch 中可以设定定时启动,在 Lambda 中,直接以 CloudWatch 作为触发,即可实现定时启动任务.

## 相关代码

Lambda  相关 Python  代码示例如下:

```python
from __future__ import print_function

import json
import boto3

print('Loading function')
batch = boto3.client('batch')

def lambda_handler(event, context):
    # Log the received event
    print("Received event: " + json.dumps(event, indent=2))
    # Get parameters for the SubmitJob call
    # http://docs.aws.amazon.com/batch/latest/APIReference/API_SubmitJob.html
    jobName = event['jobName']
    jobQueue = event['jobQueue']
    jobDefinition = event['jobDefinition']
    # containerOverrides and parameters are optional
    if event.get('containerOverrides'):
        containerOverrides = event['containerOverrides']
    else:
        containerOverrides = {}
    if event.get('parameters'):
        parameters = event['parameters']
    else:
        parameters = {}

    try:
        # Submit a Batch Job
        response = batch.submit_job(jobQueue=jobQueue, jobName=jobName, jobDefinition=jobDefinition,
                                    containerOverrides=containerOverrides, parameters=parameters)
        # Log response from AWS Batch
        print("Response: " + json.dumps(response, indent=2))
        # Return the jobId
        jobId = response['jobId']
        return {
            'jobId': jobId
        }
    except Exception as e:
        print(e)
        message = 'Error submitting Batch Job'
        print(message)
        raise Exception(message)
```

# 使用 SNS 和 Lambda 将 Batch 串联起来

目前,我们的相关结构是这样的:

```
+-----------+    +------+   +-----+    +---+    +------+    +-----+
|cloud watch+--> |lambda+-->+batch| +->+SNS| +> |lambda| +->+batch|
+-----------+    +------+   +-----+    +---+    +------+    +-----+

```

在 Batch 执行完毕之后,会发送一个 Notification 到 SNS 中,然后触发 lambda 之后启动后续的 Batch 任务 .

## SNS 的消息格式

```json
{
  "Records": [
    {
      "EventVersion": "1.0",
      "EventSubscriptionArn": "arn:awe-4689-b71c-43657a0ce152",
      "EventSource": "aws:sns",
      "Sns": {
        "SignatureVersion": "1",
        "Timestamp": "2018-01-20T04:06:35.010Z",
        "Signature": "i/FC0Z3XT5M4jhru0wP65dD4vaCDYwczszj8V+aCCJX7SCbY1A+X7FjdrSWDeEFMaCqQhg4Wq/ch204kMHg47k4NCQ00cLJmBNc9XnrLiQMuAv1pcSdYu3uWikTlJ8E95K7h6Y/kq2/Tq1f+ELu6r5jEMV3/pKxSaRrdXmTZOZzjQDJKTT1fGNWIgRFOA/Ey+gcaZ8Fg==",
        "SigningCertUrl": "https://sn1.pem",
        "MessageId": "28dcb39b-12da-551856c",
        "Message": "{\"type\":\"lovelive\",\"jobXmlTag\":\"job\",\"gzipped\":true,\"emptyCDATA\":false}}",
        "MessageAttributes": {},
        "Type": "Notification",
        "UnsubscribeUrl": "https://sns.us-eace152",
        "TopicArn": "arn:aws:sns:us-east-1:162141517946:start_feed_consumer",
        "Subject": null
      }
    }
  ]
}
```

## Lambda 的相关处理代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import json
import boto3

print('Loading function')

batch = boto3.client('batch')


def lambda_handler(event, context):
    # Log the received event.
    print("Received event: " + json.dumps(event, indent=2))
    download_message = event['Records'][0]['Sns']['Message']
    # Get parameters for the SubmitJob call
    # http://docs.aws.amazon.com/batch/latest/APIReference/API_SubmitJob.html
    jobName = "lambda-feed-consumer"
    jobQueue = "feeds"
    jobDefinition = "FeedConsumer"
    containerOverrides = {
        'environment': [
            {
                'name': 'DOWNLOAD_MESSAGE',
                'value': download_message
            },
            {
                'name': 'PARALLELISM',
                'value': 15
            }
        ],
    }

    try:
        # Submit a Batch Job
        response = batch.submit_job(jobQueue=jobQueue, jobName=jobName, jobDefinition=jobDefinition,
                                    containerOverrides=containerOverrides)
        # Log response from AWS Batch
        print("Response: " + json.dumps(response, indent=2))
        # Return the jobId
        jobId = response['jobId']
        return {
            'jobId': jobId
        }
    except Exception as e:
        print(e)
        message = 'Error submitting Batch Job'
        print(message)
        raise Exception(message)
```

这里的代码看注释很容易理解.

# Batch 的一些优势和缺点

## 优势

Batch 结合 Lambda 可以实现按需启动服务器,极大地节省了服务器的使用费用.

## 缺点

待补充.