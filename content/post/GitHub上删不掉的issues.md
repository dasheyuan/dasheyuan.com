+++
date = "2016-04-14T23:30:28+08:00"
title = "GitHub上删不掉的issues"
author = "Chen Yuan"
tags = ["git"]
url = "post/github-issues"
draft = false
+++
    
小结一下GitHub上的issues功能，很有意思。    

今天发现[Yikun](http://yikun.github.io)的博客中的图床地址很特别：cloud.githubusercontent.com。探究了一番之后发现他是用GitHub的issues的功能来写的博客，图片可以直接拖拽到issues的编辑框中，然后自动上传github的服务器，生成图床地址的。    

测试issues中上传图片的功能之后想删除测试的issue，但发现是删不掉的！！！如同版本提交commits，也是删不掉的。另外，对应issues的每一个操作都会记录下来。    
这样的设计应该是有原因的，现在想不明白，以后再探究吧。    
今天也大概了解了一下GitHub的API，也挺好玩的。

<!--more-->
## issues的属性
GitHub中每一个仓库都会有对应的一个issues的功能，issues中可以新建多个issue，每一个issue就像一篇文章，有标题和内容，还有评论。另外，每个issue都有唯一的编号“#n”。
issue可以设置：`Opened`和`Closed`两种状态。    

issue 还可以有额外的属性：    
Labels，标签。包括bug、invalid等，可以自定义。表示issue的类型，解决的方式。    
Milestone，里程碑。通常用来做版本管理，v0.1、v1.0之类的，也可以是任意自定义字符串。一个里程碑对应的所有 issue 都被关闭后，这个里程碑会被自动认为已经达成。    
Assignee，责任人。指定这个issue由谁负责来解决。    

## 个人如何利用issues的功能？
GitHub 的issue功能，对个人而言，就如同 TODO list。    
可以把所有想要在下一步完成的工作，如 feature 添加、bug 修复等，都写成一个个的 issue ，放在上面。既可以作为提醒，也可以统一管理。
另外，每一次 commit 都可以选择性的与某个 issue 关联。比如在 message 中添加 #n，就可以与第 n 个 issue 进行关联。
commit message title, #1
这个提交会作为一个 comment ，出现在编号为1的 issue 记录中。
如果添加：    

- fix #n
- fixes #n
- fixed #n
- close #n
- closes #n
- closed #n

比如
````
commit message title, fix #n
````
则可以**自动关闭**第 n 个 issue，即issue的状态从`Opened`变成了`Closed`。    

充分利用这些功能，让每一个 commit 的意义更加明确，可以起到了良好的过程管理作用，使得这个Git库的项目进度更加显然。而且，这也是项目后期，写文档的绝佳素材。

## 团队如何利用issues的功能？
对团队而言，这就是一个协作系统。    

现在，很多大公司的软件研发团队协作，都是通过`JIRA`来实现的。    
目前也流行很多非代码的团队协作，比如` teambition`、`Tower.im`、`Worktile`、`trello`等。    
其实，GitHub 的issues，就是一个轻量级协作系统。它的comment支持 GitHub Flavored Markdown，可以进行内容丰富的交流。    
Git本身就是分布式的代码版本控制软件，是为了程序员的协作而设计的。而 issues 的 Assignee 功能，就是这个在线协作系统的核心，足以让一群线上的开发者，一起完成一个软件项目。

最后，作为一个路人，也可以通过 issues 给别人的项目提 bug。
## 参考
1.[github issue是做什么的？](http://www.zhihu.com/question/22969033)