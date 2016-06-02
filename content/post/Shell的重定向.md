---
date: 2016-03-16T22:11:03+08:00
description: ""
tags: ["linux"]
title: "Shell重定向2>&1的理解"
topics: []
draft: false
url: /post/shell-redirect
---

## 一、系统文件描述符
 标准输入	0    
 标准输出	1    
 标准错误输出	2    

测试用例
```
$ cat mytest.sh 
echo "my test"
mytest
$ ./mytest.sh 
my test  #标准输出
./mytest.sh: line 2: mytest: command not found #标准错误输出
```
<!--more-->

## 二、重定向输出
### 1.>文件名
```
$ ./mytest.sh > out.txt
./mytest.sh: line 2: mytest: command not found
$ cat out.txt
mytest
```
标准输出的内容保存到文件out.txt中,标准错误输出仍然打印出来。

### 2.>>文件名
```
$ ./mytest.sh >> out.txt
```
标准输出的内容增加到文件out.txt中。

### 3.&>文件名
```
$ ./mytest.sh &> out.txt
$ cat out.txt
my test
./mytest.sh: line 2: mytest: command not found
```
标准输出和标准错误输出的内容保存到文件out.txt中，同理
`&>>`为增加到文件中。

### 4.>&文件描述符
```
$ ./mytest.sh > out.txt 2>&1
$ cat out.txt
my test
./mytest.sh: line 2: mytest: command not found
```
标准输出的内容保存到文件out.txt中，然后将标准错误输出重定向到与标准输出相同的地方。

## 三、重定向输入
```
$ more < lsout.txt
```