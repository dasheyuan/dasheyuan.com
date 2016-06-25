+++
date = "2016-05-28T23:00:00+08:00"
title = "学习PHP闭包(Closure)"
author = "Chen Yuan"
tags = ["php"]
url = "post/php-closure"
draft = false
+++
在学习Laravel框架的时候遇到了“闭包”的概念，查PHP的手册及网上的解释，分析对比一下，试着去理解。    

可能目前理解的还不妥，先记录下来吧。

## 一、闭包函数的基本用法
匿名函数（Anonymous functions），也叫闭包函数（closures），允许 临时创建一个没有指定名称的函数。最经常用作回调函数（callback）参数的值。    
Example #1 匿名函数示例，用作回调函数参数的值。
```
<?php
echo preg_replace_callback('~-([a-z])~', function ($match) {
    return strtoupper($match[1]);
}, 'hello-world');
// 输出 helloWorld
?>
```
<!--more-->
闭包函数也可以作为变量的值来使用。PHP 会自动把此种表达式转换成内置类 Closure 的对象实例。把一个 closure 对象赋值给一个变量的方式与普通变量赋值的语法是一样的，最后也要加上分号：    
Example #2 匿名函数变量赋值示例    
```
<?php
$greet = function($name)
{
    printf("Hello %s\r\n", $name);
};

$greet('World');
$greet('PHP');
?>
```
闭包可以从父作用域中继承变量。 任何此类变量都应该用 use 语言结构传递进去。    
Example #3 从父作用域继承变量
```
$message = 'hello';

// 没有 "use"
$example = function () {
    var_dump($message);
};
echo $example();
//输出为null,匿名函数继承（获取）到外部变量$message.
```
```
// 继承 $message
$message = 'hello';

$example = function () use ($message) {
    var_dump($message);
};
echo $example();
//输出 string 'hello' (length=5)，使用关键词use后，
//匿名函数可以获取到外部变量$message.
```
```
// Inherited variable's value is from when the function
// is defined, not when called
// 继承的变量的值在匿名函数定义时获取，并不是在调用时。
// 可以了解这种通过变量名的继承，是一种复制的方式。
$message = 'hello';

$example = function () use ($message) {
    var_dump($message);
};

$message = 'world';
echo $example();
//输出仍然为 string 'hello' (length=5),
//就算调用前$message的值改变了。
```

```
// 引用继承
// Inherit by-reference

$message = 'hello';

$example = function () use (&message) {
    var_dump($message);
};

$message = 'world';
echo $example();
//输出 string 'world' (length=5),
```
Example #4 匿名函数可以接受参数
```
$message = 'world';
$example = function ($arg) use ($message) {
    var_dump($arg . ' ' . $message);
};
$example("hello");
//输出 string 'hello world' (length=11)
```
## 二、闭包 Closure 类
匿名函数目前是通过 `Closure` 类来实现的。   
Closure类定义了三种方法：    

- Closure::__construct — 用于禁止实例化的构造函数。        
- Closure::bind — 复制一个闭包，绑定指定的`$this`对象和类作用域。
- Closure::bindTo — 复制当前闭包对象，绑定指定的`$this`对象和类作用域。

Closure::bind的用法,这个方法是 Closure::bindTo() 的静态版本。
```
//public static Closure Closure::bind ( Closure $closure , 
//object $newthis [, mixed $newscope = 'static' ] )
class A {
    private static $sfoo = 1;
    private $ifoo = 2;
}
$cl1 = function() {
    return A::$sfoo;
};
$cl2 = function() {
    return $this->ifoo;
};

$bcl1 = Closure::bind($cl1, null, 'A');
$bcl2 = Closure::bind($cl2, new A(), 'A');
echo $bcl1(), "\n";
echo $bcl2(), "\n";
//输出
//1
//2
```
Closure::bindTo的用法：
```
//public Closure Closure::bindTo ( object $newthis [, 
//mixed $newscope = 'static' ] )
class A {
    function __construct($val) {
        $this->val = $val;
    }
    function getClosure() {
        //returns closure bound to this object and scope
        return function() { return $this->val; };
    }
}

$ob1 = new A(1);
$ob2 = new A(2);

$cl = $ob1->getClosure();
echo $cl(), "\n";
$cl = $cl->bindTo($ob2);
echo $cl(), "\n";
```
## 三、闭包的理解
## 1.变量的作用域
变量的作用域无非就是两种：全局变量和局部变量。    
   
