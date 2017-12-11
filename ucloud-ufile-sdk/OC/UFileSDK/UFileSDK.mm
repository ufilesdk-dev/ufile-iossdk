//
//  UFileSDK.m
//  UFileSDK
//
//  Created by 涂雄 on 2017/10/30.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "UFileSDK.h"
#import <CommonCrypto/CommonCrypto.h>
@interface UFileSDK ()
@property (nonatomic, copy) NSString* callBackPolicy;

@end

@implementation UFileSDK

-(instancetype)initWith:(NSString *)publickey PrivateKey:(NSString *)privatekey Bucket:(NSString *)bucket
{
    if (self = [super init]) {
        self.ufileApi = [[UFileAPI alloc] initWithBucket:bucket url:@"http://ufile.ucloud.cn"];
        self.bucket = bucket;
        self.publicKey = publickey;
        self.privateKey = privatekey;
        self.callBackPolicy = nil;
    }
    return self;
}

-(NSString*)calcKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType  CallBackPolicy:(NSDictionary*)policy
{
    NSMutableString* strBody = [NSMutableString  stringWithFormat:@"%@\n",httpMethod];
    if (contentMd5) {
        [strBody appendString:(contentMd5)];
    }
    [strBody appendString:@"\n"];
    
    if (contentType) {
        [strBody appendString:contentType];
    }
    [strBody appendString:@"\n"];
    [strBody appendString:@"\n"];
    [strBody appendString:@""];
    [strBody appendString:@"/"];
    [strBody appendString:self.bucket];
    [strBody appendString:@"/"];
    [strBody appendString:key];
    if (policy) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:policy options:NSJSONWritingPrettyPrinted error:&error];
        NSString* policy = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonData) {
            self.callBackPolicy = [self stringFromResult: (void*)policy.UTF8String Len:policy.length];
        }
        strBody  =  [NSString stringWithFormat:@"%@%@",strBody,self.callBackPolicy];
    }
    return [self _sha1Sum: self.privateKey withString:strBody];
    
}

-(NSString*)_sha1Sum:(NSString*)key withString:(NSString*)str
{
    void* result = malloc(CC_SHA1_DIGEST_LENGTH);
    memset(result,0, CC_SHA1_DIGEST_LENGTH);
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),key.UTF8String , key.length, str.UTF8String, str.length, result);
    NSString* strDes = [self stringFromResult:result Len:CC_SHA1_DIGEST_LENGTH];
    free(result);
    if (self.callBackPolicy) {
        
        return [NSString stringWithFormat:@"UCloud %@:%@:%@",self.publicKey,strDes,self.callBackPolicy];
    }
    else
    {
        return [NSString stringWithFormat:@"UCloud %@:%@",self.publicKey,strDes];
    }
    
}

-(NSString*)stringFromResult:(void*)result Len:(NSInteger)length
{
    NSData* data = [[NSData alloc] initWithBytes:result length:length];
    return [data base64EncodedStringWithOptions:0];
}


@end
