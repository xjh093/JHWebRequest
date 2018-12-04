# JHWebRequest
使用webview发起请求

### 使用 & USAGE
```
    [self.webRequest jh_get:kURL parameter:dic success:^(NSDictionary *dic) {
        NSLog(@"success dic:%@",dic);
    } failure:^(NSError *error) {
        NSLog(@"failure error:%@",error);
    }];
```
or
```
    [[JHWebRequestManager manager] jh_post:kURL parameter:dic success:^(NSDictionary *dic) {
        NSLog(@"success dic:%@",dic);
    } failure:^(NSError *error) {
        NSLog(@"failure error:%@",error);
    }];
```
