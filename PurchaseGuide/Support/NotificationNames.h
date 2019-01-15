//
//  NotificationNames.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 发现新客户端版本通知
extern NSString * const ClientNewVersionDidFindNotification;

extern NSString * const ClientDidLogoutNotification;
extern NSString * const ClientDidLoginNotification;
// = Connection

extern NSString * const ClientAuthenticationStateDidChangeNotification;

extern NSString * const SideslipCenterViewControllerDidChangeNotification;
extern NSString * const SideslipShowLeftViewNotification;
extern NSString * const SideslipShowCenterViewNotification;
extern NSString * const SideslipLeftViewDidShowNotification;

extern NSString * const WechatPayNotification;
extern NSString * const WechatGrantNotification;

extern NSString * const NewMessageNotification;
extern NSString * const CurrentViewControllerDidChangeNotification;

//Tab切换的广播
extern NSString * const TabBarControllerSelectedIndexDidChangeNotification;

//从列表删除当前模板的广播
extern NSString * const DeleteCardNotification;

//用户头像更换
extern NSString * const UserAvatarDidChangeNotification;

//底部栏小红点更新
extern NSString * const HomeReddieDidChangeNotification;

//取消订阅成功
extern NSString * const CancelSubscribeSuccessNotification;

extern NSString * const BindingTelephoneDismissNotification;