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

@property (nonatomic, strong) NSMutableArray *items; // 顺序队列
@property (nonatomic) NSUInteger numItems; // 队列长度
@property (nonatomic) NSUInteger head; // head 表示队头下标
@property (nonatomic) NSUInteger tail; // tail 表示队尾下标

@end

@implementation AppDelegate

int cal(int n) {
    //2(9),3(36),4(100),5(225)
    int sum = 0;
    int i = 1;
    int j = 1;
    for (; i <= n; ++i) {
        j = 1;
        for (; j <= n; ++j) {
            sum = sum +  i * j;
        }
    }
    
    return sum;
}

void func() {
    int i = 0;
    int arr[4] = {0};
    for(; i <= 5; i++){
        arr[i] = 0;
        printf("hello world\n");
    }
}

- (void)initItems:(NSUInteger)capacity {
    _items = [[NSMutableArray alloc] initWithCapacity:capacity];
    _numItems = capacity;
    _head = 0;
    _tail = 0;
}

- (BOOL)enqueue:(NSString *)item {
    if (_tail == _numItems) {
        // 表示队列已经满了
        if (_head == 0) {
            // 表示整个队列都占满了
            return NO;
        }
        
        //数据搬移
        for (NSUInteger i = _head; i < _tail; ++i) {
            _items[i-_head] = _items[i];
        }
        
        // 搬移完之后更新head和tail
        _tail -= _head;
        _head -= 0;
        
        return NO;
    }
    
    _items[_tail] = item;
    ++_tail;
    
    return YES;
}

- (NSString *)dequeue {
    if (_head == _tail) {
        // 表示队列为空
        return NULL;
    }
    
    NSString *ret = _items[_head];
    ++_head;
    
    return ret;
}

- (void)bubbleSort {
    NSMutableArray *sourceArray = [@[@3, @5, @4, @1, @2, @6] mutableCopy];
    NSUInteger n = sourceArray.count;
    
    for (NSUInteger i = 0; i < n; ++i) {
        BOOL endFlag = NO; // 提前退出冒泡循环的标志位
        for (NSUInteger j = 0; j < n - i - 1; ++j) {
            if (sourceArray[j] > sourceArray[j+1]) {
                // 交换
                NSNumber *tmp = sourceArray[j];
                sourceArray[j] = sourceArray[j+1];
                sourceArray[j+1] = tmp;
                endFlag = YES; // 表示有数据交换
            }
        }
        
        if (!endFlag) {
            // 没有数据交换，提前退出
            break;
        }
    }
}

- (void)insertionSort {
    NSMutableArray *sourceArray = [@[@3, @5, @4, @1, @2, @6] mutableCopy];
    NSUInteger n = sourceArray.count;
    
    for (NSUInteger i = 1; i < n; ++i) {
        NSNumber *value = sourceArray[i];
        NSUInteger j = i - 1;

        for (; j >= 0; --j) {
            if (sourceArray[j] > value) {
                // 数据移动
                sourceArray[j+1] = sourceArray[j];
            } else {
                break;
            }
        }
        
        sourceArray[j+1] = value; // 插入数据
    }
}

- (int)approximateSquareRootByNum:(CGFloat)num min:(CGFloat)min max:(CGFloat)max {
    CGFloat value = (min + max) / 2;
    
    if (value * value == num || (max - min) < 0.01) {
        int approximateSquareRoot = (int)(max + 0.5);
        return approximateSquareRoot;
    } else if (value * value > num) {
        max = value;
    } else {
        min = value;
    }
    
    return [self approximateSquareRootByNum:num min:min max:max];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGFloat num = 13;
    CGFloat min = 1;
    CGFloat max = num;
    [self approximateSquareRootByNum:num min:min max:max];
    
    NSUInteger capacity = 6;
    [self initItems:capacity];
    for (NSUInteger i = 0; i < capacity; i++) {
        [self enqueue:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        
        if (i % 2 == 0) {
            NSString *item = [self dequeue];
            NSLog(@"item:%@", item);
        }
    }
    
//    func();
//    cal(5);
    
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
//    int i = 10;`
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
