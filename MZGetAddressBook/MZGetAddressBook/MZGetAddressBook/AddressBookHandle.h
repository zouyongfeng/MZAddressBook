//
//  DataHandle.h
//  米庄理财
//
//  Created by aicai on 16/12/28.
//  Copyright © 2016年 aicai. All rights reserved.
//


#import <Foundation/Foundation.h>

#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>

#import "PersonModel.h"
#import "MZSingleton.h"

#define IOS9_LATER ([[UIDevice currentDevice] systemVersion].floatValue > 9.0 ? YES : NO )

/** 一个联系人的相关信息*/
typedef void(^PPPersonModelBlock)(PersonModel *model);
/** 授权失败的Block*/
typedef void(^AuthorizationFailure)(void);

typedef enum : NSUInteger {
    AddressBookStatusNotDetermined = 0,
    AddressBookStatusRestricted,
    AddressBookStatusDenied,
    AddressBookStatusAuthorized
} AddressBookStatus;

@interface AddressBookHandle : NSObject

MZSingletonH(AddressBookHandle)

@property (nonatomic, assign) AddressBookStatus status;
/**
 请求用户通讯录授权

 @param success 授权成功的回调
 */
- (void)requestAuthorizationWithSuccessBlock:(void (^)(void))success failureBlock:(void(^)(void))failure;

- (BOOL)isAuthorization;

- (BOOL)requestAuthorizationStatus;

/**
 *  返回每个联系人的模型
 *
 *  @param personModel 单个联系人模型
 *  @param failure     授权失败的Block
 */
- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure;

@end
