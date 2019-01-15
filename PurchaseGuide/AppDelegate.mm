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

// 求一个数的平方根
- (CGFloat)approximateSquareRootByNum:(CGFloat)num min:(CGFloat)min max:(CGFloat)max {
    CGFloat value = (min + max) / 2;
    
    if (value * value == num || (max - min) < 0.000001) {
//        CGFloat approximateSquareRoot = (int)(max + 0.5);
//        int n = 1000000;
//        int tmp = (int)(value * n);
//        value = (CGFloat)tmp / n;
        return value;
    } else if (value * value > num) {
        max = value;
    } else {
        min = value;
    }
    
    return [self approximateSquareRootByNum:num min:min max:max];
}

// 计数排序，a 是数组，n 是数组大小。假设数组中存储的都是非负整数。
void countingSort(int a[], int n) {
    if (n <= 1) return;
    
    // 查找数组中数据的范围
    int max = a[0];
    for (int i = 1; i < n; ++i) {
        if (max < a[i]) {
            max = a[i];
        }
    }
    
    int *c = new int[max + 1]; // 申请一个计数数组 c，下标大小 [0,max]
    for (int i = 0; i <= max; ++i) {
        c[i] = 0;
    }
    
    // 计算每个元素的个数，放入 c 中
    for (int i = 0; i < n; ++i) {
        c[a[i]]++;
    }
    
    // 依次累加
    for (int i = 1; i <= max; ++i) {
        c[i] = c[i-1] + c[i];
    }
    
    // 临时数组 r，存储排序之后的结果
    int *r = new int[n];
    // 计算排序的关键步骤，有点难理解
    for (int i = n - 1; i >= 0; --i) {
        int index = c[a[i]]-1;
        r[index] = a[i];
        c[a[i]]--;
    }
    
    // 将结果拷贝给 a 数组
    for (int i = 0; i < n; ++i) {
        a[i] = r[i];
    }
}

// 二分查找
int binarySearch(int a[], int n, int value) {
    int low = 0;
    int high = n - 1;
    
    while (low <= high) {
        int mid = low + ((high - low) >> 1); // 如果 low 和 high 比较大的话，两者之和就有可能会溢出
        
        if (a[mid] > value) {
            high = mid - 1;
        } else {
            if ((mid == n - 1) || (a[mid + 1] > value)) {
                // 查找最后一个小于等于给定值的元素
                return mid;
            } else {
                low = mid + 1;
            }
        }
//        if (a[mid] < value) {
//            low = mid + 1;
//        } else {
//            if ((mid == 0) || (a[mid - 1] < value)) {
//                // 查找第一个大于等于给定值的元素
//                return mid;
//            } else {
//                high = mid - 1;
//            }
//        }
        
//        if (a[mid] > value) {
//            high = mid - 1;
//        } else if (a[mid] < value) {
//            low = mid + 1;
//        } else {
//            if ((mid == n - 1) || (a[mid + 1] != value)) {
//                // 查找最后一个值等于给定值的元素
//                return mid;
//            } else {
//                low = mid + 1;
//            }
//
////            if ((mid == 0) || (a[mid - 1] != value)) {
////                // 查找第一个值等于给定值的元素
////                return mid;
////            } else {
////                high = mid - 1;
////            }
//        }
        
//        if (a[mid] == value) {
//            // 查找值等于给定值的元素
//            return mid;
//        } else if (a[mid] < value) {
//            low = mid + 1;
//        } else {
//            high = mid - 1;
//        }
    }
    
    return -1;
}

void getReword(long totalReward, long *result) {
    if (totalReward == 0) {
        for (int i = 0; i < sizeof(result) / sizeof(result[0]); i++) {
            printf("%ld\n", result[i]);
        }
        return;
    } else if (totalReward < 0) {
        return;
    } else {
        for (int i = 0; i < sizeof(result) / sizeof(result[0]); i++) {
            long *newResult = nullptr;
            memcpy(newResult, result, sizeof(result) / sizeof(result[0]) * sizeof(long));
            getReword(totalReward - result[i], newResult);
        }
    }
}

- (void)getReward:(NSUInteger)totalReward result:(NSArray *)result {
    static NSArray *rewards = @[@1, @2, @5, @10];
    
    if (totalReward == 0) {
        for (NSUInteger i = 0; i < result.count; i++) {
            NSLog(@"%@\n", result[i]);
        }
    } else if (totalReward > 0) {
        for (NSUInteger i = 0; i < rewards.count; i++) {
            NSMutableArray *newResult = [result mutableCopy];
            [newResult addObject:rewards[i]];
            [self getReward:totalReward - [rewards[i] unsignedIntegerValue] result:newResult];
        }
    }
}

