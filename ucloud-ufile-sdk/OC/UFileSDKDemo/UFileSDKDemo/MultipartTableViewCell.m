//
//  MultipartTableViewCell.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/8.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "MultipartTableViewCell.h"
@interface MultipartTableViewCell ()
@property (assign, nonatomic) BOOL   bUploaded;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;


@end

@implementation MultipartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progress.progress = .0;
    self.progress.progressTintColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setSession:(MultipartSession *)session PartNumber:(NSInteger)partnumber
{
    self.session = session;
    self.partNumber = partnumber;
    if (!self.bUploaded) {
        self.progress.progress = .0;
        self.btnUpload.enabled = YES;
    }
    
    
}
- (IBAction)startUpload:(id)sender {
    
     __weak typeof(self) weakself = self;
    NSString* contentType = @"Video/mp4";
    NSDictionary* option =  @{kUFileSDKOptionTimeoutInterval:[NSNumber numberWithFloat:5.0]};
    NSString* strAuth = [self.session.ufileSDK calcKey:@"PUT" Key:self.session.key MD5:nil ContentType:contentType CallBackPolicy:nil];
    [self.session.ufileSDK.ufileApi multipartUploadPart:self.session.key uploadId:self.session.uploadID partNumber:self.partNumber contentType:contentType data:[self.session getDataForPart:self.self.partNumber] option:option authorization:strAuth
 
    progress:^(NSProgress * progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.progress setProgress:progress.fractionCompleted animated:YES];
            
        });
    }
    success:^(NSDictionary* reponse)
    {
        [weakself.session addEtag:weakself.partNumber ETag:reponse[kUFileRespETag]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.bUploaded = YES;
            weakself.btnUpload.enabled = NO;
        });
        
    }
    failure:^(NSError* error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.progress.progressTintColor = [UIColor redColor];
        });
        
    }];
}



@end
