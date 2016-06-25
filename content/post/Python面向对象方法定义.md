+++
date = "2016-06-23T23:00:00+08:00"
title = "Python面向对象方法定义"
author = "Chen Yuan"
tags = ["python"]
url = "post/ecs-setup-lamp"
draft = false
+++
使用Tasksel可以很方便地在ECS服务器上安装LAMP环境。    

```
//1.更新库，否则可能会出现tasksel aptitude failed的错误
$sudo apt-get update

//2.如果已经安装了可以跳过此步
$sudo apt-get install tasksel

//3.安装LAMP环境，根据提示完成安装
sudo tasksel install lamp-server
```

Tasksel提供了其他的软件包。
```
//查看选择需要的软件包
$sudo tasksel
```

当然，Ubuntu/Debian系统都可以通过这种方式安装LAMP环境。


##  参考
1. [Tasksel](https://help.ubuntu.com/community/Tasksel)

