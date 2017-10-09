+++
date = "2017-05-07T22:00:00+08:00"
title = "C++测试工具Valgrind"
author = "Chen Yuan"
tags = ["C++"]
url = "post/cpp-test-tool-valgrind"
draft = false
+++
    
	
# 引言
测试C++程序时，我们通常会在意两件事：

- 运行结果是否正确？
- 是否发生了内存泄漏？    

第一件事所有编程语言都需要在意，通常是给程序各种输入，检验输出的正确性，Catch是一个轻巧的单元测试框架，学习起来非常容易；    

第二件事应该是C/C++独有的，需要跟踪运行时动态分配的内存，虽然可以自行重载new/delete运算符做到这一点，但Valgrind可以为我们检测绝大多数内存相关问题（包括内存泄漏、数组越界、使用未初始化变量等）。

<!--more-->

# 1. 安装配置Valgrind
安装Valgrind只要一步：
```
sudo apt-get install valgrind
```
# 2. 使用Valgrind
Valgrind其实是一套工具的集合，可以用--tool参数指定使用哪种工具，默认使用的是内存检测工具Memcheck。Valgrind使用更加简单，比如编译链接后的可执行文件是test，那么检测内存泄漏情况只需使用命令：
```
valgrind --leak-check=yes ./test
```
用Valgrind检测会得到很长的报告，只需看最后的leak summary。

# 深入了解Valgrind
## Linux程序内存映射
![image](http://d1hyf4ir1gqw6c.cloudfront.net//wp-content/uploads/Memory-Layout.gif)    

一个典型的Linux C程序内存空间由如下几部分组成：    

- 代码段（.text）：这里存放的是CPU要执行的指令。代码段是可共享的，相同的代码在内存中只会有一个拷贝，同时这个段是只读的，防止程序由于错误而修改自身的指令。
- 初始化数据段（.data）：这里存放的是程序中需要明确赋初始值的变量，例如位于所有函数之外的全局变量：int val="100"。需要强调的是，以上两段都是位于程序的可执行文件中，内核在调用exec函数启动该程序时从源程序文件中读入。
- 未初始化数据段（.bss）：位于这一段中的数据，内核在执行该程序前，将其初始化为0或者null。例如出现在任何函数之外的全局变量：int sum;
- 堆（Heap）：这个段用于在程序中进行动态内存申请，例如经常用到的malloc，new系列函数就是从这个段中申请内存。
- 栈（Stack）：函数中的局部变量以及在函数调用过程中产生的临时变量都保存在此段中。

## 什么是Valgrind?
Valgrind是一套Linux下，开放源代码（GPL V2）的仿真调试工具的集合。Valgrind由内核（core）以及基于内核的其他调试工具组成。内核类似于一个框架（framework），它模拟了一个CPU环境，并提供服务给其他工具；而其他工具则类似于插件 (plug-in)，利用内核提供的服务完成各种特定的内存调试任务。
    
Valgrind包括如下一些工具：

- Memcheck：这是valgrind应用最广泛的工具，一个重量级的内存检查器，能够发现开发中绝大多数内存错误使用情况，比如：使用未初始化的内存，使用已经释放了的内存，内存访问越界等。这也是本文将重点介绍的部分。
- Callgrind：它主要用来检查程序中函数调用过程中出现的问题。**可以结合 kcachegrind 可视化工具使用。**
- Cachegrind：它主要用来检查程序中缓存使用出现的问题。
- Helgrind：它主要用来检查多线程程序中出现的竞争问题。
- Massif：它主要用来检查程序中堆栈使用中出现的问题。
- Extension：可以利用core提供的功能，自己编写特定的内存调试工具。

Memcheck 能够检测出内存问题，关键在于其建立了两个全局表。    
 
1. Valid-Value 表：
对于进程的整个地址空间中的每一个字节(byte)，都有与之对应的 8 个 bits；对于 CPU 的每个寄存器，也有一个与之对应的 bit 向量。这些 bits 负责记录该字节或者寄存器值是否具有有效的、已初始化的值。    

1. Valid-Address 表
对于进程整个地址空间中的每一个字节(byte)，还有与之对应的 1 个 bit，负责记录该地址是否能够被读写。   

## 检测原理：    
- 当要读写内存中某个字节时，首先检查这个字节对应的 A bit。如果该A bit显示该位置是无效位置，memcheck 则报告读写错误。
- 内核（core）类似于一个虚拟的 CPU 环境，这样当内存中的某个字节被加载到真实的 CPU 中时，该字节对应的 V bit 也被加载到虚拟的 CPU 环境中。一旦寄存器中的值，被用来产生内存地址，或者该值能够影响程序输出，则 memcheck 会检查对应的V bits，如果该值尚未初始化，则会报告使用未初始化内存错误。


## Valgrind 使用         

用法: valgrind (options) prog-and-args (options):         常用选项，适用于所有Valgrind工具   

- -tool=<name> 最常用的选项。运行 valgrind中名为toolname的工具。默认memcheck。
- h –help 显示帮助信息。
- -version 显示valgrind内核的版本，每个工具都有各自的版本。
- q –quiet 安静地运行，只打印错误信息。
- v –verbose 更详细的信息, 增加错误数统计。
- -trace-children=no|yes 跟踪子线程? (no)
- -track-fds=no|yes 跟踪打开的文件描述？(no)
- -time-stamp=no|yes 增加时间戳到LOG信息? (no)
- -log-fd=\<number\> 输出LOG到描述符文件 (2=stderr)
- -log-file=\<file\> 将输出的信息写入到filename.PID的文件里，PID是运行程序的进行ID
- -log-file-exactly=\<file\> 输出LOG信息到 file
- -log-file-qualifier=\<VAR\> 取得环境变量的值来做为输出信息的文件名。 (none)
- -log-socket=ipaddr:port 输出LOG到socket ，ipaddr:port    

## LOG信息输出    

- -xml=yes 将信息以xml格式输出，只有memcheck可用
- -num-callers=\<number\> show \<number\> callers in stack traces (12)
- -error-limit=no|yes 如果太多错误，则停止显示新错误? (yes)
- -error-exitcode=\<number\> 如果发现错误则返回错误代码 (0=disable)
- -db-attach=no|yes 当出现错误，valgrind会自动启动调试器gdb。(no)
- -db-command=\<command\> 启动调试器的命令行选项(gdb -nw %f %p)    

## 适用于Memcheck工具的相关选项：    

- -leak-check=no|summary|full 要求对leak给出详细信息? (summary)
- -leak-resolution=low|med|high how much bt merging in leak check (low)
- -show-reachable=no|yes show reachable blocks in leak check? (no)    

## 常见内存问题：
1. 使用未初始化内存
2. 内存读写越界
3. 内存覆盖
4. 动态内存管理错误
    - 申请和释放不一致
    - 申请和释放不匹配
    - 释放后仍然读写
1. 内存泄漏

# 参考
1.(valgrind 的使用简介)(http://blog.csdn.net/sduliulun/article/details/7732906)
