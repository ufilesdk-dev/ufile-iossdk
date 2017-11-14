//
//  MultipartSession.h
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/8.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultipartSession : NSObject
@property (nonatomic, strong) UFileSDK*   ufileSDK;
@property (nonatomic, assign) NSInteger    allParts;
@property (nonatomic, strong) NSString*    key;
@property (nonatomic, strong) NSString*    uploadID;
@property (nonatomic, assign) NSInteger    fileSize;
@property (nonatomic, assign) NSInteger    blockSize;
@property (nonatomic, strong) NSData*      fileData;
@property (nonatomic, strong) NSMutableArray* etags;

-(instancetype) init:(UFileSDK*) ufileSDK UPLoadID:(NSString*)uploadID  BlockSize:(NSInteger) blocksize  FileURL:(NSString*) fileurl KEY:(NSString*)key;

-(NSData*)getDataForPart:(NSInteger)partNumber;

-(void) addEtag:(NSInteger) partNumber ETag:(NSString*)etag;

-(NSString*) outputETags;

@end
