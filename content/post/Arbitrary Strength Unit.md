+++
date = "2016-04-07T23:30:28+08:00"
title = "LTE终端信号强度单位dBm与asu的关系"
author = "Chen Yuan"
tags = ["lte"]
url = "post/arbitrary-strength-unit"
draft = false
+++
    
最近在看LTE的入门通识相关的资料。LTE终端进行小区选择的过程中，会测量小区参考信号的信号强度RSRP，然后根据测量到的RSRP，通过选择算法进行判决，判决通过后，终端就会与目标小区同步。选择算法中提到一个值Q_rxlevmin，指可驻留的目标小区需要的最低RSRP，通常为-124dBm。    

顺手拿去手机，想看一下手机上有没有信号强度相关的信息。找到一组数据“信号强度 -61dBm 26asu”。dBm是常见的功率参考单位，那么asu又是什么呢？    
asu也是一种信号强度参考（相对）单位，一般出现在Android系统的手机中。    
asu，维基百科中指的是Arbitrary Strength Unit，百度却是Alone Signal Unit，我没有找到确实的出处。后来一想，这在Android API中就指的是一个相对于dBm的整形变量，具体定义是什么并不重要了。    
<!--more-->
![Arbitrary Strength Unit](/images/Arbitrary Strength Unit.png)
（上图是双模终端Android系统信息的截图）    
     
不同的制式的系统，dBm与asu的有不同的关系。    
1、在GSM系统中，asu与RSSI(Received Signal Strength Indicator）有关：    
```
dBm = 2 × asu - 113
    
asu的取值范围是0~31，99表示未知或不可测量。
```    
2、在WCDMA系统中，asu与RSCP (Received Signal Code Power）有关：    
```
dBm = asu - 116 
  
asu的取值范围是-5~91，255表示未知或不可测量。
``` 
3、在LTE系统中，asu与RSRP (Reference Signal Received Power）有关：    
```
dBm = asu - 140 
   
asu的取值范围是0~97。    
asu = 0 指的是 RSRP < -140 dBm     
asu = 97 值的是 RSRP > -44 dBm 
```
## 参考
1. [Wiki](https://en.wikipedia.org/wiki/Mobile_phone_signal#ASU)

