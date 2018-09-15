title: 在vps上重新部署博客
date: 2018-09-15 8:46 PM
categories: ""
tags: [vps,]

---

> 记录下备忘,部署并同时使用 ssl

<!--more-->

# 安装 nginx [ubuntu 18.04]

运行 `sudo apt-get install nginx`
启动 `service nginx start`

# 安装 certbot

参考 [https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)

# 配置

安装完上述两个，讲 github 上的指定位置 `/var/www` 下，并使用 `master` 分支

## 配置 cron

### 定时拉取最新的代码

```bash
SHELL=/bin/bash
*/2 * * * * cd /var/www/blog && git pull && service nginx reload
3 3 * * * sudo certbot renew
```

### renew https证书

```bash
3 3 * * * sudo certbot renew
```

选的不是整点是担心整点可能流量过大