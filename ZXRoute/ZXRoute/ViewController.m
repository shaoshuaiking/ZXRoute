//
//  ViewController.m
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/13.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import "ViewController.h"
#import "ZXBusMediator.h"
#import "ModuleAServicePrt.h"
#import "ModuleAItemPrt.h"
@interface ViewController ()
@property(nonatomic,copy) NSString *schemeStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    _schemeStr = @"productScheme://ADetail";
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1
    [ZXBusMediator routeURL:[NSURL URLWithString:@"productScheme://ADetail"] withParameters:@{ZXRouteModeKey:@(NavigationModePush)}];
    
    //2
//    [[ZXBusNavigator navigator] setHookRouteBlock:^BOOL(UIViewController * _Nonnull controller, UIViewController * _Nullable baseViewController, NavigationMode routeMode) {
//        NSLog(@"%@",controller.class);
//        NSLog(@"%@",baseViewController.class);
//        return NO;
//        //NSLog(@"%@",routeMode);
//    }];
//    if ([ZXBusMediator canRouteURL:[NSURL URLWithString:self.schemeStr]]) {
//        [ZXBusMediator routeURL:[NSURL URLWithString:self.schemeStr]];
//    }
    
    //3
//    [ZXBusMediator routeURL:[NSURL URLWithString:@"productScheme://ADetail"] withParameters:@{@"image":[UIImage imageNamed:@"image"]}];
//     [ZXBusMediator routeURL:[NSURL URLWithString:@"productScheme://ADetail"] withParameters:@{@"image":@""}];
    
    //4
//    [[ZXBusMediator serviceForProtocol:@protocol(ModuleAServicePrt)] moduleA_showAlertWithMessage:@"casa" cancelAction:nil confirmAction:^(NSDictionary *info) {
//        NSLog(@"%@", info);
//    }];
    
//    id<ModuleAItemPrt> item = [[ZXBusMediator serviceForProtocol:@protocol(ModuleAServicePrt)] moduleA_getItemWithName:@"philonpang" age:30];
//    [[ZXBusMediator serviceForProtocol:@protocol(ModuleAServicePrt)] moduleA_showAlertWithMessage:[item description] cancelAction:nil confirmAction:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
