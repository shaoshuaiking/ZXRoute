//
//  UIViewController+NavigationTip.h
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/25.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @category NavigationTip
 *中间件导航的错误提示
 */

@interface UIViewController (NavigationTip)
/**
 *URl可导航，参数错误无法生成ViewController
 */
+(nonnull UIViewController *)paramsError;
/**
 *URL可导航，但是提供者并没有对URL返回一个ViewController
 */
+(nonnull UIViewController *)notURLController;
/**
 *URL不可导航，提示用户无法通过ZXBusMediator导航
 */
+(nonnull UIViewController *)notFound;

@end

