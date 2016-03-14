//
//  AppDelegate+JKKeyboardObserver.h
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 iMac1. All rights reserved.
//
//  专用于监听键盘升起、隐藏事件的分类



/****************************************【用法】****************************************
导入#import "AppDelegate+JKKeyboardObserver.h" 
 
 用法1.App全局监听
 
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self startObserveKeyboard];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopObserveKeyboard];
}

 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 
 [[AppDelegate appDelegate]keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 }];
 }
 
 
 
 
 用法2.控制器局部监听

 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 
 // 步骤1.开始监听,开始后才能 初始化键盘监听者
 [[AppDelegate appDelegate]startObserveKeyboard];
 
 // 步骤2.处理事件，步骤1写在appdelegate后步骤2可全局使用
 [[AppDelegate appDelegate]keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 }];
 }
 
 
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 
 // 步骤3.结束监听,有开始就必须有结束，避免内存泄露
 [[AppDelegate appDelegate]stopObserveKeyboard];
 
 }



 
**************************************【用法,复制上面代码】**************************************
*/


#import "AppDelegate.h"
#import "JKKeyboardObserver.h"


@interface AppDelegate (JKKeyboardObserver)
//@property (nonatomic, strong)JKKeyboardObserver * keyboardObserver;


/**
 *  返回appdelegate的快速方法
 */
+ (AppDelegate *)appDelegate;


/**
 *  开始监听,建议在viewWillAppear调用
 */
- (void)startObserveKeyboard;



/**
 *  监听键盘的显示和隐藏，Block自带动画效果，
 *
 *  @param willShowBlock 显示，第三方输入法时动画时间为0
 *  @param willHideBlock 隐藏
 */
- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock keyboardWillHide:(KeyboardObserverBlock)willHideBlock;




/**
 *  结束监听，建议在viewWillDisappear调用
 */
- (void)stopObserveKeyboard;

@end
