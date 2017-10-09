+++
date = "2016-07-25T23:00:00+08:00"
title = "CMake使用实例"
author = "Chen Yuan"
tags = ["linux"]
url = "post/cmake-example"
draft = false
+++
最近在阅读OAI(OpenAirInterface，一个开源的LTE协议实现项目)的源码，该项目是通过CMake来编译的，今天通过使用一实例来学习CMake。
实例的目录文件结构如下：
```
── TOP
    ├── CMakeCache.txt
    ├── Demo
    │   ├── CMakeLists.txt
    │   └── demo.c
    └── Hello
        ├── CMakeLists.txt
        ├── hello.c
        └── hello.h
```
/TOP是顶层目录，有两个子目录/Demo和/Hello，其中/Hello中包含/Demo调用的库函数代码。    
另外，每个目录下都会有一个CMakeLists.txt文件，文件内容如下：
<!--more-->  
```
/TOP/CMakeCache.txt
cmake_minimum_required (VERSION 2.8.11)
project (HELLO)
add_subdirectory (Hello)
add_subdirectory (Demo)

```
```
/TOP/Hello/CMakeCache.txt
add_library (Hello hello.c)
target_include_directories (Hello PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
```
```
/TOP/Demo/CMakeCache.txt
add_executable (helloDemo demo.c)
target_link_libraries (helloDemo LINK_PUBLIC Hello)
```
执行如下命令编译运行程序。
```
cd /TOP
cmkae .
make
 ./Demo/helloDemo 
```

##  参考
1. [CMAKE的使用](http://blog.csdn.net/netnote/article/details/4051620)
2. [CMAKE EXAMPLE](https://cmake.org/examples/)
3. [编译器的工作过程](http://www.ruanyifeng.com/blog/2014/11/compiler.html)


