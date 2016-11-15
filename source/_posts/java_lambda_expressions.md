title: Java Lambda 表达式（又名闭包(Closure)/匿名函数) 笔记
date: 15 Nov 2016 2:01 AM
categories: "java"
tags: [java,]
---

根据[JSR 335](https://jcp.org/en/jsr/detail?id=335), Java 终于在 Java 8 中引入了 Lambda 表达式。也称之为闭包或者匿名函数。

<!--more-->

![http://harchiko.qiniudn.com/Lambda%20Expression%20Java%208.png](http://harchiko.qiniudn.com/Lambda%20Expression%20Java%208.png)

## JSR 335

所谓的 JSR （Java Specification Requests） 全称叫做 Java 规范提案。简单来说就是向 Java 社区提交新的 API 或 服务 请求的提案。这些提案将作为 Java 社区进行 Java 语言开发的需求，引导着开发的方向。

JSR 335 的提案内容摘要如下：

```
We propose extending the Java Language to support compact lambda expressions (otherwise known as closures or anonymous methods.) Additionally, we will extend the language to support a conversion known as "SAM conversion" to allow lambda expressions to be used where a single-abstract-method interface or class is expected, enabling forward compatibility of existing libraries.

We propose extending the semantics of interfaces in the Java Language to support virtual extension methods, whereby an interface can nominate a static default method to stand in for the implementation of an interface method in the event that an implementation class does not provide an implementation of the extension method. This enables interfaces to be augmented with new methods "after the fact" without breaking existing implementation classes.

Time permitting, we will use these features to augment the core Java SE libraries to support a more lambda-friendly style of programming, such as: 
      Collection collection = ... ;
      collection.sortBy(#{ Foo f -> f.getLastName() });
or

      collection.remove(#{ Foo f -> f.isBlue() });
This will likely be accompanied by a set of standardized "SAM" types such as Predicate, Filter, Mapper, Reducer, etc.

```

也就是如下几点：

1. 支持 lambda 表达式。
2. 支持 SAM conversion 用来向前兼容。
3. 接口中可以定义其方法的默认静态方法。(这样可以在不改动已有实现类的基础上增加新功能,实际的Java 8实现中还增加了 default 关键字，有兴趣请阅读文后参考链接2)
4. 给出了一个基本的使用实例(Java 8 中并不是此形式！)

在 Java 8 中，以上均已经实现。

## Why Lambdas?

所以这个 Lambda 表达式到底有什么卵用呢？

我们还是先了解下什么到底是 Lambda 表达式吧：  Lambda 表达式呢其实就是一堆代码，然后可以在之后被执行。

多简单的定义呀，想必你看了如上的描述一定困惑不已？ Excuse me ？

在具体了解 lambda 之前，我们先往后退一步，看看之前我们是如何处理这些代码块的！

当决定在单独的线程运行某程序时，你这样做的！

```java
class Worker implements Runnable {
     public void run() {
        for (int i = 0; i < 1000; i++)
           doWork();
     }
     ...
  }
```

然后这样开始执行：

```java

Worker w = new Worker();
new Thread(w).start();
```

重点是 Worker 中包含了你要执行的代码块。

如果使用 lambda 表达式呢？

```java
new Thread(()->for (int i=0;i<1000;i++) doWork()).start();
```

wow! 多简洁！


再举一个例子:

如果你想实现根据字符串长度大小来排序，而不是默认的字母顺序，你可以自己来实现一个  Comparator 用来 Sort。

```java
class LengthComparator implements Comparator<String> {
     public int compare(String first, String second) {
        return Integer.compare(first.length(), second.length());
     }
  }
   
Arrays.sort(strings, new LengthComparator());
```

另外一个例子，我选的是 Android 中的点击事件，同样是 Java:

```java
```

在上面的3个例子中，都是将一堆代码pass到另外的方法中，然后在后来执行。

因为 Java 是纯面向对象的语言，你不能简简单单的就把代码块传给其他方法，所传递的应该是属于某个 Class 的某个 对象。 wow，这看起来可真麻烦啊。

在其他的一些语言中，比如 Python， 你可以很方便的传入一些代码块，然而为了 Java 的简洁和连贯性， Java 的设计者一直拒绝添加这种功能。

然而，在很长一段时间以来，问题已经不再是是否为Java 增加函数式编程，而是怎样做的问题。 经过几年的实验，终于，适合 Java 的设计出现了。下面就来一一解释一下。

## 语法 Syntax

考虑下前面的例子：

```java
Integer.compare(first.length(), second.length())
```

first和second都是 String 类型，Java 是强类型的语言，必须制定类型:

```java
(String first, String second)
     -> Integer.compare(first.length(), second.length())
```

看到没有！第一个 Lambda 表达式诞生了！！

一个代码块，包含了需要传入的参数，简洁明了。

> 为什么叫 Lambda 呢，这个很多年以前，有位逻辑学家想要标准化的表示一些可以被计算的数学方程（实际上存在，但是很难被表示出来），他就用 ℷ 来表示。

Java 8 最重要的一点就是为函数式编程打开了一扇门！

刚刚看过了一个Lambda 表达式的格式： 参数, "->" 箭头, 还有一个表达式。

如果计算的结果并不由一个单一的表达式返回（换言之，返回值存在多种情况），使用“{}"，然后明确指定返回值。

```java
(String first, String second) -> {
     if (first.length() < second.length()) return -1;
     else if (first.length() > second.length()) return 1;
     else return 0;
}
```

如果没有参数，则 "()"中就空着。

```java
() -> { for (int i = 0; i < 1000; i++) doWork(); }
```

如果参数的类型可以被推断出，则可以直接省略

```java
Comparator<String> comp
     = (first, second) // Same as (String first, String second)
        -> Integer.compare(first.length(), second.length());
```

这里，first和second可以被推断出是 String 类型，因为 是一个 String 类型的 Comparator。

如果单个参数可以被推断出，你连括号都可以省略：
```java
EventHandler<ActionEvent> listener = event ->
     System.out.println("Thanks for clicking!");
        // Instead of (event) -> or (ActionEvent event) ->
```

你可以像对待其他方法一样，annotation，或者 使用 final 修饰符

```java
(final String name) -> ...
    (@NonNull String name) -> ...
```

永远不要定义 result 的类型，lambda 表达式总是从上下文中推断出来的：

```java
(String first, String second) -> Integer.compare(first.length(), second.length())
```

注意，在lambda 表达式中，某些分支存在返回值，某些不存在返回值这样的情况是不允许的。
如 ` (int x) -> { if (x >= 0) return 1; }`这样是非法的。

## 函数式接口

什么叫作函数式接口呢？

函数式接口指的是只定义了唯一的抽象方法的接口（除了隐含的Object对象的公共方法）， 因此最开始也就做SAM类型的接口（Single Abstract Method）。

Lambda 表达式向前兼容这些接口。

举个例子 Array.sort:

```java
Arrays.sort(words,
     (first, second) -> Integer.compare(first.length(), second.length()));
```

Array.sort() 方法收到一个实现了 Comparable<String> 接口的实例。

其实可以把 Lambda 表达式想象成一个方法，而非一个对象，一个可以传入一个接口的方法。

再举个例子

```java
button.setOnAction(event ->
     System.out.println("Thanks for clicking!"));
```

你看，是不是更易读了呢？

实际上，将函数式接口转变成 lambda 表达式是你在 Java 中**唯一**能做的事情。在其他的语言中，你可以定义一些方便的方法类型，但在Java 中，你甚至不能将一个Lambda表达式赋值给类型为 Object 的变量，因为 Object 变量不是一个功能性的接口。

Java 的设计者们坚持使用熟悉的 interface 概念而不是为其引入新的 方法类型。

## Method References

有的时候，已经有了其他的方法能够处理，举个例子，你想简单的将点击事件打印出来：

```java
button.setOnAction(event -> System.out.println(event));
```

如果能够只是将 println() 方法 pass 到里面是不是更简洁呢?

```java
button.setOnAction(System.out::println);
```

表达式 `System.out::println` 属于一个方法引用（method reference）， 相当于 lambda 表达式 `x -> System.out.println(x)`

再举个例子，如果你想对字符串不管大小写进行排序

```java
Arrays.sort(strings, String::compareToIgnoreCase)

```

如上所见 `::`操作符将方法名与实例或者类分隔开。总体来说，又如下的规则:

* object::instanceMethod
* Class::staticMethod
* Class::instanceMethod

值得指出的是， `this`和`super`关键字可以在其中使用：

```java
class Greeter {
     public void greet() {
        System.out.println("Hello, world!");
     }
  }
```

```java   
class ConcurrentGreeter extends Greeter {
 public void greet() {
    Thread t = new Thread(super::greet);
    t.start();
 }
}
```

## 构造方法引用 Constructor References

构造方法引用跟方法引用是基本一致的，除了方法名字为 new 。

Array constructor references are useful to overcome a limitation of Java. It is not possible to construct an array of a generic type T. The expression new T[n] is an error since it would be erased to new Object[n]. That is a problem for library authors. For example, suppose we want to have an array of buttons. The Stream interface has a toArray method that returns an Object array:

```java
Object[] buttons = stream.toArray();
```

But that is unsatisfactory. The user wants an array of buttons, not objects. The stream library solves that problem with constructor references. Pass Button[]::new to the toArray method:

```java
Button[] buttons = stream.toArray(Button[]::new);
```

The toArray method invokes this constructor to obtain an array of the correct type. Then it fills and returns the array.

## 变量作用域

在之前，如果需要在匿名类的内部引用外部变量，需要将外部变量定义为 final ，现在有了 lambda 表达式，你不必再这么做了。

这里先暂时留空，待我稍后更新。

## Default Methods

由于历史原因，像是类似 Collection 这种接口，如果进行添加接口的话，那将会造成之前的代码出错，都需要实现新添加的方法。

Java 想了一个一劳永逸的方法解决这个问题， default methods, 比如 Collection  接口的源代码:

```java
default void remove() {
     throw new UnsupportedOperationException("remove");
}
```

当没有 override remove 这个方法是，调用的时候返回 UnsupportedOperationException 错误。


## Static Methods in Interfaces

Java 8 中，你可以在接口中添加静态方法了。 What ？？ 这他妈还是接口？


我决定将美少女放到最后！
![http://harchiko.qiniudn.com/44577950_p0.jpg](http://harchiko.qiniudn.com/44577950_p0.jpg) 

参考链接：
1. [JSR 335: Lambda Expressions for the JavaTM Programming Language](https://jcp.org/en/jsr/detail?id=335)
2. [Java 8 新特性概述](https://www.ibm.com/developerworks/cn/java/j-lo-jdk8newfeature/)
3. [Lambda Expressions in Java 8](http://www.drdobbs.com/jvm/lambda-expressions-in-java-8/240166764?pgno=1)