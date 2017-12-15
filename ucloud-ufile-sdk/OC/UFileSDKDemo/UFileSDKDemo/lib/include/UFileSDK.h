//
//  UFileSDK.h
//  UFileSDK
//
//  Created by 涂雄 on 2017/10/30.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFileAPI.h"
@interface UFileSDK : NSObject

@property(nonatomic,strong) UFileAPI*     ufileApi;
@property(nonatomic,strong) NSString*     bucket;

/**
 UFileSDK 初始化
 
 @param strSignServerUrl 签名服务器地址
 @param bucket 配置的bucket
 @return 返回UFileSDK实例
 */
-(instancetype)initWith:(NSString *)strSignServerUrl Bucket:(NSString *)bucket;



/**
 计算签名
 @param httpMethod  http请求方法
 @param key 文件名（包含后缀）
 @param contentMd5 MD5内容可以为nil
 @param contentType 内容类型
 @param policy 回掉策略 参数类型是 NSDictionary,例如
 {
 "callbackUrl" : "http://test.ucloud.cn",   //指定回调服务的地址
 "callbackBody" : "key1=value1&key2=value2" //传递给回调服务的参数
 }
 注意的是需要回掉策略的有putFile和multipartUploadFinish两个API,其他API,这个参数可以设置nil
 @return 返回签名字符串
 */
-(NSString*)calcKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType CallBackPolicy:(NSDictionary*)policy;


@end

