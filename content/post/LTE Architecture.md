+++
date = "2016-03-21T23:00:01+08:00"
title = "LTE网格架构简介"
author = "Chen Yuan"
tags = ["lte"]
url = "post/lte-network-architecture"
draft = false
+++
![R12-E-UTRAN](/images/R12-E-UTRAN.png)    
（上图为Basic Configuration of a 3GPP Access PLMN supporting CS and PS services (using GPRS and EPS) and interfaces，蓝色的框图和接口都是属于LTE的）  

首先描述了E-UTRAN（LTE）网络架构参考模型，给出当前3GPP中描述的整体网络架构，包括2G、3G和4G；然后是介绍E-UTRAN（LTE）中的网元及其功能。        

    
说明：文中的图片参考的是3GPP版本12的规范文档。
<!--more-->

    
## 一、LTE网络架构模型 
### 1.非漫游架构 
非漫游架构有两种参考模型，这两种模型的区别：S-GW和P-GW是否是一个物理节点。    
![Non-roaming architecture for 3GPP accesse](/images/Non-roaming architecture for 3GPP accesse.png)
（上图为Non-roaming architecture for 3GPP accesse，S-GW和P-GW是分离的物理节点，通过S5接口连接）  
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
## 二、LTE网元及其功能 
### 1.E-UTRAN 接入网（AN）
在3G(The 3rd Generation Mobile Communications,第三代移动通信)网络中，接入网部分叫作UTRAN（Universal Terrestrial Radio Access Network，通用陆地无线接入网）。在LTE（Long Term Evolution，长期演进）网络中，因为演进关系，所以将接入网部分称为E-UTRAN（Evolved Universal Terrestrial Radio Access Network，演进的通用陆地无线接入网）。       
UTRAN（UMTS Terrestrial Radio Access Network）是UMTS的无线接入网（URAN）。UTRAN 允许使用者设备（UE）与核心网（CN）彼此沟通。UTRAN 内含基台（BS），被称为 Node Bs, 与 Radio Network Controllers (RNC)。Core Network (CN)是HLR，3G-SGSN和GGSN 组成。
![UTRAN Architecture](/images/UTRAN Architecture.png)    
（上图为 UTRAN Architecture，对比E-UTRAN和UTRAN可知，eNodeB除了具有原来3G网络中NodeB的功能外，还承担了原有RNC（Radio Network Controller，无线网络控制器）的大部分的功能）     
![E-UTRAN Architecture](/images/E-UTRAN Architecture.png)    
（上图为E-UTRAN Architecture，E-UTRAN由多个eNodeB（Evolved NodeB，演进的NodeB）组成，eNodeB之间通过X2接口彼此互联，eNodeB与EPC之间通过S1接口）   

![Functional Split between E-UTRAN and EPC](/images/Functional Split between E-UTRAN and EPC.png)  
（上图为LTE无线网络的功能与层次结构）
上图右边描述的是核心网三大网元的功能，比如MME主要的功能是鉴权、寻呼、位置更新和切换；S-GW的主要功能是移动性的锚点，也就是中转站；P-GW的主要功能是IP地址的分配以及分组数据包的过滤。上图左边介绍了无线网络的功能与层次结构，无线网络的功能包括：    

- 小区间无线资源的管理
- 无线承载的控制；
- 连接态移动性管理（切换）；
- 无线准入控制；
- eNodeB测量包括的配置与发送；
- 动态资源调度；

### 2.E-UTRAN 核心网（CN）
E-UTRAN核心网也称为EPC（Evolved Packet Core）,EPC主要包含了如下五大网元。


- MME（Mobility Management Entity，移动性管理实体）：这是EPC中主要的网元，从名称上就可以看到，MME负责管理和控制，相当于班长。
- S-GW（Serving GateWay，业务网关）：这也是EPC的主要网元，负责处理业务流。
- P-GW（PDN GateWay，PDN网关）：这也是EPC的主要网元，负责也PDN接口。所为PDN（Packet Data Network,分组数据网），通常指Internet。
- HSS（Home Subscribers Server，归属用户服务器）：这是HLR的升级，但是作用和HLR一样，负责存储用户的关键信息。
- PCRF（Policy and Charging Rules Function,策略以及计费规则功能）：这是用来控制服务质量Qos的网元。

#### 2.1 MME
MMS就是SGSN的控制面，负责处理用户业务的信令，用来完成移动用户的管理，并且与eNodeB、HSS和SGW进行交互。MME与HSS通过S6a接口连接，与SGW通过S11连接，而与基站eNodeB通过S1-MME接口连接，这些接口都是基于IP协议的。
   
主要功能：    

