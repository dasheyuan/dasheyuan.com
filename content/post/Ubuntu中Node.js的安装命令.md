---
date: 2016-05-12T22:00:28+08:00
description: ""
tags: ["linux"]
title: "Ubuntu中Node.js的安装方法"
topics: []
draft: false
url: post/ubuntu-install-nodejs-scripts
---

最近重新学习一下JavaScript，了解Node.js是什么，给自己充充电。    

Ubuntu直接使用`sudo apt-get install nodejs`命名安装Node.js无法安装最新版本。    

[官网](https://nodejs.org/en/download/package-manager/)上给出来的安装命令可以解决这个问题:
```
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -

sudo apt-get install -y nodejs
```

curl `-s` 静默状态，即不输出任何信息。    

curl `-L` 重定向地址，即如果当前地址发生重定向，获取重定向的地址的内容(参考1)。   

sudo `-E` 在sudo执行时保留当前用户已存在的环境变量,不会被sudo重置。    

sudo apt-get install `-y` 默认安装过程中的确认步骤(yes)。    

bash `-`（参考2）      
### “关于减号 - 的用途    
管线命令在 bash 的连续的处理程序中是相当重要的！另外，在 log file 的分析当中也是相当重要的一环， 所以请特别留意！另外，在管线命令当中，常常会使用到前一个命令的 stdout 作为这次的 stdin ， 某些命令需要用到文件名 (例如 tar) 来进行处理时，该 stdin 与 stdout 可以利用减号 "-" 来替代， 举例来说：
```
$ tar -cvf - /home | tar -xvf -
```
上面这个例子是说：『我将 /home 里面的文件给他打包，但打包的数据不是纪录到文件，而是传送到 stdout； 经过管线后，将 tar -cvf - /home 传送给后面的 tar -xvf - 』。后面的这个 - 则是取用前一个命令的 stdout， 因此，我们就不需要使用 file 了！这是很常见的例子喔！注意注意！    
### ”

<!--more-->
##  参考
1. [curl网站开发指南](http://www.ruanyifeng.com/blog/2011/09/curl.html)
2. [鸟哥的Linux私房菜](http://vbird.dic.ksu.edu.tw/linux_basic/0320bash.php#pipe_7)