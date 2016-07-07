+++
date = "2016-05-17T23:00:00+08:00"
title = "GitHub的高级搜索功能"
author = "Chen Yuan"
tags = ["git"]
url = "post/github-advanced-search"
draft = false
+++

![](https://help.github.com/assets/images/help/search/advanced_search_demo.gif)
今天才发现GitHub是支持高级搜索功能的，使用了一下，功能很棒，就是搜索页面太“隐秘”了，现在才发现这个功能。

高级搜索链接：https://github.com/search/advanced    
也可以点击GitHub搜索框，回车后，出现的页面中提示支持Advanced Search功能。
<!--more-->
尝试一下查询PHP语言项目中，点赞超过1000的项目。    
通过在多种表单中填关键信息，会在搜索框中自动生成搜索表达式：
```
language:PHP stars:>1000
```
从搜索的结果可以大概了解到GitHub上PHP项目受欢迎的有哪些了。    

当然还有其他的高级搜索功能，系统地小结一下吧。
### 高级
1、指定代码拥有者，github, joyent    
2、指定代码仓库，twbs/bootstrap, rails/rails        
3、指定创建日期，>YYYY-MM-DD, YYYY-MM-DD    
4、指定代码语言种类，C、C++、PHP等    
### 仓库
1、指定点赞数量，0..100, 200, >1000        
2、指定分支数量，50..100, 200, <5    
3、指定仓库大小，100KB    
4、指定更新日期，<YYYY-MM-DD    
5、指定是否包含分支，not|and|only    
### 代码
1、指定代码扩展名，rb, py, jpg    
2、指定代码行数，100..8000, >10000    
3、指定路径，/foo/bar/baz/qux
### Issues
1、指定状态，open|closed    
2、指定评论数，0..100, >442     
3、指定标签labels    
4、指定发起者    
5、指定提及者    
6、指定安排者   
7、指定更新日期    
### 用户
1、指定名字    
2、指定位置    
3、指定Follow者的人数    
4、指定公开仓库的数量    
5、指定开发语言       

##  参考

1. [GitHub高级搜索页面](https://github.com/search/advanced)
