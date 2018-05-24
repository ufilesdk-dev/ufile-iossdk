//
//  DeleteViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/1.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "DeleteViewController.h"
@interface DeleteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fileNameText;

@end

@implementation DeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _fileNameText.text = @"initscreen.jpg";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deleteFile:(id)sender {
    
     __weak typeof(self) weakself = self;
    [_fileNameText  resignFirstResponder];
    NSString* strFileName = _fileNameText.text;
    //ContentType和ContentMD5要传空字符串不能传nil
    NSString* strAuth = [self.ufileSDK calcKey:@"DELETE" Key:strFileName MD5:@"" ContentType:@"" CallBackPolicy:nil];
    [self.ufileSDK.ufileApi deleteFile:strFileName authorization:strAuth success:^(NSDictionary * _Nonnull response) {
        if(response)
        {
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Delete Done!" message:strFileName preferredStyle:(UIAlertControllerStyleAlert)];
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
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Delete Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
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
