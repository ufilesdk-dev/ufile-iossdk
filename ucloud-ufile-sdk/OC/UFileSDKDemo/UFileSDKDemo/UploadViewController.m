//
//  UploadViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/10/30.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "UploadViewController.h"
#import "UFileAPIUtils.h"
@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadFile:(id)sender {
    
    __weak typeof(self) weakself = self;
    NSString*  strkey = @"initscreen.jpg";
    NSDictionary* policyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"http://test.ucloud.cn",@"callbackUrl",
                               @"url=http://demo.ufile.ucloud.cn/test.mp4&patten_name=mypolicy",
                               @"callbackBody",nil];
    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"initscreen" ofType:@"jpg"];
    NSData*  contentData = [[NSData alloc] initWithContentsOfFile:strPath];
    NSString* strAuth = [self.ufilesdk calcKey:@"PUT" Key:strkey MD5:nil ContentType:nil CallBackPolicy:policyDic];

    [self.ufilesdk.ufileApi putFile:strkey authorization:strAuth option:nil data:contentData progress:^(NSProgress* progress){
        
    }
    success:^(NSDictionary* response){
        
        if(response)
        {
            NSString* msg = [NSString stringWithFormat:@"%@ File UpLoad etag: %@",strkey, response[kUFileRespETag]];
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File upload  Fininshed!" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alterView addAction:okAction];
            [weakself presentViewController:alterView animated:YES completion:nil];
        }
   }
   failure:^(NSError* error){
       
       NSString*erMsg = @"";
       if (error && error.domain == kUFileSDKAPIErrorDomain) {
           erMsg = error.userInfo[@"ErrMsg"];
       }
       else
       {
           erMsg = error.description;
       }
       UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Upload Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
       [alterView addAction:okAction];
       [weakself presentViewController:alterView animated:YES completion:nil];
                           
   }];
    
}

- (IBAction)uploadHit:(id)sender {
     __weak typeof(self) weakself = self;
    NSString*  strkey = @"initscreen.jpg";
    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"initscreen" ofType:@"jpg"];
    NSData*  contentData = [[NSData alloc] initWithContentsOfFile:strPath];
    NSString* strAuth = [weakself.ufilesdk calcKey:@"POST" Key:strkey MD5:nil ContentType:nil CallBackPolicy:nil];
    [self.ufilesdk.ufileApi uploadHit:strkey authorization:strAuth fileSize:contentData.length fileHash:@"AQAAAJQnkf8WXMgGCb2-WYPgLZGI7yz1"
    success:^(NSDictionary* response){
        
        if(response)
        {
            NSString* msg = [NSString stringWithFormat:@"%@ File UpLoadHit Finished", strkey];
            UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File upload Hit Fininshed!" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alterView addAction:okAction];
            [weakself presentViewController:alterView animated:YES completion:nil];
        }
    
    }
    failure:^(NSError* error){
        
        NSString*erMsg = @"";
        if (error && error.domain == kUFileSDKAPIErrorDomain) {
            erMsg = error.userInfo[@"ErrMsg"];
        }
        else
        {
            erMsg = error.description;
        }
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Upload Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alterView addAction:okAction];
        [weakself presentViewController:alterView animated:YES completion:nil];
        
    }];
    
}

- (IBAction)putFileFromFile:(id)sender {
    
    __weak typeof(self) weakself = self;
    NSString*  strkey = @"123.jpg";
    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"initscreen" ofType:@"jpg"];
    NSString* strAuth = [self.ufilesdk calcKey:@"PUT" Key:strkey MD5:nil ContentType:@"text/plain" CallBackPolicy:nil];
    NSDictionary* option = @{kUFileSDKOptionFileType:@"text/plain"};
    
   [self.ufilesdk.ufileApi putFile:strkey
                           fromFile:strPath
                           authorization:strAuth
                           option:option
                           progress:^(NSProgress* progress){
                               
                           }
                           success:^(NSDictionary* reponse){
                               
                               if(reponse)
                               {
                                   NSString* msg = [NSString stringWithFormat:@"%@ File UpLoaded etag: %@",strkey, reponse[kUFileRespETag]];
                                   UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File upload Fininshed!" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
                                   UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                   [alterView addAction:okAction];
                                   [weakself presentViewController:alterView animated:YES completion:nil];
                               }
                           }
                           failure:^(NSError* error){
                               
                               NSString*erMsg = @"";
                               if (error && error.domain == kUFileSDKAPIErrorDomain) {
                                   erMsg = error.userInfo[@"ErrMsg"];
                               }
                               else
                               {
                                   erMsg = error.description;
                               }
                               UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File Upload Failed!" message:erMsg preferredStyle:(UIAlertControllerStyleAlert)];
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
