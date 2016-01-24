title: 让Sublime成为真正的神器
date: 2016-01-24 1:44 PM
categories: 
tags: [editor,sublime]
---
## 让 Sublime 更漂亮

### 安装 Material Theme

1. 安装`PackageControl` [https://packagecontrol.io/installation](https://packagecontrol.io/installation)，重启Sublime.
1. 安装 Material Theme, [https://github.com/equinusocio/material-theme](https://github.com/equinusocio/material-theme)。
1. 安装完毕后按照弹出的`README`文档配置用户配置文档。

### 安装 Facebook Color Theme

1. 安装 `Colorsublime`,在`PackageControl`中搜索`Colorsublime`即可。
2. 安装 `Facebook Color Theme`
    * 打开｀PackageControl｀，使用 `Colorsublime: install`,安装 Theme, Theme 名称为 Facebook 。

### 安装 FiraCode 字体
* 打开字体repo[https://github.com/tonsky/FiraCode](https://github.com/tonsky/FiraCode)
* 下载后双击安装即可，我把所有的都安装了。
* 在配置文件中配置`font-face` 为 "Fire Code Retina", 顺便配置下`font-size`: 15。

### 个性化配置

* 修改 Material Theme，使 Material Theme与 Facebook Color Theme协调统一。
    * 安装 PackageResourceViewer 以便查看并修改Theme.
    * 使用命令`PackageResourceViewer : Extract`,并选中`Material Theme`.
    * `Preference`-> `Browse Packages`打开文件夹，进入Material Theme.
    * 修改｀Material-Theme.sublime-theme`文件，取左右两边RGB色进行全部替换。
    > 因为分屏问题，这里分屏的线色不能与背景色太过相近，需要修改boder_color
    ```json
/* @ GRID LAYOUT
   * Grid style
  ========================================================================= */

    {
      "class": "grid_layout_control",
      "border_size": 1,
      "border_color": [39, 53, 60]
    },
    ```
* 关闭 minimap `"always_show_minimap_viewport": false,`
* 去掉行号 `"line_numbers": false,`
* 去掉行号那边缩进 `"margin":0,"`

### 配置完毕结果如图

![](http://harchiko.qiniudn.com/Screen%20Shot%202015-12-28%20at%207.59.11%20PM.png)

## 让Sublime更高效
