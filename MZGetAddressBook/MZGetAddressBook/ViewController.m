//
//  ViewController.m
//  MZGetAddressBook
//
//  Created by 邹勇峰 on 2017/10/24.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "ViewController.h"
#import "GetAddressBook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [kAddressBookHandle requestAuthorizationWithSuccessBlock:^{
        [GetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
            
            NSLog(@"--%@",nameKeys);
            
        } authorizationFailure:^{
            
        }];
        
    } failureBlock:^{
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
