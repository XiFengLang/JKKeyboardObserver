//
//  JKKeyboardManager.h
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//





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


#import "JKKeyboardObserver.h"
#import <Foundation/Foundation.h>
#import "UIView+JKFirstResponder.h"

@interface JKKeyboardManager : NSObject

/**    监听者    */
@property (nonatomic, strong, readonly)JKKeyboardObserver * keyboardObserver;

/**    取当前最上层的UIViewController    */
@property (nonatomic, strong, readonly)UIViewController * currentViewController;

/**    取keywindow    */
@property (nonatomic, strong, readonly)UIWindow * keyWindow;

/**    键盘高度    */
@property (nonatomic, assign, readonly)CGFloat keyboardHeight;

/**    若有遮挡，自动上移textField/textView,无需调用【方法01/02】    */
@property (nonatomic, assign)BOOL robotizationEnable;

/**    键盘和输入框的距离    */
@property (nonatomic, assign)CGFloat topSpacingToFirstResponder;

/**    显示工具条    */
@property (nonatomic, assign)BOOL showExtensionToolBar;

+ (instancetype)sharedKeyboardManager;


/**
 *  隐藏键盘
 */
- (void)hideKeyBoard;


/**
 *  开始监听
 */
- (void)startObserveKeyboard;


/**    设置特定类的topSpacingToFirstResponder    */
- (void)setTopSpacingToFirstResponder:(CGFloat)distance forViewControllerClass:(Class)ViewControllerClass;



/**
 *  【方法01】监听键盘的显示和隐藏，Block自带动画效果，
 *
 *  @param willShowBlock 显示
 *  @param willHideBlock 隐藏
 */
- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock keyboardWillHide:(KeyboardObserverBlock)willHideBlock;


/**
 *  【方法02】
 */

- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock showAnimationCompletion:(KeyboardObserverCompletionBlock)showCompletion keyboardWillHide:(KeyboardObserverBlock)willHideBlock hideAnimationCompletion:(KeyboardObserverCompletionBlock)hideCompletion;


/**
 *  结束监听
 */
- (void)stopObserveKeyboard;
@end
