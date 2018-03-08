title: Mac 下 JAVA 8 与 JAVA 9 共存与切换
date: 9 Mar 2018 12:16 AM
categories: ""
tags: [java,]

---

由于系统崩溃，上个星期重新安装了系统之后就安装了 `JDK 9`， 但由于使用 `JDK 9` 时， `Lombok` 会出现一堆 bug，无奈只能再安装 `JDK 1.8`。

<!--more-->

## 安装

正常安装 `JDK 1.8` 和 `JDK 9` 即可, JAVA 8 对应的就是 JDK 1.8，JAVA 9 对应的 JDK 9。

安装地址: [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

## 切换

安装好之后，可以使用如下命令找到 `JAVA 8` 和 `JAVA 9` 的位置。

* JAVA 8

```bash
/usr/libexec/java_home  -v 1.8
```
* JAVA 9

```bash
/use/libexec/java_home -v 9
```


在 .zshrc 或 .bashrc 中，添加如下内容:

```bash
# 设置 JDK 8
export JAVA_8_HOME=`/usr/libexec/java_home -v 1.8`
# 设置 JDK 9
export JAVA_9_HOME=`/usr/libexec/java_home -v 9.0`

# 默认 JDK 8
export JAVA_HOME=$JAVA_8_HOME

# 动态切换版本
alias jdk8="export JAVA_HOME=$JAVA_8_HOME"
alias jdk9="export JAVA_HOME=$JAVA_9_HOME"
```

即可，可以直接使用命令  `jdk9` 切换成 JAVA 9.

## Intellij Idea 修改 JDK

`File` -> `Project Structure` -> `Project` -> `Project SDK` 中新增 `JAVA 8`  的 SDK 即可


参考链接: [http://chessman-126-com.iteye.com/blog/2162466](http://chessman-126-com.iteye.com/blog/2162466)