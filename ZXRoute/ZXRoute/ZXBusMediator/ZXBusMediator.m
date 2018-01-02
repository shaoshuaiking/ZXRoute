//
//  ZXBusMediator.m
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/26.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import "ZXBusMediator.h"
#import "ZXBusNavigator.h"
#import "ZXBusConnectorPrt.h"
#import "ZXBusMediatorTipViewController.h"

NSString * const ZXRouteViewControllerKey = @"ZXRouteViewController";
NSString * __nonnull const ZXRouteModeKey = @"ZXRouteType";

//全部保存各个模块的connector实例
static NSMutableDictionary<NSString *, id<ZXBusConnectorPrt>> *g_connectorMap = nil;


@implementation ZXBusMediator

#pragma mark - 向总控制中心注册挂接点

+(void)registerConnector:(nonnull id<ZXBusConnectorPrt>)connector{
    if (![connector conformsToProtocol:@protocol(ZXBusConnectorPrt)]) {
        return;
    }
    
    @synchronized(g_connectorMap) {
        if (g_connectorMap == nil){
            g_connectorMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        }
        
        NSString *connectorClsStr = NSStringFromClass([connector class]);
        if ([g_connectorMap objectForKey:connectorClsStr] == nil) {
            [g_connectorMap setObject:connector forKey:connectorClsStr];
        }
    }
}


#pragma mark - 页面跳转接口

//判断某个URL能否导航
+(BOOL)canRouteURL:(nonnull NSURL *)URL{
    if(!g_connectorMap || g_connectorMap.count <= 0) return NO;
    
    __block BOOL success = NO;
    //遍历connector不能并发
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<ZXBusConnectorPrt>  _Nonnull connector, BOOL * _Nonnull stop) {
        if([connector respondsToSelector:@selector(canOpenURL:)]){
            if ([connector canOpenURL:URL]) {
                success = YES;
                *stop = YES;
            }
        }
    }];
    
    return success;
}


+(BOOL)routeURL:(nonnull NSURL *)URL{
    return [self routeURL:URL withParameters:nil];
}


+(BOOL)routeURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params{
    if(!g_connectorMap || g_connectorMap.count <= 0) return NO;
    
    __block BOOL success = NO;
    __block int queryCount = 0;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<ZXBusConnectorPrt>  _Nonnull connector, BOOL * _Nonnull stop) {
        queryCount++;
        if([connector respondsToSelector:@selector(connectToOpenURL:params:)]){
            id returnObj = [connector connectToOpenURL:URL params:userParams];
            if(returnObj && [returnObj isKindOfClass:[UIViewController class]]){
                if ([returnObj isKindOfClass:[ZXBusMediatorTipViewController class]]) {
                    ZXBusMediatorTipViewController *tipController = (ZXBusMediatorTipViewController *)returnObj;
                    if (tipController.isNotURLSupport) {
                        success = YES;
                    } else {
                        success = NO;
#if DEBUG
                        [tipController showDebugTipController:URL withParameters:params];
                        success = YES;
#endif
                    }
                } else if ([returnObj class] == [UIViewController class]){
                    success = YES;
                } else {
                    [[ZXBusNavigator navigator] hookShowURLController:returnObj baseViewController:params[ZXRouteViewControllerKey] routeMode:params[ZXRouteModeKey]?[params[ZXRouteModeKey] intValue]:NavigationModePush];
                    success = YES;
                }
                
                *stop = YES;
            }
        }
    }];
    
    
#if DEBUG
    if (!success && queryCount == g_connectorMap.count) {
        [((ZXBusMediatorTipViewController *)[UIViewController notFound]) showDebugTipController:URL withParameters:params];
        return NO;
    }
#endif
    
    return success;
}


+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL{
    return [self viewControllerForURL:URL withParameters:nil];
}


+(nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params{
    if(!g_connectorMap || g_connectorMap.count <= 0) return nil;
    
    __block UIViewController *returnObj = nil;
    __block int queryCount = 0;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<ZXBusConnectorPrt>  _Nonnull connector, BOOL * _Nonnull stop) {
        queryCount++;
        if([connector respondsToSelector:@selector(connectToOpenURL:params:)]){
            returnObj = [connector connectToOpenURL:URL params:userParams];
            if(returnObj && [returnObj isKindOfClass:[UIViewController class]]){
                *stop = YES;
            }
        }
    }];
    
    
#if DEBUG
    if (!returnObj && queryCount == g_connectorMap.count) {
        [((ZXBusMediatorTipViewController *)[UIViewController notFound]) showDebugTipController:URL withParameters:params];
        return nil;
    }
#endif
    
    
    if (returnObj) {
        if ([returnObj isKindOfClass:[ZXBusMediatorTipViewController class]]) {
#if DEBUG
            [((ZXBusMediatorTipViewController *)returnObj) showDebugTipController:URL withParameters:params];
#endif
            return nil;
        } else if([returnObj class] == [UIViewController class]){
            return nil;
        } else {
            return returnObj;
        }
    }
    
    return nil;
}


/**
 * 从url获取query参数放入到参数列表中
 */
+(NSDictionary *)userParametersWithURL:(nonnull NSURL *)URL andParameters:(nullable NSDictionary *)params{
    NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [self URLDecodedString:[kv objectAtIndex:1]];
            [userParams setObject:value forKey:key];
        }
    }
    [userParams addEntriesFromDictionary:params];
    return [NSDictionary dictionaryWithDictionary:userParams];
}


/**
 * 对url的value部分进行urlDecoding
 */
+(nonnull NSString *)URLDecodedString:(nonnull NSString *)urlString
{
    NSString *result = urlString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                   (__bridge CFStringRef)urlString,
                                                                                                   CFSTR(""),
                                                                                                   kCFStringEncodingUTF8);
#else
    result = [urlString stringByRemovingPercentEncoding];
#endif
    return result;
}


#pragma mark - 服务调用接口

+(nullable id)serviceForProtocol:(nonnull Protocol *)protocol{
    if(!g_connectorMap || g_connectorMap.count <= 0) return nil;
    
    __block id returnServiceImp = nil;
    [g_connectorMap enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, id<ZXBusConnectorPrt>  _Nonnull connector, BOOL * _Nonnull stop) {
        if([connector respondsToSelector:@selector(connectToHandleProtocol:)]){
            returnServiceImp = [connector connectToHandleProtocol:protocol];
            if(returnServiceImp){
                *stop = YES;
            }
        }
    }];
    
    return returnServiceImp;
}
@end
