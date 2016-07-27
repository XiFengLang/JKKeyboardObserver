//
//  ViewController.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/3/14.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
#import "JKKeyboardManager.h"
#import "UIControl+JKSecurityExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JKKeyboardManager sharedKeyboardManager].robotizationEnable = YES;
    [JKKeyboardManager sharedKeyboardManager].topSpacingToFirstResponder = 20;
    [[JKKeyboardManager sharedKeyboardManager]setTopSpacingToFirstResponder:40 forViewControllerClass:self.class];
    [JKKeyboardManager sharedKeyboardManager].showExtensionToolBar = YES;

}

- (IBAction)button:(id)sender {
    NSLog(@"button 被点击");
}




@end
