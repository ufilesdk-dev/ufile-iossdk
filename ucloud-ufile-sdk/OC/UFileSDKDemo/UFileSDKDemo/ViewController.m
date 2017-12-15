//
//  ViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/10/30.
//  Copyright © 2017年 涂雄. All rights reserved.
//
#import "ViewController.h"
#import "QueryViewController.h"
#import "UploadViewController.h"
#import "DeleteViewController.h"
#import "DownloadViewController.h"
#import "MultipartUploadViewController.h"
static NSString* encryptServer = @"http://192.168.1.113//web/token_server.php";

@interface ViewController ()

@property (nonatomic, strong) UFileSDK*   ufilesdk;
@property (weak, nonatomic) IBOutlet UITextField *publicKey;
@property (weak, nonatomic) IBOutlet UITextField *privateKey;
@property (weak, nonatomic) IBOutlet UITextField *bucketKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bucketKey.text = bucket;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (_ufilesdk == nil) {
         self.ufilesdk = [[UFileSDK alloc] initWith:encryptServer Bucket:bucket];
    }
   
    if ([segue.destinationViewController isKindOfClass:[QueryViewController class]]) {
        QueryViewController* queryVC = segue.destinationViewController;
        queryVC.ufileSDK = self.ufilesdk;
    }
    else if ( [segue.destinationViewController isKindOfClass:[UploadViewController class]])
    {
        UploadViewController* uploadVC = segue.destinationViewController;
        uploadVC.ufilesdk = self.ufilesdk;
        
    }
    else if ( [segue.destinationViewController isKindOfClass:[DeleteViewController class]])
    {
        DeleteViewController* deleteVC = segue.destinationViewController;
        deleteVC.ufileSDK = self.ufilesdk;
    }
    else if ( [segue.destinationViewController isKindOfClass:[DownloadViewController class]])
    {
        DownloadViewController* downloadVC = segue.destinationViewController;
        downloadVC.ufileSDK = self.ufilesdk;
    }
    else if ([segue.destinationViewController isKindOfClass:[MultipartUploadViewController class]])
    {
        MultipartUploadViewController* multiUpload =  segue.destinationViewController;
        multiUpload.ufileSDK = self.ufilesdk;
    }
}


@end
