title: 如何在多设备中同步
date: 2016-05-08 9:47 AM
categories: "raspberry"
tags: [sync,linux]
---
我有一个很奇怪的需求，在不同的device中同步PDF的阅读标注。第一时间，我就想到了神器Bittorrent Sync。

<!--more-->
![http://harchiko.qiniudn.com/BTSync.png](https://ws2.sinaimg.cn/large/006tKfTcly1flzgnzoc6vj30740743yi.jpg)

btsync 是 bittorrent 旗下的一款同步软件，其特点是不需要有一个中央同步服务器即可进行同步。你可以想象成网盘，也可以想象成它是分布式存储。

### 安装

Android、iOS、Windows、OSX 下安装基本都是点点鼠标就可以了。

说一下树莓派上安装

```bash
mkdir ~/.btsync && cd ~/.btsync
wget https://download-cdn.getsync.com/stable/linux-arm/BitTorrent-Sync_arm.tar.gz
btsync
```

命令行输出如下:

![http://harchiko.qiniudn.com/Screen%20Shot%202016-05-08%20at%2011.00.22%20AM.png](https://ws3.sinaimg.cn/large/006tKfTcly1flzgo1yddej31i0074jtg.jpg)

通过VNC连进去，进入 127.0.0.1:8888 按照说明进行配置。

添加需要同步的文件夹，然后在其他客户端上进行配置（扫码或者直接打开链接),主意，如果你像我一样需要在各个设备上同步进度，请选择 Read & Write 权限。

### 配上全家福的图:

OSX：

![http://harchiko.qiniudn.com/Screen%20Shot%202016-05-08%20at%2011.06.45%20AM.png](https://ws2.sinaimg.cn/large/006tKfTcgy1flzgo3u3z4g312i0jeb29.gif)

S7 edge:

![http://harchiko.qiniudn.com/252222861.jpg](https://ws3.sinaimg.cn/large/006tKfTcly1flzgo5hb5lj31401z4wg9.jpg)

Raspberry Pi:

![http://harchiko.qiniudn.com/Screen%20Shot%202016-05-08%20at%2011.11.20%20AM.png](https://ws2.sinaimg.cn/large/006tKfTcly1flzgoa6cmyj31kw18vwmu.jpg)

NOOK HD +:

![http://harchiko.qiniudn.com/Screenshot_2016-05-08-11-12-58.png](https://ws3.sinaimg.cn/large/006tKfTcly1flzgobpt1gj30zk1hcmy3.jpg)

### 结论

经局域网测试，修改之后PDF的标注会很快同步到其他设备中。能满足我的要求。
