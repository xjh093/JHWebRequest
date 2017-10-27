//
//  JHWebRequestManager.m
//  JHKit
//
//  Created by HaoCold on 2017/10/23.
//  Copyright © 2017年 HaoCold. All rights reserved.
//

#import "JHWebRequestManager.h"


@implementation JHWebRequestManager
//
+ (instancetype)manager{
    static JHWebRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JHWebRequestManager alloc] init];
    });
    return manager;
}

// GET request
- (void)jh_get:(NSString *)url
     parameter:(NSDictionary *)dic
       success:(JHWebRequestSuccess)success
       failure:(JHWebRequestFailure)failure{
    JHWebRequest *webRequest = [[JHWebRequest alloc] init];
    [webRequest jh_get:url parameter:dic success:success failure:failure];
}

//POST request
- (void)jh_post:(NSString *)url
      parameter:(NSDictionary *)dic
        success:(JHWebRequestSuccess)success
        failure:(JHWebRequestFailure)failure{
    JHWebRequest *webRequest = [[JHWebRequest alloc] init];
    [webRequest jh_post:url parameter:dic success:success failure:failure];
}

//image upload request
- (void)jh_uploadImage:(NSString *)url
             parameter:(UIImage *)image
            uploadName:(NSString *)uploadName
       serverSavedName:(NSString *)savedName
               success:(JHWebRequestSuccess)success
               failure:(JHWebRequestFailure)failure{
    JHWebRequest *webRequest = [[JHWebRequest alloc] init];
    [webRequest jh_uploadImage:url parameter:image uploadName:uploadName serverSavedName:savedName success:success failure:failure];
}

@end
