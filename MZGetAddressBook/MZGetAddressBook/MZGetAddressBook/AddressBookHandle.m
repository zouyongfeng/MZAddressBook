//
//  DataHandle.m
//  zyf
//
//  Created by zyf on 16/12/28.
//  Copyright © 2016年 zyf. All rights reserved.
//

#import "AddressBookHandle.h"


@interface AddressBookHandle ()

#ifdef __IPHONE_9_0
/** iOS9之后的通讯录对象*/
@property (nonatomic, strong) CNContactStore *contactStore;
#endif

@end

@implementation AddressBookHandle

MZSingletonM(AddressBookHandle)

- (void)requestAuthorizationWithSuccessBlock:(void (^)(void))success failureBlock:(void(^)(void))failure
{
    if(IOS9_LATER)
    {
#ifdef __IPHONE_9_0
        // 1.判断是否授权成功,若授权成功直接return
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined){
        // 2.创建通讯录
        //CNContactStore *store = [[CNContactStore alloc] init];
        // 3.授权
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"授权成功");
                    success();
                }else{
                    NSLog(@"授权失败");
                    failure();
                }
            }];
        } else {
            if (status == CNAuthorizationStatusAuthorized) {
                success();
            } else {
                failure();
            }
        }
#endif
    }
    else
    {
        // 1.获取授权的状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // 2.判断授权状态,如果是未决定状态,才需要请求
        if (status == kABAuthorizationStatusNotDetermined) {
            // 3.创建通讯录进行授权
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"授权成功");
                    success();
                } else {
                    NSLog(@"授权失败");
                    failure();
                }
                
            });
        } else {
            if (status == kABAuthorizationStatusAuthorized) {
                success();
            } else {
                failure();
            }
        }
        
    }
    
}

- (BOOL)isAuthorization;
{
    if (IOS9_LATER) {
        //获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果没有授权,先执行授权失败的block后return
        if (status == CNAuthorizationStatusAuthorized) {
            return YES;
        } else {
            return NO;
        }
    } else {
        //获取授权状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        //如果没有授权,先执行授权失败的block后return
        if (status == kABAuthorizationStatusAuthorized/** 已经授权*/) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)requestAuthorizationStatus;
{
    if (IOS9_LATER) {
        //获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果没有授权,先执行授权失败的block后return
        if (status == CNAuthorizationStatusAuthorized) {
            return YES;
        } else if (status == CNAuthorizationStatusNotDetermined) {
            [self requestAuthorizationWithSuccessBlock:^{
            } failureBlock:^{
            }];
            return NO;
        } else {
            return NO;
        }
    } else {
        //获取授权状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        //如果没有授权,先执行授权失败的block后return
        if (status == kABAuthorizationStatusAuthorized/** 已经授权*/) {
            return YES;
        } else if (status == kABAuthorizationStatusNotDetermined) {
            [self requestAuthorizationWithSuccessBlock:^{
            } failureBlock:^{
            }];
            return NO;
        } else {
            return NO;
        }
    }
}

- (AddressBookStatus)status {
    if (IOS9_LATER) {
        //获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            [self requestAuthorizationWithSuccessBlock:^{
            } failureBlock:^{
                
            }];
        }
        return (NSUInteger)status;
    } else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        //获取授权状态
        if (status == kABAuthorizationStatusNotDetermined) {
            [self requestAuthorizationWithSuccessBlock:^{
            } failureBlock:^{
                
            }];
        }
        return (NSUInteger)status;
    }
}

- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
    
    if(IOS9_LATER)
    {
        [self getDataSourceFrom_IOS9_Later:personModel authorizationFailure:failure];
    }
    else
    {
        [self getDataSourceFrom_IOS9_Ago:personModel authorizationFailure:failure];
    }
    
}

#pragma mark - IOS9之前获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Ago:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
    //获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    //如果没有授权,先执行授权失败的block后return
    if (status != kABAuthorizationStatusAuthorized/** 已经授权*/)
    {
        failure ? failure() : nil;
        return;
    }
    
    //创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //按照排序规则从通信录对象中请求所有的联系人,并按姓名属性中的姓(LastName)来排序
    ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByLastName);
    
    //遍历每个联系人的信息,并装入模型
    for(id personInfo in (__bridge NSArray *)allPeopleArray)
    {
        PersonModel *model = [PersonModel new];
        
        // 获取到联系人
        ABRecordRef person = (__bridge ABRecordRef)(personInfo);
        
        // 获取全名
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        model.name = name.length > 0 ? name : @"" ;
        
        // 获取头像数据
        NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        model.headerImage = [UIImage imageWithData:imageData];
        
        // 获取每个人所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < phoneCount; i++)
        {
            // 号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *mobile = [self removeSpecialSubString:phoneValue];
            
            [model.mobileArray addObject: mobile ? mobile : @"空号"];
            
        }
        model.mobile = model.mobileArray.firstObject;
        // 将联系人模型回调出去
        personModel ? personModel(model) : nil;
        
        CFRelease(phones);
    }
    
    // 释放不再使用的对象
    CFRelease(allPeopleArray);
    CFRelease(recordRef);
    CFRelease(addressBook);
    
}

#pragma mark - IOS9之后获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Later:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
#ifdef __IPHONE_9_0
    //获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    //如果没有授权,先执行授权失败的block后return
    if (status != CNAuthorizationStatusAuthorized)
    {
        failure ? failure() : nil;
        return;
    }
    //获取联系人
    //创建联系人仓库
    //CNContactStore *store = [[CNContactStore alloc] init];
    
    //创建联系人的请求对象
    //决定能获取联系人哪些信息,例:姓名,电话,头像等
    NSArray *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    //请求联系人
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact,BOOL * _Nonnull stop) {
        
        //获取联系人全名
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        
        //创建联系人模型
        PersonModel *model = [PersonModel new];
        model.name = name.length > 0 ? name : @"" ;
        
        // 联系人头像
        model.headerImage = [UIImage imageWithData:contact.thumbnailImageData];
        
        // 获取一个人的所有电话号码
        NSArray *phones = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phones)
        {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *mobile = [self removeSpecialSubString:phoneNumber.stringValue];
            [model.mobileArray addObject: mobile ? mobile : @"空号"];
        }
        model.mobile = model.mobileArray.firstObject;
        
        //将联系人模型回调出去
        personModel ? personModel(model) : nil;
    }];
#endif
    
}

//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark - lazy

#ifdef __IPHONE_9_0
- (CNContactStore *)contactStore
{
    if(!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}
#endif

@end
