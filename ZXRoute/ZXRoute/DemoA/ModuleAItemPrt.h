//
//  ModuleAItem.h
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/13.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

/*
 ModuleA对外开放的Item，将数据向外传递，或者将数据通过参数传入调用服务
 */
@protocol ModuleAItemPrt<NSObject>
@required
@property(nonatomic, readwrite) NSString *__nonnull itemName;
@property(nonatomic, readwrite) int itemAge;

-(nonnull NSString *)description;
@optional
-(nonnull instancetype)initWithItemName:(nonnull NSString *)itemName itemAge:(int)itemAge;

@end
