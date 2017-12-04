title: 通过 logbook 来提升编程技能
date: 2017-12-04 2:08 PM
categories: ""
tags: [linux,]

---

> 本文通过介绍了一种通过 logbook 的记录来提高自己编程技能的简便方法。

<!--more-->

这篇文章是我在看了[Using a logbook to improve your programming](https://routley.io/tech/2017/11/23/logbook.html?utm_campaign=CodeTengu&utm_medium=rss&utm_source=CodeTengu_108)的记录。

## 记录原则

logbook 记录有几个原则:

1. 考虑你要解决的问题是什么？
2. 描述你用来解决问题的办法。
3. 描述你使用此方法的过程。
4. 记录，并查看是否有更好的方案。

## 编程使用的优点

1. 分解大问题为小问题。
2. 很容易在分散精力之后重新回到工作状态。
3. 可以从你的日志中快速学习。你可以查看你使用过的方法，然后了解哪些方法奏效，哪些无用。 

## 快捷方法

定义此方法到 `.zshrc` 中.

```bash
function lb() {
    vim ~/logbook/$(date '+%Y-%m-%d').md
}
```



参考链接: 
* [https://routley.io/tech/2017/11/23/logbook.html?utm_campaign=CodeTengu&utm_medium=rss&utm_source=CodeTengu_108](https://routley.io/tech/2017/11/23/logbook.html?utm_campaign=CodeTengu&utm_medium=rss&utm_source=CodeTengu_108)