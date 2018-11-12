//
//  HttpServerViewController.m
//  PurchaseGuide
//
//  Created by guoliting on 2018/11/12.
//  Copyright © 2018 NingXia. All rights reserved.
//

#import "HttpServerViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"

@interface HttpServerViewController ()

@property (nonatomic, strong) HTTPServer * httpServer;

@end

@implementation HttpServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Http Server 测试"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setPort:1234];
    [_httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString * webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    [_httpServer setDocumentRoot:webPath];
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *err;
    if ([_httpServer start:&err]) {
        NSLog(@"port %hu",[_httpServer listeningPort]);
    }else{
        NSLog(@"%@",err);
    }
    NSString *ipStr = [self getIpAddresses];
    NSLog(@"ip地址 %@", ipStr);
    
    NSString *uploadDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"本地文件夹： %@", uploadDirPath);
}

- (NSString *)getIpAddresses {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
