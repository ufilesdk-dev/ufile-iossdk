# 目录说明 

* SDK/ufilesdk
  
  ufilesdk.xcodeproj  library的工程文件
  ufilesdk            源码位置
  
* demo

  demo工程
  
  
# 使用说明

将SDK/ufilesdk/ufilesdk.xcodeproj引入您的工程

然后引入头文件即可

```#import "ufilesdk/UFileAPI.h"```

## 如何生成签名？
我们使用基于 HTTP 协议的接口传输数据。为了保证网络传输是数据的安全性，我们会对每个 HTTP 请求做特定的签名计算，最后再把生成好的签名字段加入到 HTTP 的 Authorization Header 里面。  

以下是一个一个典型的签名字字符串。  
```
UCloud TOKEN_Your_Public_Key:someSecretsIDontWantShow
```
其中 `UCloud `（带空格） 是固定的，`:` 前面的一段是您的公钥，`:` 后面的是经过算法生成好的签名字符串。  

**使用 SDK 您不必关心签名是如何生成的，只需要关心哪些字段会参与签名计算即可。**
在本 SDK 中，[UFileSDK](https://github.com/ufilesdk-dev/ufile-iossdk/blob/master/ucloud-ufile-sdk/OC/UFileSDK/UFileSDK.h) 里面有三个函数用来计算签名的，分别是 calcKey, calcAuthServerKey。以下我们分别对这两个签名函数入参数做详细的说明。

### calcKey
这是一个直接生成签名的函数，他需要传入的参数和说明如下：
```
 @param httpMethod  http请求方法（必须）
 @param key 文件名（包含后缀 必须）
 @param contentMd5 MD5内容可以为nil（可选）
 @param contentType 内容类型 （可选）
 @param policy 回掉策略 （可选）
       设置参数类型是 NSDictionary,例如
       {
         "callbackUrl" : "http://test.ucloud.cn",   //指定回调服务的地址 （必须）
         "callbackBody" : "key1=value1&key2=value2" //传递给回调服务的参数 （必须）
       }
       注意的是支持回掉策略的有putFile和multipartUploadFinish两个API,此参数必须,其他API,这个参数设置nil
 @return 返回签名字符串
```

### calcAuthServerKey
对于防止私钥存在客户端里面存在安全性的问题，您可以吧签名需要的参数传给一个存储私钥的后端服务器进行计算，并返回给前端。这个签名函数就是把签名所需要的参数传给后端服务器，并返回。具体后端服务器实现[请见](https://github.com/ufilesdk-dev/ufile-jssdk/blob/master/token_server.php)。本需要
函数需要的接口参数和上面的 calcKey 一样，只是会把签名计算过程发送到后端进行计算。

**注意：计算签名 key 这个字段必须和接口需要的 key 字段一致，否则会报 403 签名不正确的错误。**  
比如 putFile 需要传入 key，fileName, authorization 这三个字段。那么 key 必须和签名使用的 key 一致。

## BitCode 设置

我们需要把 Enable BitCode设置为 ‘NO’ 。 具体路径为：`project->targest->Build Setting->Enable Bitcode`. 

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fuqh7b5pjrj30v509mwgb.jpg)