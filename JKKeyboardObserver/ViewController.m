//
//  ViewController.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/3/14.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate+JKKeyboardObserver.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    [[AppDelegate appDelegate]keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
        // do something
        
    } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
        // do something
        
    }];
}



@end
