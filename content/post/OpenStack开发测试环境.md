+++
date = "2016-04-01T15:22:01+08:00"
title = "搭建OpenStack/DevStack远程开发调试环境"
author = "Chen Yuan"
tags = ["openstack","neutron"]
url = "post/openstack-dev-environment"
draft = false
+++

在开始写这篇文章的时候，有种感慨：搭建OpenStack/DevStack开发调试环境**成本**真不低。涉及的技术太多了。不知道什么时候对OpenStack的开发与PHP一样，可以一键部署开发环境呢？    

这篇文章记录的是如何搭建OpenStack/DevStack的开发环境，具体调试过程将结合一个Neutron API新建的例子。

这是在网上查找参考的基础上，自己进行的测试，记录下来希望加深自己的理解。
<!--more-->
## 开发环境简介
我配置的环境：Win10系统台式机，用到的软件有PyCharm，VMware Workstation，XShell和win-sshfs。另外虚拟机运行的是Ubuntu 14.04 Server板，DevStack的安装在Ubuntu中。简单的模型框架如下图。   
![OpenStack debug](/images/OpenStack debug.png)   
 
这种调试方式有优点，也有缺点。优点有可以通过文件映射工具sshfs，直接对DevStack中的代码进行调试；PyCharm图形化界面调试，过程简单，对开发人员来说最好不过；代码是开发管理直接使用git。缺点很明显，开头也提到过，这种搭建配置过程`很复杂`。  
  
另外，在[Python 代码调试技巧](http://https://www.ibm.com/developerworks/cn/linux/l-cn-pythondebugger/)一文中提到了pdb、PyDev、PyCharm、日志等几种常见的调试方法都可以作为OpenStack开发调试的方法，这里不赘述。

## 搭建步骤小结
下面步骤是我查阅网上资料和实测后的理解，详细的步骤可以参考我给出的链接。    
1）DevStack的安装。网上教程很多，建议参考陈沙克老师的安装方法，[Ubuntu 14.04 Devstack安装](http://www.chenshake.com/install-ubuntu-14-04-devstack/)，安装完成后，可以先新建实例测试一下。PS：保存快照。 

    
2）配置PyCharm远程调试环境。具体过程可以参考我另外一篇文章[PyCharm远程调试](http://www.dasheyuan.com/post/pycharm-remote-debugging/)。熟悉PyCharm这种远程调试机制，OpenStack的调试开发也就是建立在这种机制上的。    
 
3） [sshfs文件映射](http://www.softpedia.com/get/Network-Tools/Telnet-SSH-Clients/win-sshfs.shtml)。把虚拟机/opt/stack的代码映射到Win系统中，在PyCharm上修改的代码时会与虚拟机上DevStack的代码同步。PS：注意权限问题。映射/opt/stack文件前，应该为stack用户创建密码，因为/opt/stack文件件的权限归stack用户所有。当然也可以通过密钥的方式进行文件映射。
![win-sshfs](/images/win-sshfs.jpg)     

4）[使用screen查看OpenStack进程](www.dasheyuan.com/post/screen-openstack/)。了解screen可以帮助我们在搭建好的开发环境中调试的理解。    
## 具体调试过程
调试的过程参考在这篇博客中的新建[Neutron API](http://www.sdnlab.com/15223.html)的例子，具体操作有些不同，注意区别。（建议每一个操作和每一行代码都一个一个字母敲）。   

1）在Neutron API的Paste deploy配置文件中，增加所需的资源配置。编辑api-paste.ini文件。
```
$ vim /etc/neutron/api-paste.ini
```
在composite:neutron部分，增加一行代码/pastetest:pastetest：
```
[composite:neutron]
use = egg:Paste#urlmap
/: neutronversions
/v2.0: neutronapi_v2_0
/pastetest:pastetest
```
然后增加如下两行代码：
```
[app:pastetest]
paste.app_factory = neutron.api.v2.test:PasteTest.factory
```
2）切换到/opt/stack/neutron/neutron/api/v2源码包目录下,新建test.py，内容如下：
```
#!/usr/bin/env python
#coding=utf-8

import webob.dec
from neutron import wsgi

class PasteTest(object):
    @classmethod
    def factory(cls, global_config, **local_config):
        return cls(**local_config)

    @webob.dec.wsgify(RequestClass=wsgi.Request)
    def __call__(self,req):
        import pydevd
        pydevd.settrace('192.168.27.1', port=51234, ...
            stdoutToServer=True, stderrToServer=True)
        a=10
        print a
        response = webob.Response()
        response.body = "Hello Neutron API!"
        return response
```
3）调整下eventlet的monkey patch。将\neutron\neutron\common\eventlet_utils.py中eventlet.monkey_patch()改成eventlet.monkey_patch(all=False, socket=True, time=True, thread=False)。
```
eventlet.monkey_patch(all=False, socket=True, time=True, thread=False)
```

4）通过screen，重启Neutron（q-svc）服务。
```
$ /usr/local/bin/neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini & echo $! >/opt/stack/status/stack/q-svc.pid; fg || echo "q-svc failed to start" | tee "/opt/stack/status/stack/q-svc.failure"
```
5）切换至PyCharm，打开配置好的“q-svc”远程调试服务器。调用新建的API，可通过在浏览器中输入 `http://192.168.27.128:9696/pastetest` 调用。这时可发现，PyCharm进入了代码调试的模式。
![OpenStack debug-1](/images/OpenStack debug-1.jpg)    


## 小结
至此，OpenStack/DevStack开发调试平台的搭建已经粗略地介绍完了。每一个步骤所包含的技术点多很多，需要耐心地去尝试整合这些技术。限于现在的水平，无法一一去展开。


 

## 参考
1. [Ubuntu 14.04 Devstack安装-陈沙克日志](http://www.chenshake.com/install-ubuntu-14-04-devstack/)
2. [Devstack配置文件local.conf参数说明-陈沙克日志](http://www.chenshake.com/local-conf-devstack-profile-parameter-description/)
3. [使用DEVSTACK搭建OPENSTACK可remote debug的开发测试环境](http://bingotree.cn/?p=687)
4. [优雅地调试OpenStack](http://yikun.github.io/2016/02/23/%E4%BC%98%E9%9B%85%E5%9C%B0%E8%B0%83%E8%AF%95OpenStack)
5. [深入探秘Neutron API](http://www.sdnlab.com/15223.html)