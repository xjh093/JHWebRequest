//
//  JHWebRequest.m
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

#if 1
#define JHWRLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define JHWRLog(...)
#endif

#import "JHWebRequest.h"

@interface JHWebRequest()<UIWebViewDelegate>
@property (strong,  nonatomic) UIWebView *webView;
@property (strong,  nonatomic) NSMutableDictionary *requestDic;
@end

@implementation JHWebRequest

#pragma mark - public
// start a get request.
- (void)jh_start_get_request{
    [self jh_get:_url parameter:_parameter success:_success failure:_failure];
}

// start a post request.
- (void)jh_start_post_request{
    [self jh_post:_url parameter:_parameter success:_success failure:_failure];
}

// GET request
- (void)jh_get:(NSString *)url
     parameter:(NSDictionary *)dic
       success:(JHWebRequestSuccess)success
       failure:(JHWebRequestFailure)failure{
    [self jh_method:@"GET" url:url parameter:dic success:success failure:failure];
}

//POST request
- (void)jh_post:(NSString *)url
      parameter:(NSDictionary *)dic
        success:(JHWebRequestSuccess)success
        failure:(JHWebRequestFailure)failure{
    [self jh_method:@"POST" url:url parameter:dic success:success failure:failure];
}

//image upload request
- (void)jh_uploadImage:(NSString *)url
             parameter:(UIImage *)image
            uploadName:(NSString *)uploadName
       serverSavedName:(NSString *)savedName
               success:(JHWebRequestSuccess)success
               failure:(JHWebRequestFailure)failure{
    if (!image) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"com.haocold.JHWebRequest" code:-2 userInfo:@{@"info":@"parameter 'image' is nil!"}];
            failure(error);
        }
        return;
    }
    if (!_success) {
        _success = success;
    }
    if (!_failure) {
        _failure = failure;
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 15.0;

    NSMutableData *requestMutableData=[NSMutableData data];
    
    //1.\r\n--Boundary+72D4CD655314C423\r\n
    static NSString *boundary = @"com.haocold.JHWerRequest";
    NSMutableString *myString = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",boundary];
    
    //2. Content-Disposition: form-data; name="uploadFile"; filename="001.png"\r\n
    [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",uploadName,savedName]];
    
    //3. Content-Type:image/png \r\n  // 图片类型为png
    [myString appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream\r\n"]];
    
    //4. Content-Transfer-Encoding: binary\r\n\r\n  // 编码方式
    [myString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
    
    //转换成为二进制数据
    [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //5.文件数据部分
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [requestMutableData appendData:data];
    
    //6. \r\n--Boundary+72D4CD655314C423--\r\n  // 结束
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置请求体
    request.HTTPBody=requestMutableData;
    
    //设置请求头
    NSString *headStr=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:headStr forHTTPHeaderField:@"Content-Type"];
    
    [self.webView loadRequest:request];
    [self.requestDic setObject:self forKey:[@(_webView.hash) stringValue]];
}

#pragma mark - private

- (void)jh_method:(NSString *)method
              url:(NSString *)url
        parameter:(NSDictionary *)dic
          success:(JHWebRequestSuccess)success
          failure:(JHWebRequestFailure)failure
{
    if (![url isKindOfClass:[NSString class]]) {
        return;
    }
    if ([url length] == 0) {
        return;
    }
    if (![url hasPrefix:@"http"]) {
        return;
    }
    if (!_success) {
        _success = success;
    }
    if (!_failure) {
        _failure = failure;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;
    request.timeoutInterval = _timeoutInterval <= 0 ? 10 : _timeoutInterval;
    NSMutableArray *httpBodys = @[].mutableCopy;
    for (NSString *key in dic.allKeys) {
        NSString *value = dic[key];
        [httpBodys addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    NSString *bodyString = [httpBodys componentsJoinedByString:@"&"];
    
    if ([method isEqualToString:@"GET"]) {
        NSString *URL = [NSString stringWithFormat:@"%@?%@",url,bodyString];
        URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.URL = [NSURL URLWithString:URL];
    }else if ([method isEqualToString:@"POST"]){
        request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
     
    //You may need to set Cookie for the request.
#if 0
    NSArray *array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.example.com"]];
    NSDictionary *cookdict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
    NSString *cookie = cookdict[@"Cookie"];
    if (cookie.length > 0) {
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
#endif
              
    [self.webView loadRequest:request];
    [self.requestDic setObject:self forKey:[@(_webView.hash) stringValue]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *innerText = @"document.body.innerText";
    innerText = [webView stringByEvaluatingJavaScriptFromString:innerText];
    JHWRLog(@"response:%@",innerText);
    
    NSData *data = [innerText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error && _failure) {
        NSError *xx_error = [NSError errorWithDomain:@"com.haocold.JHWebRequest"
                                                code:-1
                                            userInfo:@{@"originalData":innerText,
                                                       @"error":error}];
        _failure(xx_error);
    }else if (_success){
        _success(dic);
    }
    [self.requestDic removeObjectForKey:[@(webView.hash) stringValue]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    JHWRLog(@"error:%@",error);
    if (error && _failure) {
        _failure(error);
    }
    [self.requestDic removeObjectForKey:[@(webView.hash) stringValue]];
}

#pragma mark - getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}
- (NSMutableDictionary *)requestDic{
    if (!_requestDic) {
        _requestDic = @{}.mutableCopy;
    }
    return _requestDic;
}
@end
