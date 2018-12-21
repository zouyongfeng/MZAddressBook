//
//  AddressModel.m
//  zyf
//
//  Created by zyf on 16/12/28.
//  Copyright © 2016年 zyf. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (NSMutableArray *)mobileArray
{
    if(!_mobileArray)
    {
        _mobileArray = [NSMutableArray array];
    }
    return _mobileArray;
}

@end
