//
//  ModuleAItem.m
//  ZXRoute
//
//  Created by 以贝科技小熊 on 2017/12/14.
//  Copyright © 2017年 以贝科技小熊. All rights reserved.
//

#import "ModuleAItem.h"

@implementation ModuleAItem
@synthesize itemName = _itemName;
@synthesize itemAge = _itemAge;


-(nonnull instancetype)initWithItemName:(nonnull NSString *)itemName
                                itemAge:(int)itemAge{
    self = [self init];
    if (self) {
        self.itemName = itemName;
        self.itemAge = itemAge;
    }
    return self;
}


-(nonnull NSString *)description{
    NSString *description = [NSString stringWithFormat:@"MduleA:itemName==%@,itemAge==%d", self.itemName, self.itemAge];
    return description;
}

@end
