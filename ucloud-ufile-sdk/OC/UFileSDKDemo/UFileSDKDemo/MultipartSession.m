//
//  MultipartSession.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/8.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "MultipartSession.h"
@interface MultipartSession()


@end


@implementation MultipartSession

-(instancetype) init:(UFileSDK*) ufileSDK UPLoadID:(NSString*)uploadID  BlockSize:(NSInteger) blocksize  FileURL:(NSString*) fileurl KEY:(NSString*)key
{
    if (self = [super init]) {
        
        self.key = key;
        self.uploadID = uploadID;
        self.blockSize = blocksize;
        self.ufileSDK  = ufileSDK;
        self.fileData  = [NSData dataWithContentsOfFile:fileurl];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileurl error:nil];
        self.fileSize = (NSInteger)[fileAttributes fileSize];
        self.allParts = (self.fileSize + blocksize -1)/blocksize;
        self.etags  = [[NSMutableArray alloc] initWithCapacity:self.allParts];
    }
    return self;
}
-(NSData*)getDataForPart:(NSInteger)partNumber
{
    if (partNumber >= self.allParts) {
        return nil;
    }
    NSInteger loc = partNumber*self.blockSize;
    NSInteger  length = self.blockSize;
    NSInteger totalen = loc + length;
    if (totalen > self.fileSize) {
        length = self.fileSize - loc;
    }
    return [self.fileData subdataWithRange:NSMakeRange(loc, length)];
}
-(void) addEtag:(NSInteger) partNumber ETag:(NSString*)etag
{
    self.etags[partNumber] = etag;
}

-(NSString*) outputETags
{
    return [self.etags componentsJoinedByString:@","];
}

@end
