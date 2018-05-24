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
@property(nonatomic,strong) NSString*     encryptServer;
@property(nonatomic,strong) NSString*     bucket;
@property(nonatomic,strong) NSString*     publicToken;
@property(nonatomic,strong) NSString*     privateToken;

/**
 UFileSDK 初始化
 
 @param encryptServer 签名服务器地址 （必须）
 @param bucket 配置的bucket （必须）
 @return 返回UFileSDK实例
 */
-(instancetype)initWith:(NSString *)bucket EncryptServer:(NSString *)encryptServer;

/**
 UFileSDK 初始化
 
 @param publicKey 公钥（必须）
 @param privateKey 私钥（必须）
 @param bucket 配置的bucket （必须）
 @return 返回UFileSDK实例
 */
-(instancetype)initWith:(NSString *)bucket PublicKey:(NSString *)publicKey PrivateKey:(NSString *)privateKey;


/**
 计算签名
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
 */
-(NSString*)calcKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType CallBackPolicy:(NSDictionary*)policy;

/**
 签名服务器计算签名
 */
-(NSString*)calcAuthServerKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType CallBackPolicy:(NSDictionary*)policy;

/**
 内置签名算法计算签名
 */
-(NSString*)calcTokenKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType CallBackPolicy:(NSDictionary*)policy;


@end

