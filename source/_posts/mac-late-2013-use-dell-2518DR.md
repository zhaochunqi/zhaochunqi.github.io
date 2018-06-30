title: Macbook Pro late 2013 使用戴尔 U2518DR
date: May 11, 2018 7:34 PM
categories: ""
tags: [mac,]

---

> 按照说明书上直接按上去后显示模糊，开始找网上的方案看能否解决问题。

<!--more-->

## 关闭系统保护

开机进入恢复模式 `csrutil disable; reboot`

## 生成配置文件

根据这里的指导生成配置文件并复制到指定文件夹中

[Scaled Resolutions for your MacBooks external Monitor | by Comsysto Reply](https://comsysto.github.io/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions/)

附注： 我的配置文件地址 -> [Dropbox - DisplayProductID-413c.plist](https://www.dropbox.com/s/4ucfat6cwcqmvnk/DisplayProductID-413c.plist?dl=0)

我的命令是:

`sudo cp DisplayProductID-413c.plist /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac/DisplayProductID-413c`

## 安装 RDM

RDM 可以在这里下载 [Index of /software/RDM](http://avi.alkalay.net/software/RDM/)

另外这是 github 介绍页 [GitHub - avibrazil/RDM: Easily set Mac Retina display to higher unsupported resolutions](https://github.com/avibrazil/RDM)

设置 display 2 为 `1920 x 1080` 终于完美了！

放张图吧:

![https://i.imgur.com/tCDNw8f.jpg](https://i.imgur.com/tCDNw8f.jpg)
