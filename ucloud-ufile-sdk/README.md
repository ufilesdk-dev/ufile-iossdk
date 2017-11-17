# [UFile SDK]()

- 1 [功能特性](#1)
- 2 [集成介绍](#2)
  - 2.1[系统要求](#2.1)
  - 2.2[下载集成](#2.2)
- 3 [常见问题](#3)
- 4 [反馈和建议](#4)

<a name="1"></a>

## 一. 功能特性
- [x]  普通上传
- [x]  快速上传
- [x]  文件方式上传
- [x]	普通下载
- [x]	下载到文件
- [x]  选择范围下载
- [x]	 查询文件
- [x]  分片上传
<a name="2"></a>

## 二. 下载集成
```

git clone https://github.com/ufilesdk-dev/ufile-iossdk.git

```
在ucloud-ufile-sdk目下打开OC文件,点击OC文件下的UFileSDK.xcworkspace,工程给出了使用UFileSDK的demo

### 2.2.1 导入静态库
将lib文件夹直接拉到XCode工程中,包括include文件夹和libUFileSDK.a库,include文件夹下共有5个文件,分别有UFileAPI.h,UFileSDK.h, UFileAPIUtils.h, UFileHttpManager.h,和version.h

<a name="2.2.1"></a>

### 2.2.2 依赖库说明

  工程所需引用的系统 framework,如下: 

| framework              |
| ---------------------- |
|UIKit.framework|
| Foundation.framework |
| libstdc++.6.0.9.tbd   |

<a name="2.2.2"></a>

### 2.3.3 iOS9中ATS配置

由于iOS9引入了AppTransportSecurity(ATS)特性，要求App访问的网络使用HTTPS协议，如果不做特殊设置，http请求会失败，所以需要开发者在工程中增加设置以便可以发送http请求，如下：

在info plist中增加字段：

\< key\>NSAppTransportSecurity\< /key\>  
\< dict\>  
 \< key\>NSAllowsArbitraryLoads\< /key\>  
 \< true\>  
\< /dict\>

<a name="2"></a>

## 三.常见问题
项目所需要的公钥,私钥请和客户经理取得联系
 www.ucloud.cn

<a name="3"></a>

## 四.反馈和建议

 - 主 页：<https://www.ucloud.cn/>
 - issue：[查看已有的 issues 和提交 Bug[推荐]]

<a name="8.1"></a>
### 问题反馈参考模板  

| 名称    | 描述                                   |
| ----- | ------------------------------------ |
| 设备型号  | iphone7                              |
| 系统版本  | iOS 10                               |
| SDK版本 | v1.5.0                               |
| 问题描述  | 描述问题现象                               |
| 操作路径  | 经过了什么样的操作出现所述的问题                     |
| 附 件   | 文本形式控制台log、crash报告、其他辅助信息 |




