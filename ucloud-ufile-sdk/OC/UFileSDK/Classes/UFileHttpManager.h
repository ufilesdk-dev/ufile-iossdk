//
//  UFileHttpManager.h
//  ufilesdk
//
//  Created by wu shauk on 12/11/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

#ifndef UFileHttpManager_h
#define UFileHttpManager_h


extern NSString* _Nullable UFilePercentEscapedStringFromString(NSString* _Nonnull);

@interface UFileHttpManager : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>



/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;
/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;

- (_Nonnull instancetype)init;


/**
 http的put方法

 @param URL 地址
 @param headerParams  头部参数
 @param timeoutInterval timeout时间参数设置
 @param body http的body部分
 @param uploadProgress 上传进度block
 @param success success的blcok
 @param failure failure的block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask * _Nullable )Put:(NSURL  * _Nonnull)URL
                            headerParams:(NSArray  * _Nonnull)headerParams
                         timeoutInterval:(NSNumber*)timeoutInterval
                                    body:(NSData * _Nonnull)body
                                progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                                 success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                 failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


/**
 http的get方法
 
 @param URL 地址
 @param headerParams 头部参数
 @param timeoutInterval  timeout时间参数设置
 @param queries 查询参数数组
 @param uploadProgress 上传进度block
 @param success success的block
 @param failure failure的block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask * _Nullable)Get:(NSURL * _Nonnull)URL
                           headerParams:(NSArray * _Nonnull)headerParams
                        timeoutInterval:(NSNumber*)timeoutInterval
                                queries:(NSArray* _Nullable)queries
                               progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


/**
 http的head方法

 @param URL  地址
 @param headerParams 头部参数
 @param timeoutInterval timeout时间参数设置
 @param success success的block
 @param failure failure的block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask* _Nullable)Head:(NSURL * _Nonnull)URL
                           headerParams:(NSArray * _Nonnull)headerParams
                        timeoutInterval:(NSNumber*)timeoutInterval
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

/**
 http的Delete方法

 @param URL 地址
 @param headerParams 头部参数
 @param timeoutInterval timeout时间参数设置
 @param success success的block
 @param failure failure的block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask* _Nullable)Delete:(NSURL * _Nonnull)URL
                           headerParams:(NSArray * _Nonnull)headerParams
                          timeoutInterval:(NSNumber*)timeoutInterval
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

/**
  http的Post方法

 @param URL  地址
 @param headerParams 头部参数
 @param timeoutInterval timeout时间参数设置
 @param body http的body部分
 @param uploadProgress 上传进度的block
 @param success success的block
 @param failure failure的block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask * _Nullable )Post:(NSURL  * _Nonnull)URL
                            headerParams:(NSArray  * _Nonnull)headerParams
                          timeoutInterval:(NSNumber*)timeoutInterval
                                    body:(NSData * _Nullable)body
                                progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                                 success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                 failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


/**
 上传文件

 @param request 上传请求
 @param fileURL 上传文件url
 @param uploadProgressBlock 上传进度block
 @param completionHandler 结果返回block
 @return NSURLSessionUploadTask对象实例
 */

- (NSURLSessionUploadTask* _Nullable)uploadTaskWithRequest:(nonnull NSURLRequest*)request
                                                  fromFile:(nonnull NSURL*)fileURL
                                                  progress:(void (^ _Nullable)(NSProgress* _Nonnull)) uploadProgressBlock
                                         completionHandler:(void (^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError  * _Nullable error))completionHandler;


/**
 下载文件

 @param request 下载请求
 @param downloadProgressBlock 下载进度
 @param destination 存储下载文件路径
 @param completionHandler 结果返回block
 @return NSURLSessionDownloadTask对象实例
 */
- (NSURLSessionDownloadTask* _Nullable)downloadTaskWithRequest:(NSURLRequest* _Nonnull)request
                                                      progress:(nullable void (^)(NSProgress* _Nonnull downloadProgress)) downloadProgressBlock
                                                   destination:(NSURL* _Nonnull (^ _Nonnull)(NSURL* _Nonnull targetPath, NSURLResponse* _Nonnull response))destination
                                             completionHandler:(nullable void (^)(NSURLResponse* _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 请求执行方法

 @param request request
 @param uploadProgressBlock 上传进度
 @param downloadProgressBlock 下载进度
 @param completionHandler 结果返回 block
 @return NSURLSessionDataTask对象实例
 */
- (NSURLSessionDataTask* _Nullable)dataTaskWithRequest:(NSURLRequest* _Nonnull)request
                               uploadProgress:(nullable void (^)(NSProgress* _Nonnull uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress* _Nonnull downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse* _Nonnull response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;



/**
 任务完成调用
 */
- (void) finishTasksAndInvalidate;

@end



#endif /* UFileHttpManager_h */
