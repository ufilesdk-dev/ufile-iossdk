//
//  DownloadViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/1.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "DownloadViewController.h"
#import "UFileSDK.h"
@interface DownloadViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fileNameText;
@property (weak, nonatomic) IBOutlet UITextField *rangeText;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileNameText.text = @"initscreen.jpg";
    self.progress.progress = .0;
    self.progress.progressTintColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downloadFile:(id)sender {
    [_fileNameText resignFirstResponder];
    [_rangeText resignFirstResponder];
    if (_fileNameText.text.length <= 0) {
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"Warning!" message:[NSString stringWithFormat:@"请输入需要下载的文件名"] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alterView addAction:okAction];
        [self presentViewController:alterView animated:YES completion:nil];
        return;
    }
    
    _progress.progress =.0;
    _progress.progressTintColor = [UIColor blueColor];
    NSString* strFileName =  _fileNameText.text;
    NSString* range = _rangeText.text;
    NSDictionary* option = nil;
    if (range && [range length] > 0) {
       option  = @{kUFileSDKOptionRange:range};
    }
    __weak typeof(self) weakself = self;
    NSString* strAuth = [self.ufileSDK calcKey:@"GET" Key:strFileName MD5:nil ContentType:nil CallBackPolicy:nil];
    [self.ufileSDK.ufileApi getFile:strFileName authorization:strAuth option:option
    progress:^(NSProgress * progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progress setProgress:progress.fractionCompleted  animated:YES];
        });
    } success:^(NSDictionary *  response, id  responseObject) {
        if(response && [responseObject isKindOfClass: [NSData class]])
        {
            NSData* data =(NSData*)responseObject;
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Download Fininshed!" message:[NSString stringWithFormat:@"%@ File Downloaded,File size:%@",strFileName,@(data.length)] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alterView addAction:okAction];
            [weakself presentViewController:alterView animated:YES completion:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSString*erMsg = @"";
        _progress.progressTintColor = [UIColor redColor];
        if (error && error.domain == kUFileSDKAPIErrorDomain) {
            erMsg = error.userInfo[@"ErrMsg"];
        }
        else
        {
            erMsg = error.description;
        }
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Download Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alterView addAction:okAction];
        [weakself presentViewController:alterView animated:YES completion:nil];
        
    }];
    
}

- (IBAction)downloadToFile:(id)sender {
    
    __weak typeof(self) weakself = self;
    [_fileNameText resignFirstResponder];
    [_rangeText resignFirstResponder];
    _progress.progress = .0;
    _progress.progressTintColor = [UIColor blueColor];
    NSString* strFileName =  _fileNameText.text;
    NSString* range = _rangeText.text;
    NSDictionary* option = nil;
    if (range && range.length > 0) {
        option = @{kUFileSDKOptionRange:range,kUFileSDKOptionTimeoutInterval:[NSNumber numberWithFloat:5.0]};
    }
    else
    {
         option = @{kUFileSDKOptionTimeoutInterval:[NSNumber numberWithFloat:5.0]};
    }
    NSString* strAuth = [self.ufileSDK calcKey:@"GET" Key:strFileName MD5:nil ContentType:nil CallBackPolicy:nil];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* strDownloadPath = [NSString stringWithFormat:@"%@/%@",path.firstObject,strFileName];
    [self.ufileSDK.ufileApi getFile:strFileName toFile:strDownloadPath authorization:strAuth option:option progress:^(NSProgress * progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progress setProgress:progress.fractionCompleted  animated:YES];
        });
    } success:^(NSDictionary *  response, id  responseObject) {
        if(response && [responseObject isKindOfClass: [NSURL class]])
        {
            NSURL* url= (NSURL*)responseObject;
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Download Fininshed!" message:[NSString stringWithFormat:@"%@ File Downloaded to :%@",strFileName,url.absoluteString] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alterView addAction:okAction];
            [weakself presentViewController:alterView animated:YES completion:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSString*erMsg = @"";
         _progress.progressTintColor = [UIColor redColor];
        if (error && error.domain == kUFileSDKAPIErrorDomain) {
            erMsg = error.userInfo[@"ErrMsg"];
        }
        else
        {
            erMsg = error.description;
        }
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Download Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
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
