//
//  JHWebRequestManager.m
//  JHKit
//
//  Created by HaoCold on 2017/10/23.
//  Copyright © 2017年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
