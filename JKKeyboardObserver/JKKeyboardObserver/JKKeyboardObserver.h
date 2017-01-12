//
//  JKKeyboardObserver.h
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef void(^KeyboardObserverBlock)(CGFloat keyboardHeight, CGFloat duration);
typedef void(^KeyboardObserverCompletionBlock)(void);

@interface JKKeyboardObserver : NSObject


/**
 *  开始监听
 */
- (void)startObserveKeyboard;




/**
 *  结束监听
 */
- (void)stopObserveKeyboard;


/**
 *  处理升起的Block方法，自带动画效果，无需再使用UIView的动画
 */
- (void)keyboardWillShow:(KeyboardObserverBlock)block;

- (void)keyboardWillShow:(KeyboardObserverBlock)block completion:(KeyboardObserverCompletionBlock)completion;



/**
 *  处理隐藏的Block方法，自带动画效果，无需再使用UIView的动画
 */
- (void)keyboardWillHide:(KeyboardObserverBlock)block;
- (void)keyboardWillHide:(KeyboardObserverBlock)block completion:(KeyboardObserverCompletionBlock)completion;


/**
 结束监听，释放Block强引用的资源
 */
- (void)relieveBlockStrongReference;

@end
