//
//  MultipartUploadViewController.m
//  UFileSDKDemo
//
//  Created by 涂雄 on 2017/11/7.
//  Copyright © 2017年 涂雄. All rights reserved.
//

#import "MultipartUploadViewController.h"
#import "MultipartTableViewController.h"
@interface MultipartUploadViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSartUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnFinishUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnCancleUpload;
@property (nonatomic, strong) MultipartTableViewController* tableController;

@property (nonatomic, strong) MultipartSession* session;
@end

@implementation MultipartUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableController = [[MultipartTableViewController alloc] init];
    self.tableView.delegate = self.tableController;
    self.tableView.dataSource = self.tableController;
    [self.tableView reloadData];
    self.btnSartUpload.enabled = YES;
    self.btnFinishUpload.enabled = NO;
    self.btnCancleUpload.enabled = NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startToPart:(id)sender {
    
    __weak typeof(self) weakself = self;
    self.btnSartUpload.enabled = NO;
    self.btnFinishUpload.enabled = YES;
    self.btnCancleUpload.enabled = YES;
//    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"initscreen" ofType:@"jpg"];
    if (nil == strPath) {
        UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"Warning!" message:@"路径不存在" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alterView addAction:okAction];
        [self presentViewController:alterView animated:YES completion:nil];
    }
   
//    NSString* strPath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"test.mp4"];
    NSString* strkey = @"initscreen.jpg";
    NSString* contentType = @"image/jpeg";
    NSString* strAuth = [self.ufileSDK calcKey:@"POST" Key:strkey MD5:@"" ContentType:contentType CallBackPolicy:nil];
    [self.ufileSDK.ufileApi multipartUploadStart:strkey authorization:strAuth fileType:contentType
                                         success:^(NSDictionary * _Nonnull response) {
                                             if (response) {
                                                 NSString* msg = [NSString stringWithFormat:@"Multipart start:\n uploadId=%@\n blocksize=%lu \n bucketName=%@ \n Key=%@\n",response[kUFileRespUploadId],[response[kUFileRespBlockSize] integerValue],response[kUFileRespBucketName],response[kUFileRespKeyName]];
                                                 
                                                 weakself.session = [[MultipartSession alloc] init:self.ufileSDK UPLoadID:response[kUFileRespUploadId] BlockSize:[response[kUFileRespBlockSize] integerValue] FileURL:strPath KEY:strkey];
                                                 weakself.session = [[MultipartSession alloc] init:self.ufileSDK UPLoadID:response[kUFileRespUploadId] BlockSize:[response[kUFileRespBlockSize] integerValue] FileURL:strPath KEY:strkey];
                                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PartSucess"];
                                                 [weakself.tableController setSession:self.session];
                                                 [weakself.tableView reloadData];
                                                 [weakself showMsg:msg];
                                             }
                                             
                                             
                                         } failure:^(NSError * _Nonnull error) {
                                             
                                             [self showError:error];
                                         }];
}

- (IBAction)finishUpload:(id)sender {
    
    __weak typeof(self) weakself = self;
    self.btnCancleUpload.enabled = NO;
    self.btnFinishUpload.enabled = NO;
    self.btnSartUpload.enabled = YES;
    NSDictionary* policyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"http://test.ucloud.cn",@"callbackUrl",
                               @"url=http://demo.ufile.ucloud.cn/test.mp4&patten_name=mypolicy",
                               @"callbackBody",nil];
    NSString* contentType = @"image/jpeg";
    NSString* strAuth = [self.ufileSDK calcKey:@"POST" Key:self.session.key MD5:@"" ContentType:contentType CallBackPolicy:policyDic];
    [self.ufileSDK.ufileApi multipartUploadFinish:self.session.key uploadId:self.session.uploadID newKey:[NSString stringWithFormat:@"%@%@",self.session.key,@""] etags:self.session.etags contentType:contentType authorization:strAuth
    success:^(NSDictionary * _Nonnull response) {
        
        NSString* msg = [NSString stringWithFormat:@"File Upload Finshed:\n  blocksize=%lu \n bucketName=%@ \n Key=%@\n",response[kUFileRespBlockSize],response[kUFileRespBucketName],response[kUFileRespKeyName]];
        [weakself showMsg: msg];
        
    } failure:^(NSError * _Nonnull error) {
        [weakself showError:error];
    }];
    
}
- (IBAction)cancelUpload:(id)sender {
    
    __weak typeof(self) weakself = self;
    self.btnCancleUpload.enabled = NO;
    self.btnFinishUpload.enabled = NO;
    self.btnSartUpload.enabled = YES;
    NSString* contentType = @"image/jpeg";
    NSString* strAuth = [self.ufileSDK calcKey:@"DELETE" Key:self.session.key MD5:@"" ContentType:contentType CallBackPolicy:nil];
    
    [self.ufileSDK.ufileApi multipartUploadAbort:self.session.key uploadId:self.session.uploadID  authorization:strAuth contentType:contentType success:^(NSDictionary * _Nonnull response) {
                                              
                                              NSString* msg = @"File Upload aborted!";
                                              [weakself showMsg: msg];
                                              
                                          } failure:^(NSError * _Nonnull error) {
                                              [weakself showError:error];
                                          }];
}

-(void)showMsg:(NSString*)msg
{
    UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File upload  Fininshed!" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alterView addAction:okAction];
    [self presentViewController:alterView animated:YES completion:nil];
}

-(void)showError:(NSError*)error
{
    NSString* errMsg = nil;
    if (error.domain == kUFileSDKAPIErrorDomain) {
        
        errMsg = error.userInfo[@"ErrMsg"];
    }
    else
    {
        errMsg = error.description;
    }
        
    UIAlertController* alterView =  [UIAlertController alertControllerWithTitle:@"File upload  Failed!" message:errMsg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alterView addAction:okAction];
    [self presentViewController:alterView animated:YES completion:nil];
    
}

@end
