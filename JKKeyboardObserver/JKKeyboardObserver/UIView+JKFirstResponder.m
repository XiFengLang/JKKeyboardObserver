//
//  UIView+JKFirstResponder.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "UIView+JKFirstResponder.h"
#import "JKKeyboardManager.h"

@implementation UIView (JKFirstResponder)

- (UIView *)jk_findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView * subView in self.subviews) {
        UIView * firstResponder = [subView jk_findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

- (CGRect)jk_relativeFrame{
    return [self.superview convertRect:self.frame toView:[JKKeyboardManager sharedKeyboardManager].keyWindow];
}


+ (UIButton *)buttonWithBounds:(CGRect)bounds image:(UIImage *)image target:(id)target action:(SEL)action{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = bounds;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}



@end
