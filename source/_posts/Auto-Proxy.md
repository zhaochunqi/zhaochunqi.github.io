title: 基于Shadowsocks透明代理的实现
date: 2015-02-04 01:21:44
tags: [proxy,linux]

---

程序员们最在意的，可能就是网络跟设备配置了。

做一个透明代理，能够做到：

	自动翻墙，本地无需配置。

### 网络拓扑图
![透明代理网络拓扑图](http://harchiko.qiniudn.com/Auto-Proxy/autoproxy_map.png)

### 需求

1. 一台外网VPS（能被中国大陆访问到，能够访问到Facebook等网站）
2. 一台本地Linux服务器(此处可以用智能路由器代替)。

### 方案设想

1. 本地的Linux服务器作为网关， 处理本地流量和需要代理的流量。
2. 本地服务器将需要代理的流量转发给Shadowsocks并通过Shadowsocks来实现代理功能。

### 具体方案

1. 在VPS中安装Shadowsocks，并在本地客户端测试是否成功。
2. 待续。

[http://www.chiphell.com/thread-674998-1-1.html](http://www.chiphell.com/thread-674998-1-1.html "NAS+GAE+ROS透明代理实现无障碍上网") 这篇文章中了解到了
[http://blog.sina.com.cn/s/blog_54e2ad5401000825.html](http://blog.sina.com.cn/s/blog_54e2ad5401000825.html "ROS之透明代理设置")介绍了如何在ros中设置web proxy 功能。

流量如何进入Linux服务器中？

本地的网络拓扑如下：