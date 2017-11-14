//
//  QueryViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/1.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "QueryViewController.h"
#import "UFileSDK.h"

@interface QueryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ufileNameText;


@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ufileNameText.text = @"initscreen.jpg";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queryFile:(id)sender {
    
    __weak typeof(self) weakself = self;
    [_ufileNameText resignFirstResponder];
    NSString* strFileName = _ufileNameText.text;
    NSString* strAuth = [self.ufileSDK calcKey:@"HEAD" Key:strFileName MD5:nil ContentType:nil];
    [self.ufileSDK.ufileApi headFile:strFileName authorization:strAuth
       success:^(NSDictionary *  response) {
        if(response)
        {
            NSString* etag = response[kUFileRespETag];
            NSString* filetype = response[kUFileRespFileType];
            NSInteger length   = [response[kUFileRespLength] integerValue];
            NSString* msg = [NSString stringWithFormat:@"etag: %@ \n filetype: %@\n length:%@",etag,filetype,@(length)];
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File info" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alterView addAction:okAction];
            [weakself presentViewController:alterView animated:YES completion:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSString*erMsg = @"";
        if (error && error.domain == kUFileSDKAPIErrorDomain) {
            erMsg = error.userInfo[@"ErrMsg"];
        }
        else
        {
            erMsg = error.description;
        }
        
        if (404 == [error.userInfo[@"StatusCode"] longValue]) {
            erMsg = @"服务器上该资源文件不存在...";
        }
        
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Head Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alterView addAction:okAction];
        [weakself presentViewController:alterView animated:YES completion:nil];
        
    }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
