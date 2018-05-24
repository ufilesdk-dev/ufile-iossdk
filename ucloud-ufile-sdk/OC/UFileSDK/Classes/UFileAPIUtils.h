//
//  UFileAPIUtils.h
//  ufilesdk
//
//  Created by wu shauk on 4/21/16.
//  Copyright © 2016 ucloud. All rights reserved.
//

#ifndef UFileAPIUtils_h
#define UFileAPIUtils_h

#import <Foundation/Foundation.h>

@interface UFileAPIUtils : NSObject

+ (nonnull NSString*) calcMD5ForData:(nonnull NSData* )data;

+ (nullable NSString*) calcMD5ForPath:(nonnull NSString* )path;

+ (nonnull NSString*) HmacSha1:(nonnull NSString* )key data:(nonnull NSString *)data;

@end

#endif /* UFileAPIUtils_h */
