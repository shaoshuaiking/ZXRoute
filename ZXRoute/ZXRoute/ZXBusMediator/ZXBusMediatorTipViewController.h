//
//  ZXBusMediatorTipViewController.h
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/25.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXBusMediatorTipViewController : UIViewController
@property (nonatomic,readonly) BOOL isparamsError;
@property (nonatomic,readonly) BOOL isNotURLSupport;
@property (nonatomic,readonly) BOOL isNotFound;
+(nonnull UIViewController *)paramsErrorTipController;
+(nonnull UIViewController *)notURLTipController;
+(nonnull UIViewController *)notFoundTipController;
-(void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters;
@end
