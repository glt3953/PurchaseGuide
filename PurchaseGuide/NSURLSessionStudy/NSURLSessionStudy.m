//
//  NSURLSessionStudy.m
//  PurchaseGuide
//
//  Created by guoliting on 2019/1/15.
//  Copyright © 2019 NingXia. All rights reserved.
//

#import "NSURLSessionStudy.h"

@interface NSURLSessionStudy () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation NSURLSessionStudy

+ (NSURLSessionStudy *)sharedInstance {
    static NSURLSessionStudy *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (NSMutableData *)responseData {
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    //初始化可变字符串
    NSMutableString *string = [NSMutableString string];
    //拼接开头[
    [string appendString:@"["];
    
    //拼接字典中所有的键值对
    [[NSDictionary alloc] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@",obj];
    }];
    
    //拼接结尾]
    [string appendString:@"]"];
    
    return string;
}

- (void)getFunc {
    //对请求路径的说明
    //http://120.25.226.186:32812/login?username=520it&pwd=520&type=JSON
    //协议头+主机地址+接口名称+？+参数1&参数2&参数3
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
    //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
    
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            [self descriptionWithLocale:dict indent:0];
            
            NSLog(@"%@",dict);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

- (void)postFunc {
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate
//1.接收到服务器响应的时候调用该方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    //在该方法中可以得到响应头信息，即response
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     NSURLSessionResponseBecomeStream        变成一个流
     */
    
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData--%@",[NSThread currentThread]);
    
    //拼接服务器返回的数据
    [self.responseData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError--%@",[NSThread currentThread]);
    
    if(error == nil)
    {
        //解析数据,JSON解析请参考http://www.cnblogs.com/wendingding/p/3815303.html
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
        NSLog(@"%@",dict);
    }
}

@end
