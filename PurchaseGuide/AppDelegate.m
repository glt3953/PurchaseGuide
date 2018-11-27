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

int *arg = NULL;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    id __unsafe_unretained obj = [[NSObject alloc] init]; //编译报错（同weak修饰符）：Assigning retained object to unsafe_unretained variable; object will be released after assignment
//    id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
//    id __weak obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，这样obj1变量持有生成对象的弱引用
    id __weak obj1 = nil;
    {
        id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
        obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，obj1变量持有对象的弱引用
        NSLog(@"obj1: %@", obj1); //输出obj1变量持有的弱引用的对象
    } //因为obj0变量超出其作用域，强引用失效，所以自动释放自己持有的对象。因为该对象无持有者，所以废弃该对象，废弃对象的同时，持有该对象弱引用的obj1变量的弱引用失效，nil赋值给obj1。
    NSLog(@"obj1: %@", obj1); //输出赋值给obj1变量中的nil（weak），若为unsafe_unretained，则运行报错
    
    {
        char *dp = NULL;
        /* ... */
        {
            char c = 'a';
            dp = &c;
            NSLog(@"dp: %s", dp);
        } /* c falls out of scope */
        NSLog(@"dp: %s", dp); //悬垂指针
        /* dp is now a dangling pointer */
    }
    
    {
        char *dp;    /* dp is a wild pointer（野指针） */
        static char *scp;  /* scp is not a wild pointer:
                            * static variables are initialized to 0
                            * at start and retain their values from
                            * the last call afterwards.
                            * Using this feature may be considered bad
                            * style if not commented */
    }
    
    
    fun();
//    int i = 10;
//    arg = &i;
    NSLog(@"第一次：*arg = %d", *arg);
    NSLog(@"第二次：*arg = %d", *arg); //arg已经成为悬垂指针
    
//    HttpServerViewController *defaultViewController = [[HttpServerViewController alloc] init];
    ViewController *defaultViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:defaultViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

/* Alternative version for 'free()' */
void safefree(void **pp)
{
    if (pp != NULL) {               /* safety check */
        free(*pp);                  /* deallocate chunk, note that free(NULL) is valid */
        *pp = NULL;                 /* reset original pointer */
    }
}

void fun()
{
    int i = 10;
    arg = &i;
    char *p = NULL, *p2;
    p = (char *)malloc(1000);    /* get a chunk */
    p2 = p;              /* copy the pointer */
    NSLog(@"p2: %s", p2);
    /* use the chunk here */
    safefree(&p);       /* safety freeing; does not affect p2 variable */
    NSLog(@"p2: %s", p2);
    safefree(&p);       /* this second call won't fail */
    NSLog(@"p2: %s", p2);
    char c = *p2;       /* p2 is still a dangling pointer, so this is undefined behavior. */
    NSLog(@"p2: %s", p2);
    NSLog(@"c: %c", c);
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
