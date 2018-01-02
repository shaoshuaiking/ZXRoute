//
//  ZXBusMediator.h
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/26.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+NavigationTip.h"

/**
 *中间件向调用者提供：
 *(1)baseViewController的传递key: ZXRouteViewControllerKey
 *(2)newController导航方式的传递key: ZXRouteModeKey
 * 3)ZXBusNavigator.h定义了目前支持的导航方式有三种；
 */
#import "ZXBusNavigator.h"
FOUNDATION_EXTERN NSString *__nonnull const ZXRouteViewControllerKey;
FOUNDATION_EXTERN NSString *__nonnull const ZXRouteModeKey;
/**
 * @class ZXBusMediator
 *总线控制中心
 */
@protocol ZXBusConnectorPrt;
@interface ZXBusMediator : NSObject

#pragma mark - 向总控制中心注册挂接点
//connector自load过程中，注册自己
+(void)registerConnector:(nonnull id<ZXBusConnectorPrt>)connector;

#pragma mark - 页面跳转接口
//判断某个URL能否导航
+(BOOL)canRouteURL:(nonnull NSURL *)URL;

//通过URL直接完成页面跳转
+(BOOL)routeURL:(nonnull NSURL *)URL;
+(BOOL)routeURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params;

//通过URL获取viewController实例
+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL;
+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL
                                    withParameters:(nullable NSDictionary *)params;

#pragma mark - 服务调用接口
//根据protocol 获取服务实例
+(nullable id)serviceForProtocol:(nonnull Protocol *)protocol;
@end