- 用户鉴权：这是移动通信系统最基本的功能，本功能需要与HSS交互。
- 移动性管理（寻呼、切换）：是移动通信系统最基本的功能。
- 漫游控制：当漫游用户接入系统后，MME需要访问漫游用户所属的HSS，从而得到该用户的信息。
- 网关选择：MME下会连接多个SGW，用户业务选择哪个SGW，由MME来控制。
- 承载管理：承载是WCDMA引入的概念，对应用户数据流。承载管理涉及承载的建立、释放等工作。
- TA列表管理：TA（Tracking Area,跟踪区）是LTE中引入的新术语，类似于WCDMA和GSM中系统的路由区RA，当终端离开所属TA，就需要TA更新。在LTE系统中，eNodeB可以属于多个TA，同样终端也可以归属于多一个TA，这样就为LTE系统带来了更多的灵活性。   

#### 2.2 Serving GW（S-GW）
S-GW的功能与MME相呼应。简单地说，SGW就是SGSN的业务面，负责处理用户的业务，用来完成移动数据业务的承载。并且与eNodeB、MME和P-GW等设备进行交互。其中，S-GW与MME通过S11接口连接，与PGW通过S5或S8接口连接（在漫游业务处理中区分），而与基站eNodeB通过S1-U接口连接，这些接口都是基于IP协议的。
S-GW的主要功能有：

- 漫游是分组核心网的接入
- LTE系统内部移动性的锚点；
- 空闲状态时缓存下行数据：对于闲置状态的UE，S-GW则是下行数据路径的终点，并且在下行数据到达时触发寻呼UE。
- 数据包路由和转发：S-GW负责用户数据包的路由和转发，同时也负责UE在eNodeB之间和LTE与其他3GPP技术之间移动时的用户面数据交换（通过端接的S4接口和完成2G/3G系统与P-GW之间的中继）。S-GW管理和存储UE的上下文，例如IP承载服务的参数，网络内部的路由信息​​。
- 计费；
- 合法监听：在合法监听的情况下，它还完成用户传输信息的复制。

#### 2.3 PDN GW（P-GW）
P-GW的功能非常类似GGSN，负责与Internet的接口，并且与PCRF和P-GW等设备进行交互。其中，P-GW与S-GW通过S5或S8接口连接，与PCRF通过Gx接口连接，与PDN通过SGi接口连接，这些接口都是基于IP协议的。P-GW不会直接与基站eNodeB打交道。
PGW的主要功能有：

- 外网互联的接入点；
- UE动态IP地址的分配；
- 数据包路由和转发；
- 计费；
- 策略控制执行（PCEF）；
- 合法监听；

P-GW的还有一个关键作用的是作为数据交换的核心组件，承载3GPP和非3GPP网络之间的数据交换，如与WiMAX和3GPP2（CDMA1X和EVDO）网络。    

#### 2.4 SGSN 
业务GPRS支撑节点（Serving GPRS Support Node，简称：SGSN）负责在它的地理位置服务区域内从移动台接收或向其发送数据包。它的任务包括数据包路由和传输、可移动性管理（mobility management，附着/分离和位置管理）、逻辑链路管理（logical link management）以及鉴权和计费功能。SGSN的位置寄存器存储所有在它上面注册的GPRS用户的位置信息（例如，当前蜂窝、当前VLR）和用户概要（例如IMSI、包数据网络中所使用的地址）。在LTE中，SGSN功能工作在MME中。

#### 2.5 PCRF
PCRF是策略和计费控制单元。PCRF功能中更详细的描述在TS23.203中。在非漫游的情况下，只存在一个单一的PCRF与一种UE的IP-CAN会话相关联的HPLMN。PCRF有Rx接口和Gx接口。漫游场景中，一个UE的IP-CAN会话相关联的可能有两个PCRFs：H-PCRF和V-PCRF。
#####  Home PCRF（H-PCRF）

#####  Visited PCRF（V-PCRF）

#### 2.6 HSS
HSS（Home Subscriber Server）是一个中央数据库，包含与用户相关的信息和订阅相关的信息。HSS的功能包括:移动性管理，呼叫和会话建立的支持，用户认证和访问授权。HSS基于pre-Rel-4归属位置寄存器（pre-Rel-4 HLR）和认证中心（AUC）。

## 参考
1. [3GPP TS 23.401](http://www.3gpp.org/DynaReport/23401.htm):"General Packet Radio Service (GPRS) enhancements for Evolved Universal Terrestrial Radio Access Network (E-UTRAN) access".
2. [3GPP TS 36.401](http://http://www.3gpp.org/DynaReport/36401.htm "3GPP TS 36.401"): "Evolved Universal Terrestrial Radio Access Network (E-UTRAN); Architecture description".  
3. 《LTE教程：原理与实现》孙宇彤 
4. http://blog.csdn.net/wangzhiyu1980/article/category/1182337