//
//  JKKeyboardManager.h
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//




#import "JKKeyboardObserver.h"
#import <Foundation/Foundation.h>
#import "UIView+JKFirstResponder.h"

@interface JKKeyboardManager : NSObject

#pragma mark - readwrite

/**    若有遮挡，自动上移textField/textView,无需调用【方法01/02】    */
@property (nonatomic, assign)BOOL robotizationEnable;

/**    键盘和输入框的距离    */
@property (nonatomic, assign)CGFloat topSpacingToFirstResponder;

/**    显示工具条    */
@property (nonatomic, assign, readwrite)BOOL showExtensionToolBar;




#pragma mark - readonly

/**    取当前最上层的UIViewController    */
@property (nonatomic, strong, readonly)UIViewController * currentViewController;

/**    取keywindow    */
@property (nonatomic, strong, readonly)UIWindow * keyWindow;

/**    键盘高度    */
@property (nonatomic, assign, readonly)CGFloat keyboardHeight;



+ (instancetype)sharedKeyboardManager;



/**
 设置特定控制器类的topSpacingToFirstResponder

 @param distance 键盘到第一响应者底部的距离
 @param ViewControllerClass 当前控制器类
 */
- (void)setTopSpacingToFirstResponder:(CGFloat)distance forViewControllerClass:(Class)ViewControllerClass;




/**
 结束监听，释放Block强引用的对象
 */
- (void)relieveBlockStrongReference;



/**
 *  隐藏键盘
 */
- (void)hideKeyBoard;
@end

static inline JKKeyboardManager * KeyboardManager() {
    return [JKKeyboardManager sharedKeyboardManager];
}
