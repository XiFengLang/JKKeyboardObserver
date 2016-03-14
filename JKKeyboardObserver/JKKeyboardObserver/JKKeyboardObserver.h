//
//  JKKeyboardObserver.h
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIKeyboardInputMode.h"

typedef void(^KeyboardObserverBlock)(CGFloat keyboardHeight, CGFloat duration);


@interface JKKeyboardObserver : NSObject


/**
 *  处理升起的Block方法，自带动画效果，无需再使用UIView的动画
 */
- (void)keyboardWillShow:(KeyboardObserverBlock)block;


/**
 *  处理隐藏的Block方法，自带动画效果，无需再使用UIView的动画
 */
- (void)keyboardWillHide:(KeyboardObserverBlock)block;

@end