出于种种原因，我们有时候需要得到函数内的局部变量。但是，前面已经说过了，正常情况下，这是办不到的，只有通过变通方法才能实现。    

如何从外部读取局部变量？看下面的例子： 
```
function f1() {
		$n = 2;
		$f2 = function () use($n) {
            return $n;
        };
        return  $f2;
}
var_dump($n);
//null
$f = f1();
var_dump($f());
//int 2
```
在上面的代码中，匿名函数f2就被包括在函数f1内部，这时f1内部的所有局部变量，对f2都是选择可见的（关键词：use）。但是反过来就不行，f2内部的局部变量，对f1就是不可见的。    
既然f2可以读取f1中的局部变量，那么只要把f2作为返回值，我们不就可以在f1外部读取它的内部变量了吗！     

阮一峰老师从Javascriptd语言考虑，对闭包的理解的是：**闭包就是能够读取其他函数内部变量的函数**。    
他说，闭包可以用在许多地方。它的最大用处有两个，一个是前面提到的可以读取函数内部的变量，另一个就是让这些变量的值始终保持在内存中。
我对他的看法是认可的，但我觉着还不能够帮助我理解，因为虽然我知道闭包的作用是这样的，但然后呢？   

我觉得，PHP的闭包的绑定作用，可以加深对闭包的**应用**的理解。
## 2.闭包的绑定
下面这个例子有点容器的影子。    

只不过这个容器只是用来“装”函数的，Laravel的容器是用来“装”类的。
```
MetaTrait.php
<?php
//关键词：trait，可以理解为除继承、接口的另外一种解决“多重继承”方法。
trait MetaTrait
{
    //定义$methods数组,用于保存方法（函数）的名字和地址。
    private $methods = array();
    //定义addMethod方法，使用闭包类绑定匿名函数。
    public function addMethod($methodName, $methodCallable)
    {
        if (!is_callable($methodCallable)) {
            throw new InvalidArgumentException('Second param must 
                be callable');
        }
        $this->methods[$methodName] = Closure::bind($methodCallable, 
                $this, get_class());
    }
    //方法重载。为了避免当调用的方法不存在时产生错误，
    //可以使用 __call() 方法来避免。
    public function __call($methodName, array $args)
    {
        if (isset($this->methods[$methodName])) {
            return call_user_func_array($this->
                    methods[$methodName], $args);
        }

        throw RunTimeException('There is no method with 
                the given name to call');
    }

}
?>

test.php
<?php
require 'MetaTrait.php';
//定义HackThursday类，继承MetaTrait。
//可以把MetaTrait理解为容器的基类，HackThursday是一种容器，
//这个容器是装什么的呢？匿名函数。
//可以把匿名函数灵活地绑定至容器中。
class HackThursday {
    use MetaTrait;

    private $dayOfWeek = 'Thursday';

}

$test = new HackThursday();
$test->addMethod('when', function () {
    return $this->dayOfWeek;
});

echo $test->when();

?>
```
##  参考
1.[学习Javascript闭包（Closure）](http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html)     
2.[PHP手册-Closure类](http://php.net/manual/zh/class.closure.php)     
3.[PHP手册-匿名函数](http://php.net/manual/zh/functions.anonymous.php)     
4.[Laravel学习笔记——神奇的服务容器](https://www.insp.top/learn-laravel-container)