//奇、偶数校验
- (void)oddOrEven {
    int odd_cnt = 0;
    int even_cnt = 0;
    long maxValue = 100000000;
    NSTimeInterval startInterval = [NSDate timeIntervalSinceReferenceDate];
    
    //位运算
    for (long i = 0; i < maxValue; i++) {
        if ((i & 1) == 0) {
            even_cnt++;
        } else {
            odd_cnt++;
        }
    }
    
    NSTimeInterval endInterval = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"位运算耗时：%f", endInterval - startInterval);
    NSLog(@"位运算的奇数：%d个，偶数：%d个", odd_cnt, even_cnt);
    
    odd_cnt = 0;
    even_cnt = 0;
    startInterval = [NSDate timeIntervalSinceReferenceDate];
    
    //模运算
    for (long i = 0; i < maxValue; i++) {
        if ((i % 2) == 0) {
            even_cnt++;
        } else {
            odd_cnt++;
        }
    }
    
    endInterval = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"模运算耗时：%f", endInterval - startInterval);
    NSLog(@"模运算的奇数：%d个，偶数：%d个", odd_cnt, even_cnt);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self oddOrEven];
    
//    NSUInteger totalReward = 10;
//    NSArray *result = @[@1, @2, @5, @10];
//    [self getReward:totalReward result:result];
    
//    long totalReward = 10;
//    long result[] = {1, 2, 5, 10};
//    getReword(totalReward, result);
    
    int value = 8;
    int a[] = {1, 3, 5, 8, 8, 8, 10, 13, 15, 20};
    binarySearch(a, sizeof(a) / sizeof(a[0]), value);
//    int a[8] = {2, 5, 3, 0, 2, 3, 0, 3};
//    countingSort(a, n);
    
//    CGFloat num = 13;
//    CGFloat min = 1;
//    CGFloat max = num;
//    [self approximateSquareRootByNum:num min:min max:max];
//    
//    NSUInteger capacity = 6;
//    [self initItems:capacity];
//    for (NSUInteger i = 0; i < capacity; i++) {
//        [self enqueue:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
//        
//        if (i % 2 == 0) {
//            NSString *item = [self dequeue];
//            NSLog(@"item:%@", item);
//        }
//    }
//    
////    func();
////    cal(5);
//    
////    id __unsafe_unretained obj = [[NSObject alloc] init]; //编译报错（同weak修饰符）：Assigning retained object to unsafe_unretained variable; object will be released after assignment
////    id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
////    id __weak obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，这样obj1变量持有生成对象的弱引用
//    id __weak obj1 = nil;
//    {
//        id __strong obj0 = [[NSObject alloc] init]; //自己生成并持有对象
//        obj1 = obj0; //因为obj0变量为强引用，所以自己持有对象，obj1变量持有对象的弱引用
//        NSLog(@"obj1: %@", obj1); //输出obj1变量持有的弱引用的对象
//    } //因为obj0变量超出其作用域，强引用失效，所以自动释放自己持有的对象。因为该对象无持有者，所以废弃该对象，废弃对象的同时，持有该对象弱引用的obj1变量的弱引用失效，nil赋值给obj1。
//    NSLog(@"obj1: %@", obj1); //输出赋值给obj1变量中的nil（weak），若为unsafe_unretained，则运行报错
//    
//    {
//        char *dp = NULL;
//        /* ... */
//        {
//            char c = 'a';
//            dp = &c;
//            NSLog(@"dp: %s", dp);
//        } /* c falls out of scope */
//        NSLog(@"dp: %s", dp); //悬垂指针
//        /* dp is now a dangling pointer */
//    }
//    
//    {
//        char *dp;    /* dp is a wild pointer（野指针） */
//        static char *scp;  /* scp is not a wild pointer:
//                            * static variables are initialized to 0
//                            * at start and retain their values from
//                            * the last call afterwards.
//                            * Using this feature may be considered bad
//                            * style if not commented */
//    }
//    
////    int i = 10;`
////    arg = &i;
//    NSLog(@"第一次：*arg = %d", *arg);
//    NSLog(@"第二次：*arg = %d", *arg); //arg已经成为悬垂指针

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
