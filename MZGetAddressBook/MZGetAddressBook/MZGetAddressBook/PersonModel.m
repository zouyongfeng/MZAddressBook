//
//  AddressModel.m
//  米庄理财
//
//  Created by aicai on 16/12/28.
//  Copyright © 2016年 aicai. All rights reserved.
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
