+++
date = "2016-05-07T18:00:28+08:00"
title = "SSH免密码登录远程主机"
author = "Chen Yuan"
tags = ["linux"]
url = "post/remote-login-without-password"
draft = false
+++
操作Linux系统一般会使用SSH工具进行远程登录系统操作。    

使用SSH工具远程登录系统，一般会使用Linux系统的账号和密码。    

使用密码登录，每次都必须输入密码，非常麻烦。好在SSH还提供了公钥登录，可以省去输入密码的步骤。    

所谓"公钥登录"，原理很简单，就是用户将自己的公钥储存在远程主机上。登录的时候，远程主机会向用户发送一段随机字符串，用户用自己的私钥加密后，再发回来。远程主机用事先储存的公钥进行解密，如果成功，就证明用户是可信的，直接允许登录shell，不再要求密码。    

另外，这个过程之前会有一个远程主机向用户发送远程主机公钥的过程，用户需要判断远程主机的公钥是否是真正的远程主机，不然就会带来安全问题（[中间者攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)）。

可以知道，上面的过程要用到**两对**密钥对。一对是用作远程主机向客户端安全通信的，一对用作是客户端向远程主机安全通信的。    

测试环境    

- Ubuntu 14.04安装openssh-server作为远程服务器，用户：bwa  IP：192.168.27.128    
- Ubuntu 14.04终端作为客户端 IP：192.168.27.3，或者使用Xshell工具登录    

测试步骤
<!--more-->
1、生成一对公私密钥对。可以使用`ssh-keygen`命令工具生成，也可以使用Xshell等工具生成，这里不需要考虑在客户端生成还是服务端系统中生成，只要符合服务器openssh-server的格式（OpenSSH）即可。
```
$ ssh-keygen
```
根据提示指定密钥保存的地方和密码（可以为空）。默认情况下，在`$HOME/.ssh/`目录，会新生成两个文件：`id_rsa.pub`和`id_rsa`。前者是公钥，后者是私钥。    

2、把`id_rsa.pub`公钥中的内容上传至远程服务器`$HOME/.ssh/authorized_keys`文件中。  
```
$ ssh-copy-id bwa@192.168.27.128
```
注意，`authorized_keys`并不是一个保存公钥文件的文件夹。它是一个文本文件，文本每一行可以保存一个公钥，因此可以保存多个公钥。    
   
3、把`id_rsa`私钥文件放在客户端`$HOME/.ssh/`中,通过`ssh-add`命令把私钥导入。
```
$ ssh-add ~/.ssh/id_rsa
```
4、修改`sshd_config`配置文件后就可以免密码登录了。
```
$ vim /etc/ssh/sshd_config 
#启用公告密钥配对认证方式 
PubkeyAuthentication yes
#设定PublicKey文件路径
AuthorizedKeysFile .ssh/authorized_keys    
#允许RSA密钥
RSAAuthentication yes
#禁止密码登录,如果启用,RSA认证登录就没有意义
PasswordAuthentication no
```
```
$ ssh bwa@192.168.27.128
```
OK

a.用户目录及公钥文件**权限**会影响验证过程，导致无法读取服务器上的公钥文件，无法正常登陆。    
```
用户目录权限为 755 或者 700就是不能是77x   
.ssh目录权限为755   
rsa_id.pub 及authorized_keys权限为644   
rsa_id权限为600   
```
b.Ubuntu系统日志文件`/var/log/auth.log`中记录了验证登录时出现的异常。     
b.1 用户目录权限异常时会出现    
```
bad ownership or modes fordirectory
```
b.2 `authorized_keys`是一个文件夹
```
.ssh/authorized_keys isnot a regular file
```
顺便了解了一下SSH端口转发的内容，还是挺有意思的，但现在用到的情况很少。
##  参考
1. [SSH原理与运用（一）：远程登录](http://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html)
2. [SSH原理与运用（二）：远程操作与端口转发](http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html)