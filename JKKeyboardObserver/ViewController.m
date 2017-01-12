//
//  ViewController.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/3/14.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
#import "JKKeyboardManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
    
    
    if (self.navigationController.viewControllers.count == 1) {
        KeyboardManager().robotizationEnable = YES;
        KeyboardManager().topSpacingToFirstResponder = 20;
        KeyboardManager().showExtensionToolBar = YES;
    }
    

    
    
//    [KeyboardManager() setTopSpacingToFirstResponder:20 forViewControllerClass:self.class];
}

- (IBAction)button:(UIButton *)button {
    NSLog(@"button 被点击");
    [[JKKeyboardManager sharedKeyboardManager] hideKeyBoard];
}


- (void)push {
    ViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    KeyboardManager().robotizationEnable = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
}


- (void)dealloc {
    NSLog(@"%@已释放",[self class]);
}

@end
