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
@property(nonatomic,strong) NSString*      bucket;
@property(nonatomic,strong) NSString*      publicKey;
@property(nonatomic,strong) NSString*      privateKey;

-(instancetype)initWith:(NSString*)publickey PrivateKey:(NSString*)privatekey Bucket:(NSString*)bucket;

-(NSString*)calcKey:(NSString*)httpMethod  Key:(NSString*)key  MD5:(NSString*)contentMd5 ContentType:(NSString*)contentType;
-(NSString*)_sha1Sum:(NSString*)key withString:(NSString*)str;

@end

