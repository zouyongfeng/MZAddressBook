//
//  AddressModel.h
//  zyf
//
//  Created by zyf on 16/12/28.
//  Copyright © 2016年 zyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersonModel : NSObject

/** 联系人姓名*/
@property (nonatomic, copy) NSString *name;
/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobileArray;
/** 存的第一个手机号*/
@property (nonatomic, strong) NSString *mobile;
/** 联系人头像*/
@property (nonatomic, strong) UIImage *headerImage;

@property (nonatomic, strong) NSArray *pinyingArray;

@property (nonatomic, strong) NSString *pinyingString;

@property (nonatomic, assign) BOOL selected;

@end
