//
//  CommonFuncs.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *imageView2Thumbnails = @"?imageView2/0/h/";
static NSString *imageView2ThumbnailsForPC = @"?imageView2/2/h/";
static NSString *imageMogr2Thumbnails = @"?imageMogr2/auto-orient/thumbnail/";
static NSString *imageMogr2 = @"?imageMogr2";
static NSString *imageBlur = @"/blur/15x3"; //高斯模糊，半径为15，Sigma值为3
static const CGFloat statusBarHeight = 20.0f;
static const CGFloat navigationBarHeight = 44.0f;
static const CGFloat tabBarHeight = 49.0f;
static NSString *fontIconName = @"107RoomIcon";
static NSString *dateFormatForJSON = @"yyyyMMdd";
static NSString *userInfoURI = @"room107://userInfo"; //账户设置页的URI
static NSString *aboutURI = @"room107://about"; //关于页的URI
static NSString *feedbackURI = @"room107://feedback"; //意见箱页的URI
static NSString *accountInfoURI = @"room107://accountInfo"; //用户中心页的URI
static NSString *userLoginURI = @"room107://userLogin"; //登录页的URI
static NSString *userVerifyURI = @"room107://userVerify"; //认证页的URI
static NSString *contractTenantStatusURI = @"room107://contractTenantStatus"; //租客合同填写页的URI
static NSString *htmlURI = @"room107://html"; //html的URI，params：url(需要urldecode)，title，authority（不写为无访问权限，login为需要登录权限）
static NSString *shareURI = @"room107://share"; //share的URI，params：title，content，imageUrl，targetUrl
static NSString *simplePopupURI = @"room107://simplePopup"; //simplePopup的URI，params：title，content，url（需要urldecode，表示点击弹窗确认后的操作，可以为空）
static NSString *selectPopupURI = @"room107://selectPopup"; //selectPopup的URI，params：title，content，url（需要urldecode，表示点击弹窗确认后的操作，可以为空）
static NSString *houseDetailURI = @"room107://houseDetail"; //房子详情页的URI，houseId，roomId
static NSString *houseManageAddURI = @"room107://houseManageAdd"; //发布房子的URI
static NSUInteger maxUInteger = 2147483647;
static int maxPaymentCost = 5000 * 100; //支付金额峰值，单位：分
static NSUInteger networkErrorCode = 2000; //网络异常的错误码
static NSUInteger unLoginCode = 1000; //未登录的错误码
static NSUInteger unAuthenticateCode = 1001; //未认证的错误码
static NSUInteger BusinessErrorCode = 1006; //业务限制（如查看电话次数限制，取现限制等）
static NSUInteger maxPriceDigit = 6; //价格输入的位数限制
static NSUInteger maxNumberOfPhotos = 6; //房间照片的张数限制
static const NSTimeInterval kAnimationDuration = 2.5f; //App启动动画时间
static const NSTimeInterval kStopAnimationDuration = 1.0f; //App启动画面停留时间
static const NSTimeInterval kAdimageStopDuration = 2.0f; //App广告页停留时间
static const NSTimeInterval kDragAnimationDuration = 0.5f; //“107”间动画网络请求后的停留时间
static NSString *defaultMapSearchPosition = @"116.316307,39.99878"; //本地维护的默认坐标
static NSString *platformKey = @"ios";
static NSUInteger imageMaxCacheSize = 1024 * 1024 * 8; //最大的图片缓存大小

typedef enum {
    UserIdentityTypeTenant = 0, //租客
    UserIdentityTypeLandlord, //房东
} UserIdentityType;

@interface CommonFuncs : NSObject

//获得设备尺寸的序号
+ (NSInteger)indexOfDeviceScreen; //0:3.5，1:4.0，2:4.7，3:5.5
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
//tableView通用Frame
+ (CGRect)tableViewFrame;
+ (CGSize)mainScreenSize;
+ (NSDictionary *)newCoverDic;
+ (int)randomNumber;
+ (void)callTelephone:(NSString *)phoneNumber;
+ (NSNumber *)rentTypeForHouse; //整租类型
//浮点数转换为百分比
+ (NSString *)percentString:(float)floatValue;
/*!
 * get device ip address
 */
+ (NSString *)deviceIPAdress;

+ (NSString *)iconCodeByHexStr:(NSString *)hexStr;

+ (NSString *)moneyStrByDouble:(double)money;

+ (NSNumber *)rentTypeConvert:(NSUInteger)type;

+ (NSNumber *)requiredGender:(NSUInteger)type;

+ (NSInteger)indexOfRentType:(NSNumber *)type;

+ (NSInteger)indexOfGender:(NSNumber *)gender;

+ (NSString *)requiredGenderText:(NSNumber *)gender;
+ (NSString *)requiredGenderTextForWXMediaMessage:(NSNumber *)gender;  //微信分享需要得到的房间信息特定api

+ (NSString *)genderPickerText:(NSInteger)index;
+ (NSString *)rentTypeSwitchText:(NSInteger)index;
+ (NSString *)priceRangeSliderText:(int)leftValue andRightValue:(int)rightValue;
+ (NSString *)roomsPickerText:(NSInteger)index;

+ (NSString *)chineseFigureByNumber:(NSNumber *)number;

+ (CGFloat)shadowOpacity;
+ (CGFloat)shadowRadius;
+ (UIColor *)shadowColor;

+ (CGFloat)mapZoomLevel;

//房间详情页其他区块的Size
+ (CGSize)suiteViewOtherCellSize;

//房间详情页图片区块的Size
+ (CGSize)houseImageCellSize;

+ (CGFloat)houseCardHeight;

+ (CGFloat)houseImageHeight;

+ (CGFloat)cornerRadius;

+ (CGSize)houseLandlordListImageViewSize;

+ (CGSize)houseLandlordListCollectionViewCellSize;

+ (BOOL)arrayHasThisContent:(NSArray *)array andObject:(id)object;

//根据文字及相关属性获得Rect值
+ (CGRect)rectWithText:(NSString *)text andMaxDisplayWidth:(CGFloat)maxDisplayWidth andAttributes:(NSDictionary *)attributes;

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

//发房理房页面 多选框自适应屏幕高度
+ (CGFloat)getSuiteFacilitiesTableViewCellHeight;

@end

#define IS_BITS_SET(V, B) (((V) & (B)) == (B))
#define CLEAR_BITS(V, B) ((V) &= ~(B))
#define SET_BITS(V, B) ((V) |= (B))

#define LocalizedString(stringkey)  NSLocalizedString(stringkey, nil)
