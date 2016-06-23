title: 设计模式系列--一、策略模式
date: 2016-06-16 3:28 PM
categories: ""
tags: [pattern,]
---
本文章是设计模式第一讲，策略模式。

<!--more-->

你现在在全球最最著名的软件公司ThoughtWorks工作，你是其中的一名优秀的软件开发者。

你在上班的时候做了一个非常成功的游戏SimUDuck,游戏中会出现各种鸭子，一边戏水，一边呱呱叫。

你设计的很棒，充分利用了OO技术，设计了一个超类，让各种鸭子继承。

![http://harchiko.qiniudn.com/design_pattern_duck.bmp](http://harchiko.qiniudn.com/design_pattern_duck.bmp)

公司很重视这个游戏，现在你们公司进行了一场头脑风暴: 我们需要鸭子会飞。这样才能把竞争对手狠狠的甩在后面。

“这很简单”，你心里想着，“只要把父类添加一个新的方法 fly 就好了啊！“

然而，在实际操作中