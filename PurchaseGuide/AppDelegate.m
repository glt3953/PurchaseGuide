//
//  AppDelegate.m
//  PurchaseGuide
//
//  Created by guoliting on 2018/7/3.
//  Copyright © 2018年 NingXia. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpServerViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    id __weak obj = [[NSObject alloc] init]; //编译报错：Assigning retained object to weak variable; object will be released after assignment
//    id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
//    id __weak obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，这样obj1变量持有生成对象的弱引用
    id __weak obj1 = nil;
    {
        id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
        obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，obj1变量持有对象的弱引用
        NSLog(@"A: %@", obj1); //输出obj1变量持有的弱引用的对象
    } //因为obj0变量超出其作用域，强引用失效，所以自动释放自己持有的对象。因为该对象无持有者，所以废弃该对象，废弃对象的同时，持有该对象弱引用的obj1变量的弱引用失效，nil赋值给obj1。
    NSLog(@"B: %@", obj1); //输出赋值给obj1变量中的nil
    
//    HttpServerViewController *defaultViewController = [[HttpServerViewController alloc] init];
    ViewController *defaultViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:defaultViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
