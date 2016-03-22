+++
date = "2016-03-21T23:00:01+08:00"
title = "E-UTRAN(LTE)网格架构"
author = "Chen Yuan"
tags = ["3gpp","network","architecture","utran","lte"]
url = "post/evolved-utran-network-architecture"
draft = false
+++

小组任务，安排整理一下3GPP R12网络架构的内容。今天查找的内容简单小结一下。   
内容介绍：    
一、E-UTRAN中的网元及其功能    
二、E-UTRAN网络架构参考模型    

<!--more-->
## 一、E-UTRAN中的网元及其功能 
### 1.E-UTRAN 接入网
在3G(The 3rd Generation Mobile Communications,第三代移动通信)网络中，接入网部分叫作UTRAN（Universal Terrestrial Radio Access Network，通用陆地无线接入网）。在LTE（Long Term Evolution，长期演进）网络中，因为演进关系，所以将接入网部分称为E-UTRAN（Evolved Universal Terrestrial Radio Access Network，演进的通用陆地无线接入网）。
### 2.MME 移动管理组件
### 3.Gateway 网关
#### 3.1 Serving GW（S-GW） 服务网关
#### 3.2 PDN GW（P-GW）分组数据网络网关
### 4.SGSN 
### 5.GERAN
### 6.UTRAN
### 7.PCRF
#### 7.1 Home PCRF（H-PCRF）
#### 7.2 Visited PCRF（V-PCRF）
### 8.HSS
## 二、E-UTRAN网络架构参考模型 
### 1.非漫游架构 
非漫游架构有两种参考模型，这两种模型区别不大，主要是S-GW和P-GW是一个网元。    
![Non-roaming architecture for 3GPP accesse](/images/Non-roaming architecture for 3GPP accesse.png")
（上图为Non-roaming architecture for 3GPP accesse，S-GW和P-GW是分离的网元，通过S5接口连接）  
![Non-roaming architecture for 3GPP accesses. Single gateway configuration option](/images/Non-roaming architecture for 3GPP accesses. Single gateway configuration option.png)
（上图为Non-roaming architecture for 3GPP accesses. Single gateway configuration option，S-GW和P-GW是一个网元）
### 2.漫游架构
漫游架构有三种参考模型，其中第1种是本地路由业务，P-GW位于本地网络侧；第2和第3种是非本地路由业务，P-GW位于访问网络侧。第2与第3种的区别是AF（Application Function）在哪一侧。
![Roaming architecture for 3GPP accesses. Home routed traffic](/images/Roaming architecture for 3GPP accesses. Home routed traffic.png)
（上图为Roaming architecture for 3GPP accesses. Home routed traffic，P-GW位于HPLMN侧）
![Roaming architecture for local breakout, with home operator's application functions only](/images/Roaming architecture for local breakout, with home operator's application functions only.png)
（上图为Roaming architecture for local breakout, with home operator's application functions only，P-GW位于VPLMN侧，同时AF功能在HPLMN侧，即H-PCRF通过Rx接口连接本地运营商的IP服务）
![Roaming architecture for local breakout, with visited operator's application functions only](/images/Roaming architecture for local breakout, with visited operator's application functions only.png)
（上图为Roaming architecture for local breakout, with visited operator's application functions only，P-GW位于VPLMN侧，同时AF功能在VPLMN侧，即V-PCRF通过Rx接口连接访问地运营商的IP服务）
## 参考
1. [3GPP TS 23.401](http://www.3gpp.org/DynaReport/23401.htm):"General Packet Radio Service (GPRS) enhancements for Evolved Universal Terrestrial Radio Access Network (E-UTRAN) access".
2. [3GPP TS 36.401](http://http://www.3gpp.org/DynaReport/36401.htm "3GPP TS 36.401"): "Evolved Universal Terrestrial Radio Access Network (E-UTRAN); 
Architecture description".  