//
//  Connector_A.m
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/13.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

//每个业务的组件的connector依赖Busmediator部分
#import "Connector_A.h"
#import "ZXBusMediator.h"

//每个业务组件依赖它对外开放的协议文件
#import "ModuleAServicePrt.h"

//connetor依赖业务组件具体实现
#import "DemoModuleAViewController.h"
#import "ModuleAItemPrt.h"
#import "ModuleAItem.h"

/**
 *说明：对外开放的服务协议可以不在connector中实现，可以放到其他具体的服务实现类中，只需要在连接的时候根据协议名称返回服务实现类的实例即可；
 */
@interface Connector_A() <ModuleAServicePrt>{
    
}
@end
@implementation Connector_A
/*
 *每个组件的实现必须自己通过load完美挂载;load只需要在挂载的connector的时候完成当前connector的初始化，挂载量，挂载消耗、挂载所消耗内存都在可控制范围内。
 *
 */
+(nonnull Connector_A *)sharedConnector{
    static Connector_A *_sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnector = [[Connector_A alloc] init];
    });
    return _sharedConnector;
}
+(void)load{
    @autoreleasepool{
        [ZXBusMediator registerConnector:[self sharedConnector]];
    }
}

#pragma mark --LDBusConnectorPrt
/**
 *(1)当调用方需要通过判断URL是否可导航显示界面的时候，告诉调用方该组件实现是否可导航，可导航，返回YES，否则返回NO；
 *(2)这个方法跟connectorToOpenURL：params配套实现，如果不实现，则调用方法无法判断某个URL是否可导航；
 */
-(BOOL)canOpenURL:(NSURL *)URL{
    if ([URL.host isEqualToString:@"ADetail"]) {
        return YES;
    }
    return NO;
}

/**
 (1)通过connector向busMeditor挂载可导航的URL，具体解析URL的host还是path，由connector自行决定；
 （2）如果URL在本业务组件可导航，则从params获取参数，实例化对应的viewcontroller进行返回；如果参数错误，则返回一个错误提示的【UIVIEWCONTROLLER paramsError];
 R如果不需要中间进行present展示，则返回一个【UIViewcontroller notURLController],表示当前可处理；如果无法处理，返回nil，交由其他组件处理；
 （3）需要在connector中对参数进行验证，不同的参数调用生成不同的ViewController实例；也可以通过参数决定是否自行展示，如果自行展示，则用户的展示方式无效；
 （4）如果挂载的url较多，这里的代码比较长，可以将处理方式分发到当前connector的category中；
 */
- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params{
    //处理scheme：//ADtail的方式
    //tip:url较少的时候可以通过if-else 去处理；如果url较多，可以自己维护一个url和ViewController的map，加快遍历查找，生成viewController
    if ([URL.host isEqualToString:@"ADetail"]) {
        DemoModuleAViewController *viewController = [[DemoModuleAViewController alloc] init];
        if (params[@"key"] !=nil) {
             viewController.valueLabel.text = params[@"key"];
        }else if (params[@"image"]){
            id imageObj = params[@"image"];
            if (imageObj && [imageObj isKindOfClass:[UIImage class]]) {
                viewController.valueLabel.text = @"this is image";
                viewController.imageView.image = params[@"image"];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
                return [UIViewController notURLController];
            }else{
                viewController.valueLabel.text = @"no image";
                viewController.imageView.image = [UIImage imageNamed:@"noImage"];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
                return [UIViewController notURLController];
            }
        }else{
            //nothing to do
        }
        return viewController;
    }else{
        //
    }
    return nil;
}

/**
 (1)通过connector向BusMediator挂载可处理的Protocol，根据Protocol获取当前组件中可处理protocol的服务实例
（2）具体服务协议的实现可放到其他类实现文件中，只需要在当前connector中引用，返回一个服务实例即可
（3）如果不能处理，返回一个nil
 */
-(nullable id)connectToHandleProtocol:(nonnull Protocol *)servicePrt{
    if (servicePrt == @protocol(ModuleAServicePrt)) {
        return [[self class] sharedConnector];
    }
    return nil;
}

#pragma mark - ModuleAServicePrt
/**
 * 下面三个接口都是组件A向外提供服务的协议实现，当前的服务接口都是同步的，如果是异步回调要注意在服务显示中对多线程进行兼容处理（主要是Block的对应）；
 */

-(void)moduleA_showAlertWithMessage:(NSString *)message cancelAction:(void (^)(NSDictionary * _Nonnull))cancelAction confirmAction:(void (^)(NSDictionary * _Nonnull))confirmAction{
    
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction(@{@"alertAction":action});
        }
    }];
    
    UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmAction) {
            confirmAction(@{@"alertAction":action});
        }
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module A" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAlertAction];
    [alertController addAction:confirmAlertAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(nonnull id<ModuleAItemPrt>)moduleA_getItemWithName:(NSString *)name age:(int)age{
    ModuleAItem *item= [[ModuleAItem alloc] initWithItemName:name itemAge:age];
    return item;
}

-(void)moduleA_deliveAprotocolModel:(nonnull id<ModuleAItemPrt>)item{
    NSString *showText =[item description];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Module A展示外部传入" message:showText preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAlertAction];
    [alertController addAction:confirmAlertAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
