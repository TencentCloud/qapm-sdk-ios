# QAPM

## 5.2.5

### improve
-  优化性能、对相应系统信息只在初始化时获取一次。

## 5.2.4

### feature
-  接入变更、涉及到需要打点的功能(QAPMLaunchProfile、QAPMFoomProfile、QAPMQQLeakProfile、QAPMWebViewProfile等)需要在头文件加入#import <QAPM/xxxx.h>
-  crash功能加入附件日志供业务分析。

## 5.2.3

### bugfix
-  修复若干问题、优化性能。

## 5.2.2

### bugfix
-  修复若干问题、优化性能。

## 5.2.1

### feature
- 上报域名的cer证书校验改为后台配置下发、避免出现证书过期问题。
- 上报协议变更、部分本地配置接口改为后台配置下发。
- 该版本上报数据在w.qapm.qq.com前端web页面查看。

### bugfix
- 修复灵犀平台扫描出来的隐私合规问题。
 
## 5.1.62

### bugfix
- iOS 16下HOOK IO操作下的死锁问题修复。
- 打开xcode的asan检测出现的死锁问题修复。

## 5.1.61

### improve
- 优化卡顿抓堆栈逻辑、强制退后台不抓堆栈。

### feature
-  增加一些debug日志信息。
 
## 5.1.6

### feature
- 更改启动耗时监控方案、适配iOS15的预热技术、去除预加载时间、启动结束点以首屏第一帧显示时间为准。
- 增加上报域名的cer证书校验流程。

### improve
- 根据隐私合规协议、不再取值openUDID作为设备ID。

## 5.1.5

### feature
- 更新crash组件、增加crash崩溃现场信息。
- 根据隐私合规协议、不再取值openUDID作为设备ID。

### bugfix
- 优化crash指标的计算方式。
  
## 5.1.4
