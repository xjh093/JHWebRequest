//
//  JHWebRequest.m
//  JHKit
//
//  Created by HaoCold on 2017/10/23.
//  Copyright © 2017年 HaoCold. All rights reserved.
//

#if 1
#define JHWRLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define JHWRLog(...)
#endif

#import "JHWebRequest.h"

@interface JHWebRequest()<UIWebViewDelegate>
@property (strong,  nonatomic) UIWebView *webView;
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
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    JHWRLog(@"error:%@",error);
    if (error && _failure) {
        _failure(error);
    }
}

#pragma mark - getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}
@end
