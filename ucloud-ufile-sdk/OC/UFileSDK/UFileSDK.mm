//
//  UFileSDK.m
//  UFileSDK
//
//  Created by 涂雄 on 2017/10/30.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "UFileSDK.h"
#import "UFileAPIUtils.h"

@interface UFileSDK ()
@property (nonatomic, copy) NSString* callBackPolicy;


@end

@implementation UFileSDK

-(instancetype)initWith:(NSString *)bucket ProxySuffix:(NSString *)proxySuffix EncryptServer:(NSString *)encryptServer
{
    if (self = [super init]) {
        self.ufileApi = [[UFileAPI alloc] initWithBucket:bucket url:@"http://ufile.ucloud.cn"];
        self.bucket = bucket;
        self.callBackPolicy = nil;
        self.encryptServer = encryptServer;
    }
    return self;
}

-(instancetype)initWith:(NSString *)bucket ProxySuffix:(NSString *)proxySuffix PublicKey:(NSString *)publicKey PrivateKey:(NSString *)privateKey
{
    if (self = [super init]) {
//        self.ufileApi = [[UFileAPI alloc] initWithBucket:bucket url:@"http://ufile.ucloud.cn"];
        self.ufileApi = [[UFileAPI alloc] initWithBucket:bucket url:[NSString stringWithFormat:@"http://%@", proxySuffix]];
        self.publicToken = publicKey;
        self.privateToken = privateKey;
        self.bucket = bucket;
        self.callBackPolicy = nil;
    }
    return self;
}

-(NSString*)calcKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType  CallBackPolicy:(NSDictionary*)policy
{
    if (self.encryptServer) {
        return [self calcAuthServerKey:httpMethod Key:key MD5:contentMd5 ContentType:contentType CallBackPolicy:policy];
    } else {
        return [self calcTokenKey:httpMethod Key:key MD5:contentMd5 ContentType:contentType CallBackPolicy:policy];
    }
}


-(NSString*)calcAuthServerKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType  CallBackPolicy:(NSDictionary*)policy
{
    NSMutableString* strHttpReq = [NSMutableString  stringWithFormat:@"%@?method=%@",self.encryptServer,httpMethod];
    [strHttpReq appendFormat:@"&bucket=%@", self.bucket];
    
    if (key) {
        [strHttpReq appendFormat:@"&key=%@", key];
    }
    
    if (contentMd5) {
        [strHttpReq appendFormat:@"&content_md5=%@", contentMd5];
    }
    
    if (contentType) {
        [strHttpReq appendFormat:@"&content_type=%@", contentType];
    }
    
    
    if (policy) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:policy options:NSJSONWritingPrettyPrinted error:&error];
        NSString* policy = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonData) {
            self.callBackPolicy = [self stringFromResult: (void*)policy.UTF8String Len:policy.length];
        }
        if (self.callBackPolicy) {
            [strHttpReq appendFormat:@"&put_policy=%@", self.callBackPolicy];
        }
    }
    NSURL *url = [NSURL URLWithString:strHttpReq];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    __block NSString* strRes = nil;
    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse =  (NSHTTPURLResponse*)response;
        if (httpResponse && httpResponse.statusCode == 200 && data) {
            strRes = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            strRes = [strRes stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    if (strRes) {
        
        if (self.callBackPolicy) {
            
            return [NSString stringWithFormat:@"%@:%@",strRes,self.callBackPolicy];
        }
        else
        {
            return strRes;
        }
    }
    return nil;
}


-(NSString*)calcTokenKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType  CallBackPolicy:(NSDictionary*)policy
{
    NSString* decodeKey = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableString* signString = [NSMutableString stringWithFormat:@"%@\n", httpMethod];
    [signString appendFormat:@"%@\n", contentMd5];
    [signString appendFormat:@"%@\n", contentType];
    [signString appendFormat:@"%@\n", @""];
    [signString appendFormat:@"/%@/%@", self.bucket, decodeKey];
    
    NSString* HmacSHA1str = [UFileAPIUtils HmacSha1:self.privateToken data:signString];
    
    NSMutableString* signedStr = [NSMutableString stringWithFormat:@"UCloud %@:%@", self.publicToken, HmacSHA1str];
    
    return signedStr;
}

-(NSString*)stringFromResult:(void*)result Len:(NSInteger)length
{
    NSData* data = [[NSData alloc] initWithBytes:result length:length];
    return [data base64EncodedStringWithOptions:0];
}


@end
