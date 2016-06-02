+++
date = "2016-05-21T23:00:00+08:00"
title = "PHP的依赖管理工具Composer(1)"
author = "Chen Yuan"
tags = ["php"]
url = "post/php-composer-1"
draft = false
+++
![](http://image.phpcomposer.com/d/1e/768684492400b1470aa7882b29d5c.png)     
无论是在系统中，还是在高级编程语言中，依赖管理工具都扮演着重要的角色，因为它极大地提高了我们的开发效率。        

Ubuntu有apt-get，Python有pip，Node.js有npm，PHP呢？

PHP有Composer。
<!--more-->
最近一个项目需要，重新拿起PHP来编写程序开发。为了提高开发效率，尝试用Laravel框架进行开发，学一下新东西。近期应该会整理多一些文章。    

> Composer是 PHP 用来管理依赖（dependency）关系的工具。你可以在自己的项目中声明所依赖的外部工具库（libraries），Composer 会帮你安装这些依赖的库文件。

Laravel框架的功能部分是基于Composer，了解一下Composer对框架的学习与使用有一定的帮助。    

总结一下自己使用Composer的过程与查阅的参考资料。    

一种工具能解决某些具体的问题的属性。比如尺子能解决测量长度的问题。Composer将这样为你解决问题：    
a)问题：你有一个项目依赖于若干个库，其中一些库依赖于其他库。        
b)方法：你声明你所依赖的东西。        
c)解决：Composer 会根据你的声明，找出哪个版本的包需要安装，并安装它们（将它们下载到你的项目中）。    


## 安装

`测试环境：Ubuntu-14.04 + LAMP`    
全局安装，把`composer.phar`放在`PATH`中，这样就可以全局访问它了，在类Unix系统中，在使用时可以不加`php`前缀。    

执行下面两条命令即可：   
```
$ curl -sS https://getcomposer.org/installer | php
$ sudo mv composer.phar /usr/local/bin/composer
```
查看Composer版本号：
```
$ composer -V
Composer version 1.1.1 2016-05-17 12:25:44
```
Composer工具安装完成！
## 使用
上面提到Composer解决问题的步骤abc，细化这些步骤：       
a）问题：你正在创建一个项目，你需要一个库来做日志记录。你决定使用`monolog`第三方库，将它添加到你的项目中。    
```
$ mkdir MyProject
$ cd MyProject/
```
b)方法：创建一个 `composer.json` 文件，其中描述了项目的依赖关系。   
```
$ vim composer.json
{
    "require": {
        "monolog/monolog": "1.2.*"
    }
}
``` 
`composer.json`指出项目需要一些`monolog/monolog`的包，从 1.2 开始的任何版本。   

c)解决：使用`composer install`命令，解决和下载依赖。
```
$ composer install
```
```
$ ls
composer.json  composer.lock  vendor
```
可以看到，MyProject的文件中多了一个文件`composer.lock`和一个文件夹`vendor`。`composer.lock`文件的作用是锁定项目的版本。
vendor文件夹中包含了`composer.json`中指定的依赖monolog库文件和自动加载这些库文件的自动加载文件。依赖关系解决了，下面来看看具体如何在程序中使用monolog的功能。        
在MyProject文件夹下新建`app.php`文件。里面的代码如下：
```
<?php
require 'vendor/autoload.php';
$log = new Monolog\Logger('name');
$log->pushHandler(new Monolog\Handler\StreamHandler('app.log', Monolog\Logger::WARNING));
$log->addWarning('Foo');
```
执行这段代码
```
$ php app.php
```
没有报错，产生一个`app.log`的文件，这样，第三方库引用就成功了。

##  参考
1. [Composer中文文档](http://docs.phpcomposer.com/)
2. [composer.lock - 锁文件](http://docs.phpcomposer.com/01-basic-usage.html#composer.lock-The-Lock-File)
