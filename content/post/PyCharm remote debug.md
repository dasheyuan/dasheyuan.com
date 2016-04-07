+++
date = "2016-03-30T15:22:01+08:00"
title = "PyCharm远程调试"
author = "Chen Yuan"
tags = ["openstack","pycharm"]
url = "post/pycharm-remote-debugging"
draft = false
+++ 
    
PyCharm提供两种远程调试(Remote Debugging)的方式:    

- 配置远程的解释器（remote interpreter）
- 配置Python调试服务器（Python Debug Server）

本文主要介绍Python Debug Server配置与使用。
<!--more-->

## Python Debug Server参考模型
![PyCharm remote debug](/images/PyCharm remote debug.png")  
（上图为Python Debug Server模型，仅供参考）    

如上图所示，PyCharm远程调试方式的模型其实就是一个典型的Server/Client模型。模型左侧，Server服务运行在本地主机PyCharm中。配置Debug Server完成后就可以启动这个服务器。服务器启动后，就是等待Client客户端的接入。模型右侧，需要调试的Python程序通过调用pycharm-debug提供的`pydevd`库，然后连接到服务端。这样，本地主机就可以使用PyCharm调试远程主机运行的Python程序了，调试的方法与直接调试本地Python程序一样。
## Python Debug Server配置使用
### 1.服务端配置
首先在Run/Debug Configuration中添加Python Remote Debug服务。
![server configurate](/images/PyCharm remote debug-2.jpg")  
（上图为Python Debug Server配置流程）    
**注：**服务器命名和IP地址是必须配置的。若端口没有配置，则在服务器启动时随机分配；若路径映射没有配置，则在客户端连接服务端成功后PyCharm再提示选择配置。

服务器**启动**后会提示以下信息：

```
Starting debug server at port 51234    
Use the following code to connect to the debugger:    
import pydevd    
pydevd.settrace('192.168.27.1', port=51234, stdoutToServer=True, stderrToServer=True)    
Waiting for process connection...
```
其中，这两行代码需要嵌入到远程调试的Python代码中，这两行代码包含了服务器监听的IP地址和端口等信息。
```  
import pydevd    
pydevd.settrace('192.168.27.1', port=51234, stdoutToServer=True, stderrToServer=True)    

```
### 2.客户端配置
参考模型中提到，远程主机需要配置`pydev`库。而提供库的源文件在PyCharm安装路径下的`debug-eggs`目录中，其中`pycharm-debug.egg`对应的是版本2，`pycharm-debug-py3k.egg`对应的是版本3。
把`pycharm-debug.egg`文件复制到**远程主机**，然后通过easy_install命令安装。
PS：复制的方法有多种，通过ssh可以传输文件，注意权限问题。
```
$ sudo easy_install pycharm-debug.egg
```
然后把上面提及的两行代码嵌入到需要调试的Python程序中。
```
#demo.py
print "remote debug"
#嵌入服务器信息的代码，进入调试状态
import pydevd
pydevd.settrace('192.168.27.1', port=51234, stdoutToServer=True, stderrToServer=True)

print "code need to debug"

#离开调试模式
pydevd.stoptrace()
```
### 3.调试方式

调试方式比较简单，首先启动远程主机的程序，进入调试状态。然后返回本地主机的PyCharm界面进行调试。
```
$ python demo.py 
remote debug

```

![debug output](/images/PyCharm remote debug-3.jpg")  
（上图为本地主机PyCharm调试界面说明）    
此步骤之前需要配置路径映射关系，即远程主机中的代码如何映射到本地主机中，本文用到的是win-sshfs工具，工具的使用方式就有时间再介绍。


## 参考
1. [https://www.jetbrains.com/pycharm/help/remote-debugging.html](https://www.jetbrains.com/pycharm/help/remote-debugging.html)
2. [优雅地调试OpenStack](http://yikun.github.io/2016/02/23/%E4%BC%98%E9%9B%85%E5%9C%B0%E8%B0%83%E8%AF%95OpenStack)