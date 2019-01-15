//
//  CommonFuncs.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "CommonFuncs.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>

@implementation CommonFuncs

+ (NSInteger)indexOfDeviceScreen {
    switch ((NSInteger)CGRectGetHeight([[UIScreen mainScreen] bounds])) {
        case 480:
            return 0;
            break;
        case 568:
            return 1;
            break;
        case 667:
            return 2;
            break;
        default:
            //736
            return 3;
            break;
    }
}

+ (NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1593/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1589/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus (A1699)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s (A1700)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
   
    return platform;
}

+ (CGRect)tableViewFrame {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y = 0;
    frame.size.height -= statusBarHeight + navigationBarHeight;
    
    return frame;
}

+ (CGSize)mainScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

+ (NSDictionary *)newCoverDic {
    return @{@"height":@0, @"url":@"", @"width":@0};
}

+ (int)randomNumber {
    return arc4random() % 1000;
}

+ (void)callTelephone:(NSString *)phoneNumber {
    NSString *telephoneString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
}

+ (NSNumber *)rentTypeForHouse {
    return @2;
}

+ (NSString *)percentString:(float)floatValue {
    return [NSString stringWithFormat:@"%.1f%%", floatValue * 100];
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
//    LogDebug(@"手机的IP是：%@", address);
    
    return address;  
}

+ (NSString *)iconCodeByHexStr:(NSString *)hexStr {
    NSString *unicodeStr = [NSString stringWithFormat:@"\"\\U%@\"", hexStr];
    NSData *tempData = [unicodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSPropertyListSerialization propertyListWithData:tempData options:0 format:NULL error:NULL];
}

+ (NSString *)moneyStrByDouble:(double)money {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;//加上了人民币标志，原值2.7999999999，输出￥2.8
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *valueString = [formatter stringFromNumber:[NSNumber numberWithDouble:money]];
    
    return [valueString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSNumber *)rentTypeConvert:(NSUInteger)type {
    switch (type) {
        case 1:
            //整租
            return @2;
            break;
        case 2:
            //分租
            return @1;
            break;
        default:
            return @3;
            break;
    }
}

+ (NSNumber *)requiredGender:(NSUInteger)type {
    switch (type) {
        case 1:
            //女性
            return @2;
            break;
        case 2:
            //男性
            return @1;
            break;
        default:
            return [NSNumber numberWithUnsignedInteger:type];
            break;
    }
}

+ (NSInteger)indexOfRentType:(NSNumber *)type {
    switch ([type intValue]) {
        case 1:
            //合租
            return 2;
            break;
        case 2:
            //整租
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

+ (NSInteger)indexOfGender:(NSNumber *)gender {
    switch ([gender intValue]) {
        case 1:
            //男性
            return 2;
            break;
        case 2:
            //女性
            return 1;
            break;
        default:
            return [gender intValue];
            break;
    }
}

//找房页卡片、房子详情、相似房间卡片、地图找房下方的房子卡片、待签约卡片、出租房子管理 分租时，如果不限男女，不需要显示“不限男女”的字样
+ (NSString *)requiredGenderText:(NSNumber *)gender {
    switch ([gender intValue]) {
        case 1:
            return lang(@"MaleLimit");
            break;
        case 2:
            return lang(@"FemaleLimit");
            break;
        default:
            return @"";
            break;
    }
}

//微信分享需要得到的房间信息特定api  如果不限男女，显示“不限男女”的字样
+ (NSString *)requiredGenderTextForWXMediaMessage:(NSNumber *)gender {
    switch ([gender intValue]) {
        case 1:
            return lang(@"MaleLimit");
            break;
        case 2:
            return lang(@"FemaleLimit");
            break;
        default:
            return lang(@"NoLimitGender");
            break;
    }
}

+ (NSString *)genderPickerText:(NSInteger)index {
    NSArray *genderArray = @[lang(@"AllHouse"), lang(@"Female"), lang(@"Male"), lang(@"Male&Female")];
    return genderArray[index];
}

+ (NSString *)rentTypeSwitchText:(NSInteger)index {
    NSArray *rentTypeArray = @[lang(@"All"), lang(@"RentHouse"), lang(@"RentRoom")];
    return rentTypeArray[index];
}

+ (NSString *)priceRangeSliderText:(int)leftValue andRightValue:(int)rightValue {
    if (rightValue == 10000) {
        return [NSString stringWithFormat:@"￥%d-￥10000+", leftValue];
    } else {
        return [NSString stringWithFormat:@"￥%d-￥%d", leftValue, rightValue];
    }
}

+ (NSString *)roomsPickerText:(NSInteger)index {
    NSMutableArray *roomsArray = [@[lang(@"NoLimit"), @"1", @"2", @"3", @"4+"] mutableCopy];
    for (NSUInteger i = 1; i < roomsArray.count; i++) {
        roomsArray[i] = [roomsArray[i] stringByAppendingString:lang(@"Room")];
    }
    return roomsArray[index];
}

+ (NSString *)chineseFigureByNumber:(NSNumber *)number {
    NSArray *chineseFigures = @[@"0", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    
    if (number && chineseFigures.count > [number intValue]) {
        return chineseFigures[[number intValue]];
    }
    return chineseFigures[0];
}

+ (CGFloat)shadowOpacity {
    return 0.5f;
}

+ (CGFloat)shadowRadius {
    return 4.0f;
}

+ (UIColor *)shadowColor {
    return [UIColor lightGrayColor];
}

+ (CGFloat)mapZoomLevel {
    return 15.0f;
}

+ (CGSize)suiteViewOtherCellSize {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - 2 * 11;
    return CGSizeMake(width, width / 1.5);
}

+ (CGSize)houseImageCellSize {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake(width, width * 9 / 16);
}

+ (CGFloat)houseCardHeight {
    return [self houseImageHeight] + 2 * 11 + 16 + 7 + 12;
}

+ (CGFloat)houseImageHeight {
    return ([[UIScreen mainScreen] bounds].size.width - 2 * 11) / 1.5;
}

+ (CGFloat)cornerRadius {
    return 6.0f;
}

+ (CGSize)houseLandlordListImageViewSize {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - 22 * 2;
    return CGSizeMake(width, width * 2 / 3);
}

+ (CGSize)houseLandlordListCollectionViewCellSize {
    CGSize cellSize = [self houseLandlordListImageViewSize];
    cellSize.height += 61;
    return cellSize;
}

+ (BOOL)arrayHasThisContent:(NSArray *)array andObject:(id)object {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", object];
    NSArray *arr = [array filteredArrayUsingPredicate:predicate];
    if (!arr || arr.count == 0) {
        return NO;
    }
    
    return YES;
}

+ (CGRect)rectWithText:(NSString *)text andMaxDisplayWidth:(CGFloat)maxDisplayWidth andAttributes:(NSDictionary *)attributes {
    return [text ? text : @"" boundingRectWithSize:(CGSize){maxDisplayWidth, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:lang(@"OK"), nil];
    [alert show];
}

+ (CGFloat)getSuiteFacilitiesTableViewCellHeight {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemHeight = (screenWidth - 44 - 33)/4;
    return 25 + itemHeight * 2 + 11 + 44;
}

@end
