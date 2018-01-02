//
//  UIViewController+NavigationTip.m
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/25.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import "UIViewController+NavigationTip.h"
#import "ZXBusMediatorTipViewController.h"
@implementation UIViewController (NavigationTip)
+(nonnull UIViewController *)paramsError{
    return [ZXBusMediatorTipViewController paramsErrorTipController];
}

+(nonnull UIViewController *)notFound{
    return [ZXBusMediatorTipViewController notFoundTipController];
}

+(nonnull UIViewController *) notURLController{
    return [ZXBusMediatorTipViewController notURLTipController];
}
@end
