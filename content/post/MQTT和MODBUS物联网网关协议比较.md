+++
date = "2016-04-20T18:00:28+08:00"
title = "MQTT和Modbus物联网协议简介(译)"
author = "Chen Yuan"
tags = ["iot"]
url = "post/iot-mqtt-modbus-comparison"
draft = false
+++
    
翻译到最后才发现这是一篇广告文。呵呵。        
译文地址：https://software.intel.com/en-us/articles/a-comparison-of-iot-gateway-protocols-mqtt-and-modbus    

物联网不仅仅是新技术，它也是目前技术的整合，其中一个关键的属性就是通信。可用的通信（协议）方式是多种多样，但正是这大量的通信协议，在把那些“乱七八糟”的“物”连接到互联网中扮演着重要的角色。这篇文章将研究物联网中两个互补的通信协议：Modbus,一种短距离设备间通信的协议；Message Queuing Telemetry Transport（MQTT），一种可拓展的全球通信的互联协议。    
<!--more-->
Modbus是一个串口通信协议，约定俗成的工业设备连接的协议，在1979年首次被提出。20年后，MQTT协议才被提出来。但正是因为这两种协议赋予了嵌入式设备连接更大范围的互联网的能力。下图通过一个IoT网关，解释了这两种协议间的关系。    
![](https://lh3.googleusercontent.com/ebUheMIH0m3JfFyMaGAvUPh9F2mjai10HHT9NzIgJmqceflQLptVQD6xK9jy_qrQ_lTf9RfeuehIFcxi_IDyv4ItzWGQ6e_Z6IHSRNgF4_g8IBoE_pHUsLiWWqUxgn34eMJgllQZPMb0Z8zB3Q)    
## 一、Modbus
自从1979年首次提出后，Modbus基于多种物理链路（如:RS-485，注：RS-485一般指通信接口）,逐渐演进成一个被广泛使用的协议。Modbus协议的核心是主-从模式的串口通信协议。主设备发送一个请求给从设备，然后从设备返回一个响应给主设备。在一个标准的Modbus网络中，存在一个主设备和至多247中从设备（即使2字节的地址可以有效解决这个限制问题）。    
在RS-485应用中，主从设备间的通信的数据帧中包含一个功能编码，这个功能编码表示主设备要求从设备执行的操作，比如读一个离散的输入，或者是读一个FIFO队列，或者执行故障诊断。从设备基于这个功能编码进行操作并通过指定的字节进行回应。从设备可以使智能设备或者是传感器简单的设备。    
根据上面的描述，你可以看出Modbus协议的简单性，但是它的开放性使它在工业或者是数据监控系统中大受欢迎，并成为了约定俗成的标准协议。
## 二、MQTT
MQTT是一个专门为物联网交互设计的开放的、轻量级的M2M协议。MQTT协议组织的网络中包括一个MQTT Broker和多个MQTT agent，Broker负责协调MQTT agent间的交互，MQTT agent又可分为发布者Publishers和订阅者SubScribers两种，如下图所示。    
![](https://lh6.googleusercontent.com/JPumVlUmsaWJNLpqTyLXFNkNbkNVlwwLgXBv_2InlRrWyVSHLGlbdAZmFje8Z6lhxQeUKYK-r7OMGsU-iSwcqxrZ0AUbkxjvN5a9ME9ZanSsdo2WBIiuN8rO4tRGtmYDxht43ryEmc_NflkHUw)    
运行MQTT的要求是很小的，因为它就是为那些资源受限的嵌入式设备设计的。另外，由于数据封装很小，系统开销很小（相对于其他协议如HTTP），即使在带宽受限的网络中使用MQTT也能有效地通信。在3G网络中测试中，MQTT的吞吐量是REST HTTP的93倍。    
MQTT实现了一个最少方法集合的发布/订阅的模型，这些方法表示了特定主题的执行动作。代理连接到Broker，然后发布或者订阅主题，完成后代理断开Broker的连接。MQTT的方法定义如下：


- Connect 连接Broker
- Disconnect 断开Broker连接
- Publish 发布主题消息到Broker
- Subscribe 从Broker订阅主题
- Unsubscribe 从Broker中取消主题订阅

下图说明了Broker与Agents之间的关系。消息的发布者连接到Broker，同样，消息的订阅者也连接到Broker。然后，订阅者订阅主题为 `/home/alarms/1/status`的消息。当发布者有一条主题为 `/home/alarms/1/status`的消息发送到Broker后，Broker将这条消息发送给所有订阅了这个主题的订阅者。    
![](https://lh4.googleusercontent.com/cc2OtxQkkS_ytDRjHAdauwM0iEV6uDwLKjYEr4apkjLHqPCydyBYYW0vmR8Cr9xdHlWlDvcRgyRgAOVETOt-LNu9BgaXEHpCs6UGMFB3PsdgL95FtlcxbCnw-ChDNWdkIJu3QjOsa_btV-4FTA)    
注意到上述主题的结构，它与文件系统的树形结构很相似。这种分层的资源描述结构在REST协议中也很流行。    

MQTT甚至允许通配符形式的主题，当订阅者需要知道所有警告的状态，订阅的主题可以写成这样`/home/alarms/+/status`，当需要订阅/home下所有的主题时可以写成`/home/#`。

### MQTT服务质量QoS
MQTT允许订阅服务的质量，在MQTT中，存在三种等级的服务质量：   
 
- QoS 0 这种服务等级要求消息至多发送一次，若消息发送不需要确认时，这是一个一劳永逸的途径。
- QoS 1 这种服务等级要求消息至少发送一次，订阅者可能会收到多条相同的消息。
- QoS 2 这种服务等级最慢，但最安全消息的方式。QoS 2 意味着消息只发送一次，但这一次包含4个步骤的握手通信。

根据消息的重要程度选择发送的服务等级。


----------
后面部分有广告嫌疑，就不译了:(


## 参考
http://www.cnblogs.com/luomingui/archive/2013/06/14/Modbus.html