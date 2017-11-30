title: 使用 docker 进行 Minecraft 开服与备份
date: 2017-10-16 10:18 AM
categories: ""
tags: [linux,docker]

---

> 没有什么事情，是跟好友一起玩游戏更快乐的了。去年怂恿老夏入了一套正版的 Minecraft 之后，就一直考虑如何联机一起搞。如今我们两个虽然不在一个城市了，但并不妨碍一起继续玩游戏。

<!--more-->

## 目标

从我决定开服起，我就给自己定下了以下目标:

1. 简单。
2. 安全。

所谓简单，我想要的是配置简单。 而安全，则是数据的安全。 我不希望那一天我的服务器发生灾难性事故，我的 Minecraft 存档毁于一旦。

## 行动

毫无疑问，docker 是我的第一选择。

经过一番考虑，我选择了使用 dropbox 备份我的数据，在开启 Minecraft 的 docker 镜像之前，先将 dropbox 镜像建立起来。

### 创建 dropbox container

```
docker run -d --restart=always --name=dropbox -v /home/zcq_qiqi/Dbox/Dropbox:/dbox/Dropbox -v /home/zcq_qiqi
/Dbox/.dropbox:/dbox/.dropbox janeczku/dropbox

```

使用 `docker logs mc` 查看日志进行 dropbox 绑定。

![](media/UsersdeveloperDesktopScreen-Shot-2017-10-16-at-10.14.54-AM-1.jpg)

进入 Container ，将一些无用的文件夹进行排除

`docker exec -t -i dropbox dropbox exclude add 1Password ithoughtsx Screenshots template Weekly\ Summary`

**注: 1Password ithoughtsx Screenshots template Weekly\ Summary 是排除的文件夹，请根据个人的文件夹进行排除**

### 创建 Minecraft Container

创建 minecraft 文件夹

在宿主机上执行:

```
cd ~/Dbox/Dropbox
mkdir minecraft

```

启动 Container

```
docker run -d -v /home/zcq_qiqi/Dbox/Dropbox/minecraft/data:/data -e TYPE=FORGE -p 25565:25565 -e EULA=TRUE 
-e VERSION=1.12.1 --name mc itzg/minecraft-server

```

**这里固定了版本在 1.12.1，不固定的话Minecraft上级之后会登录不上。**

## 结束

只建立好了服务器只是第一步，如果你不想你的服务器被熊孩子乱搞的话，最好加一个白名单。

在 whitelist.json 中添加如下格式的用户信息:

```
[
 {
 "name": "archieant",
 "uuid": "7c20d813-631e-4e9b-a3f0-977dac8b284d"
 },
 {
 "name": "meihuayu",
 "uuid": "a01e6c11-194d-41ca-a334-d6edbe25afc1"
 }
]

```

如果你想添加管理员权限,在 ops.json 添加如下信息.

```
[
 {
 "uuid": "a01e6c11-194d-41ca-a334-d6edbe25afc1",
 "name": "meihuayu",
 "level": 4,
 "bypassesPlayerLimit": false
 },
 {
 "uuid": "7c20d813-631e-4e9b-a3f0-977dac8b284d",
 "name": "archieant",
 "level": 4,
 "bypassesPlayerLimit": false
 }
]
```



 ​

