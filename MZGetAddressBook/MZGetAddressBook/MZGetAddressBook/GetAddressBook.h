//
//  GetAddressBook.h
//  zyf
//
//  Created by zyf on 16/12/28.
//  Copyright © 2016年 zyf. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AddressBookHandle.h"
#import "PersonModel.h"

#define kAddressBookHandle [AddressBookHandle sharedAddressBookHandle]

/**
 *  获取原始顺序的所有联系人的Block
 */
typedef void(^AddressBookArrayBlock)(NSArray<PersonModel *> *addressBookArray);

/**
 *  获取按A~Z顺序排列的所有联系人的Block
 *
 *  @param addressBookDict 装有所有联系人的字典->每个字典key对应装有多个联系人模型的数组->每个模型里面包含着用户的相关信息.
 *  @param peopleNameKey   联系人姓名的大写首字母的数组
 */
typedef void(^AddressBookDictBlock)(NSDictionary<NSString *,NSArray *> *addressBookDict,NSArray *nameKeys);



@interface GetAddressBook : NSObject

/**
 *  请求用户是否授权APP访问通讯录的权限
 */
+ (void)requestAddressBookAuthorization;

/**
 *  获取原始顺序排列的所有联系人
 *
 *  @param addressBookArray 装着原始顺序的联系人字典Block回调
 */
+ (void)getOriginalAddressBook:(AddressBookArrayBlock)addressBookArray authorizationFailure:(AuthorizationFailure)failure;

/**
 *  获取按A~Z顺序排列的所有联系人
 *
 *  @param addressBookInfo 装着A~Z排序的联系人字典Block回调
 *  @param failure         授权失败的Block
 */
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo authorizationFailure:(AuthorizationFailure)failure;


@end
