//
//  UIView+JKFirstResponder.h
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JKFirstResponder)


/**    遍历第一响应者    */
- (UIView *)jk_findFirstResponder;

/**    相对window的frame    */
- (CGRect)jk_relativeFrame;

+ (UIButton *)buttonWithBounds:(CGRect)bounds image:(UIImage *)image target:(id)target action:(SEL)action;

@end
