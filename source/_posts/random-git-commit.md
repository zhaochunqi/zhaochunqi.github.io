title: 添加一个随机的Git提交说明
date: 2015-11-26 2:30 AM
categories: snippets
tags: [snippets,git]
---

** 代码 **:

```bash
git commit -m "$(curl -s http://whatthecommit.com/ | awk '/<p>/ {sub("<p>", ""); print }')"
```
<!--more-->
适用于不是很重要的项目中的提交说明，工作中慎用。

![](https://ws3.sinaimg.cn/large/006tKfTcly1flzgn1lz0oj31kw0bmjuh.jpg)