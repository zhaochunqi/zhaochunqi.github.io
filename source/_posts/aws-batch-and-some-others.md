title: AWS Batch 介绍与实践
date: 2018-01-21 11:10 PM
categories: "aws"
tags: [batch, ]

---

最近，我们在一个项目中使用到了 AWS Batch，特通过这篇博客来记录一下。

<!--more-->

## 什么是 Batch ?

官方介绍:

>AWS Batch 让开发人员、科学家和工程师能够轻松高效地在 AWS 上运行成千上万项批处理计算任务。AWS Batch 可根据提交的批处理任务的数量和特定资源要求，动态预置计算资源 (CPU 或 内存优化型实例) 的最佳数量和类型。借助 AWS Batch，您无需安装和管理运行您的任务所使用的批处理计算软件或服务器群集，从而使您能够专注于分析结果和解决问题。AWS Batch 可以跨多种 AWS 计算服务和功能 (如 Amazon EC2 和竞价型实例) 计划、安排和执行您的批处理计算工作负载。

简单来说，Batch 是可以预定义执行任务所需的计算机资源，然后在任务触发时能够自动创建对应的实例。

## Batch 好处

据官网的描述,batch 有如下的优势:

* 完全托管

    借助 AWS Batch，您无需运行第三方商业或开源批处理解决方案，也无需安装或管理批处理软件或服务器。AWS Batch 可为您管理所有基础设施，从而避免了预置、管理、监控和扩展您的批处理计算任务所带来的复杂性。 
* 与 AWS 集成

    AWS Batch 已与 AWS 平台进行本地集成，让您能够利用 AWS 的扩展、联网和访问管理功能。这便于您轻松运行能够安全地从 AWS 数据存储 (如 Amazon S3 和 Amazon DynamoDB) 中检索数据并向其中写入数据的任务。 
* 成本优化的资源预置

    AWS Batch 可根据所提交的批处理任务的数量和资源要求预置计算资源并优化任务分配。AWS Batch 能够将计算资源动态扩展至运行您的批处理任务所需的任何数量，从而使您不必受固定容量群集的限制。此外，AWS Batch 还可代表您针对竞价型实例动态出价，从而进一步降低运行您的批处理任务而产生的费用。 



## 典型的应用场景

### 金融服务 – 交易后分析

自动分析每天的交易费用、执行报告和市场绩效。

![http://harchiko.qiniudn.com/Dilithium_flowchart%20diagrams_v3_kw-02.322877d73eda8ed71a44db216a1d195550befac0](http://harchiko.qiniudn.com/Dilithium_flowchart%20diagrams_v3_kw-02.322877d73eda8ed71a44db216a1d195550befac0)

### 数字媒体：视觉效果呈现

自动处理内容呈现工作负载，并通过执行依赖关系或资源排程降低人为干预的必要性。

![http://harchiko.qiniudn.com/Dilithium-Diagrams_Visual-Effects-Rendering.ad9c0479c3772c67953e96ef8ae76a5095373d81](http://harchiko.qiniudn.com/Dilithium-Diagrams_Visual-Effects-Rendering.ad9c0479c3772c67953e96ef8ae76a5095373d81)

## 如何使用 Batch

下面以我们实际的应用场景来说明如何使用 Batch.

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

### Lambda Function

可以看到 lambda 在我们整个系统中起着很重要的作用，用来接收 cloud watch 的定时任务，用来接收 SNS 传递过来的信息。

* 第一个 Lambda 我们需要接收来自 Cloud Watch 的信息，然后通过 Cloud Watch 的信息来启动相关的 Batch Job。

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

我们需要由 Cloud Watch 传递相关的参数启动相关的 Batch。


* 第二个 Lambda 见 [SNS](#SNS) 部分。


### Batch

在 Batch 启动镜像之前，我们需要先给机器配置做一个预定义，AWS 规定是必须有 jobDefinition ， 但是可以通过参数来覆盖一些 jobDefinition 的定义。

![http://harchiko.qiniudn.com/Screen%20Shot%202018-01-22%20at%209.54.07%20AM.png](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-22%20at%209.54.07%20AM.png)

点击 Create ，即可创建相关的 Batch definition，其中的 image 需要填入相关的 docker 镜像。

这里可以预先定义包括环境变量，运行环境，机器配置等一系列的东西。

配置完成之后可以现在 jobs 中测试一下 job 能否正常运行。

### cloud watch

1. 点击 cloud watch, 在其中选择 rules。

![http://harchiko.qiniudn.com/cloud-watch1.png](http://harchiko.qiniudn.com/cloud-watch1.png)


2. 点击create rules， 创建定时任务，这里我们需要将相关的参数传到 lambda 中。

值得注意的是，cron 可能与 linux 下有所不同，参考: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions)。

在右边，我们选择 add target, lambda function。选择我们之前的 Lambda，选择 Configure input 下的 Constant，填入相关参数

```json
{
  "jobName": "Lambda-Broadbean", //随便写，job 的名字
  "jobQueue": "feeds", //注意跟 Batch 中的 Queue 对应
  "jobDefinition": "feedstream-Broadbean" //上面创建的 feedstream 的名字
}
```

这样，一个能够定时触发的 Batch 就完成了，也就是前几个流程。

```
+-----------+    +------+   +-----+ 
|cloud watch+--> |lambda+-->+batch|
+-----------+    +------+   +-----+
```

### SNS


我们需要通过 SNS 来传递信息到 Lambda 。

我们需要看一下 SNS 的消息格式(删减了一些内容):

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

可以看到相关的 Message 内容都在 Records[0] -> Message 下,在Lambda 中只需要 `event['Records'][0]['Sns']['Message']` 即可获取相关的 Message 信息。然后通过解析此信息来启动 Batch。

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

这里的代码相对来说比较简单，这里其实可以直接调用上一个 Lambda 来启用 Batch。

至此，我们整个流程就完成了。

```
+-----------+    +------+   +-----+    +---+    +------+    +-----+
|cloud watch+--> |lambda+-->+batch| +->+SNS| +> |lambda| +->+batch|
+-----------+    +------+   +-----+    +---+    +------+    +-----+

```

Q&A


1. 为什么不适用 `Job depends on` 参数启用 job 呢?

Batch 在启用 job 的时候有一个参数是 `Job depends on`,如下图
![http://harchiko.qiniudn.com/batch-job.png](http://harchiko.qiniudn.com/batch-job.png)

根据这里的文档: [https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html](https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html)

`Job depends on` 的意思是在在其他的job结束之后，此 job 才能运行，我们这里通过在每一个项目结束之后，使用 SNS 来启动, 这里就不需要此参数了。


2. 为什么不直接使用 Batch 的定时，而直接使用 Cloud Watch ?

一开始我们也是想使用 Batch 自己的定时任务，但是官方提供的文档 [https://docs.aws.amazon.com/batch/latest/userguide/job_scheduling.html](https://docs.aws.amazon.com/batch/latest/userguide/job_scheduling.html) 中异常简单，并不了解如何来使用，咨询对 `AWS` 比较熟悉大牛之后，我们采用了 cloud watch 发送 event 到 lambda，然后使用 lambda 来启用 batch 的方法。


3. 为什么要使用 SNS?

我们希望在上一个 Batch 任务执行完毕之后，使用其参数立即来构建另一个 Batch 任务。