
//
//  MZSingleton.h
//  zyf
//
//  Created by zyf on 16/12/28.
//  Copyright © 2016年 zyf. All rights reserved.
//


#ifndef MZSingleton_h
#define MZSingleton_h

// .h文件
#define MZSingletonH(name) + (instancetype)shared##name;

// .m文件
#define MZSingletonM(name) \
static id _instance; \
 \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
 \
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}

#endif /* MZSingleton_h */
