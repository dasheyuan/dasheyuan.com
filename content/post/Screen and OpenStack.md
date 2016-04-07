+++
date = "2016-03-29T14:00:01+08:00"
title = "使用screen查看OpenStack进程"
author = "Chen Yuan"
tags = ["openstack","devstack"]
url = "post/screen-openstack"
draft = false
+++ 


介绍screen在openstack调试中的使用，整理screen的内容及快捷键。    

[DevStack安装](http://www.chenshake.com/install-ubuntu-14-04-devstack/)完成后，即OpenStack的平台搭建成功了，可以通过dashboard对平台进行使用。如果需要进一步调试和开发openstack，可以了解一下screen相关的内容。通过screen可以查看OpenStack运行的进程，最主要的是终止和重启需要调试的进程。
<!--more-->
## 一、使用screen查看OpenStack进程
首先得有个通俗的概念，DevStack安装完成后，OpenStack的进程是运行在“后台”的，如何把运行在“后台”的进程信息打印到屏幕上呢？答案是使用`screen`。

几个常用的screen命令
```
#获取screen列表
screen -list
#打开指定screen
screen -x stack
#Next
CTRL+a+n
#Previous 
CTRL+a+p
#List显示screen列表
CTRL+a+"
#Detach断开当前screen
CTRL+a+d
```
实践操作    
获取screen列表
```
$ screen -list
There is a screen on:
	81151.stack	(03/26/16 23:43:14)	(Detached)
1 Socket in /var/run/screen/S-stack.
```
打开stack的screen
```
$ screen -x stack
Cannot open your terminal '/dev/pts/26' - please check.
#权限问题，修改/dev/pts/26权限
$ sudo chmod 777 /dev/pts/26
```
```
$ screen -x stack
#stack的screen有多个List，屏幕输出最后一行，带*就是当前List显示的内容
#CTRL+a+n/p切换当前List
#CTRL+a+d退出当前scree
#CTRL+a+"显示当前所有的List（测试时无法打开）

 18$(L) c-api  19$(L) c-sch  20$(L) c-vol   21$(L) horizon*
```


## 二、终止和重启进程
screen与terminal一样，通过CTRL+c终止当前进程。所以，通过在screen中切换至需要终止的进程List，CTRL+c当前进程。
```
n-api failed to start
```
重启进程，通过方向键向上，找到终止掉的进程命令，拷贝到任意terminal或当前screen运行即可。
```
$ /usr/local/bin/nova-api & echo $! >/opt/stack/status/stack/n-api.pid; \
fg || echo "n-api failed to start" | tee \
"/opt/stack/status/stack/n-api.failure"
```


----------
下面的内容摘自参考资料，部分删改。
## 三、引入screen的原因
当通过ssh远程登录到Linux服务器时，经常遇到一些需要长时间运行的任务，比如系统备份、FTP传输等。必须等待这些任务进行完才可以进行其他操作，另外，在此期间不能关掉窗口或者断开连接，否则会终止掉这些进程。

元凶：SIGHUP 信号
让我们来看看为什么关掉窗口/断开连接会使得正在运行的程序死掉。
在Linux/Unix中，有这样几个概念：    

- 进程组（process group）：一个或多个进程的集合，每一个进程组有唯一一个进程组ID，即进程组长进程的ID。
- 会话期（session）：一个或多个进程组的集合，有唯一一个会话期首进程（session leader）。会话期ID为首进程的ID。
- 会话期可以有一个单独的控制终端（controlling terminal）。与控制终端连接的会话期首进程叫做控制进程（controlling process）。当前与终端交互的进程称为前台进程组。其余进程组称为后台进程组。

根据POSIX.1定义：    

- 挂断信号（SIGHUP）默认的动作是终止程序。
- 当终端接口检测到网络连接断开，将挂断信号发送给控制进程（会话期首进程）。
- 如果会话期首进程终止，则该信号发送到该会话期前台进程组。
- 一个进程退出导致一个孤儿进程组中产生时，如果任意一个孤儿进程组进程处于STOP状态，发送SIGHUP和SIGCONT信号到该进程组中所有进程。

因此当网络断开或终端窗口关闭后，控制进程收到SIGHUP信号退出，会导致该会话期内其他进程退出。

简单来说，screen是一个可以在多个进程之间多路复用一个物理终端的窗口管理器。screen中有会话的概念，用户可以在一个screen会话中创建多个screen窗口，在每一个screen窗口中就像操作一个真实的telnet/SSH连接窗口那样。

### 快捷键

| C-a ?     | 显示所有键绑定信息|
| :---      | :---------------|
| C-a w     | 显示所有窗口列表|
| C-a C-a   | 切换到之前显示的窗口|
| C-a c     | 创建一个新的运行shell的窗口并切换到该窗口|
| C-a n     | 切换到下一个窗口   |
| C-a p     | 切换到上一个窗口   |
| C-a 0..9  | 切换到窗口0..9         |
| C-a a     |  发送C-a到当前窗口        |
| C-a d     |  暂时断开screen会话     |
| C-a k     | 杀掉当前窗口       |
| C-a [     | 进入拷贝回滚模式     |


## 参考
1. [http://www.ibm.com/developerworks/cn/linux/l-cn-screen/](http://www.ibm.com/developerworks/cn/linux/l-cn-screen/)