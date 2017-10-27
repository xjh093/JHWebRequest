//
//  JHWebRequest.h
//  JHKit
//
//  Created by HaoCold on 2017/10/23.
//  Copyright © 2017年 HaoCold. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHWebRequestSuccess)(NSDictionary *dic);
typedef void(^JHWebRequestFailure)(NSError *error);

@interface JHWebRequest : NSObject

// request url.
@property (copy,    nonatomic) NSString *url;

// request parameter.
@property (strong,  nonatomic) NSDictionary *parameter;

// success callback.
@property (copy,    nonatomic) JHWebRequestSuccess success;

// failure callback.
@property (copy,    nonatomic) JHWebRequestFailure failure;

// time out.
@property (assign,  nonatomic) NSTimeInterval  timeoutInterval;

// start a get request.
- (void)jh_start_get_request;

// start a post request.
- (void)jh_start_post_request;

// GET request
- (void)jh_get:(NSString *)url
     parameter:(NSDictionary *)dic
       success:(JHWebRequestSuccess)success
       failure:(JHWebRequestFailure)failure;

//POST request
- (void)jh_post:(NSString *)url
      parameter:(NSDictionary *)dic
        success:(JHWebRequestSuccess)success
        failure:(JHWebRequestFailure)failure;

//image upload request
- (void)jh_uploadImage:(NSString *)url
             parameter:(UIImage *)image
            uploadName:(NSString *)uploadName
       serverSavedName:(NSString *)savedName
               success:(JHWebRequestSuccess)success
               failure:(JHWebRequestFailure)failure;

@end
