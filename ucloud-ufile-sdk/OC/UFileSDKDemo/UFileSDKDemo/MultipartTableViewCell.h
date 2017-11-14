//
//  MultipartTableViewCell.h
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/8.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipartSession.h"
@interface MultipartTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger           partNumber;
@property (nonatomic, strong) MultipartSession* session;

-(void) setSession:(MultipartSession *)session PartNumber:(NSInteger)partnumber;

@end
