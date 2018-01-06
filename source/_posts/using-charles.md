title: 使用 Charles 进行移动端抓包
date: 2018-01-07 6:12 AM
categories: ""
tags: [dev,]

------------------

> 不管是测试还是开发人员，在实际工作过程中经常要查看请求链接，已经请求内容来定位到问题。这个时候，就需要我们来进行抓包。

<!--more-->
## 工具
--

**抓包的工具**其实还是挺多的，据我了解大概有

*   Fiddler （windows)
*   wireshark （比较高级，能够捕获各种各样的包，不局限与 http/https）
*   Anyproxy 阿里出的抓包工具，还具有一些其他的功能 （基于 node 和 web， 所以是全平台都可以使用）
*   Charles（windows && mac）

原理
--

抓包的原理实际上很简单：

本来，我们的请求是这样的:

```
    +----------+             +----------+
    |          |             |          |
    |  you     | +---------> |  server  |
    |          |             |          |
    +----------+             +----------+
```

因为我们要从中获取到数据，所以现在的请求方式是这样的:

```    
    +----------+        +----------+       +------------+
    |          |        |          |       |            |
    |  you     +------> |  charles | +---> |   server   |
    |          |        |          |       |            |
    +----------+        +----------+       +------------+
```

其实我们抓包的过程又可以称之为[中间人攻击](https://www.wikiwand.com/zh-hans/%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB)。我们截获了终端到服务器的通讯消息，获取其中的内容。

## 操作
--

我比较偏爱 Charles。下面我们一 Charles 为例，演示一下如何进行抓包：

### 安装

安装不是很复杂，需要注意的是，如果windows下 charles 不能正常工作，首先检查关闭防火墙能不能正常工作，如果可以的话，找到防火墙中关于charles 的规则，启用规则重新打开防火墙即可。

### 打开 Charles

在 Charles 中

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.14.39%20AM.png)

简单介绍一下面板的功能:

1.  上面区域是所有请求链接显示的地方。
2.  下面区域点击会看到详细的请求信息。

### 设置代理

`Proxy -> Proxy Settings`中， ![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.25.08%20AM.png)

`port`可以手动指定，也可以使用动态端口（我个人比较倾向于动态端口，缺点是每次都要来看一下端口，然后在手机上重新设置，但是使用某个固定端口经常有抓不到包的情况）

移动端，我们需要跟电脑在同一局域网内，获取到本机的IP地址，与端口号，配置手机的代理。

![](http://harchiko.qiniudn.com/361515267100_.pic_hd.jpg)

我个人的配置如下:

![](http://harchiko.qiniudn.com/371515267187_.pic_hd.jpg)

### 抓包

配置完成后，Charles会出现是否允许请求，点击允许即可。

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.35.37%20AM.png)

可以看到 charles 已经可以查看到请求的信息了。

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.37.24%20AM.png)

### https 抓包

可以看到，有一些 method 上面是 connect ，里面的内容我们还是看不到，这些是 https 请求（https 就是为了防止中间人攻击的）。我们需要在移动端安装证书来信任 charles 。

`Help -> SSL Proxying` 找到对应的选项进行安装

然后在 charles 对应的网址下，选择 `Enable SSL Proxying`

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.47.48%20AM.png)

再次请求，即可看到请求结果。

### 没有 ssl 代理前

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.49.23%20AM.png)

### ssl 代理后

![](http://harchiko.qiniudn.com/Screen%20Shot%202018-01-07%20at%203.49.48%20AM.png)
