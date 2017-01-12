//
//  UIView+JKFirstResponder.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "UIView+JKFirstResponder.h"
#import "JKKeyboardManager.h"

static NSString * const kAlertSheetTextFieldClass = @"UIAlertSheetTextField";
static NSString * const kAlertControllerTextFieldClass = @"_UIAlertControllerTextField";
static NSString * const kSearchBarTextFieldClass = @"UISearchBarTextField";

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

- (BOOL)jk_isEffectiveFirstResponderClass {
    return !([self isKindOfClass:NSClassFromString(kSearchBarTextFieldClass)] || [self isKindOfClass:[UISearchBar class]] || [self isKindOfClass:NSClassFromString(kAlertControllerTextFieldClass)] || [self isKindOfClass:NSClassFromString(kAlertSheetTextFieldClass)]);
}


- (BOOL)jk_canBecameFirstResponder {
    BOOL enable = ([self canBecomeFocused] && self.userInteractionEnabled && !self.isHidden && self.alpha > 0.01 && [self jk_isEffectiveFirstResponderClass]);
    
    if (enable) {
        if ([self isKindOfClass:[UITextView class]]) {
            enable = [(UITextView *)self isEditable];
        } else if ([self isKindOfClass:[UITextField class]]) {
            enable = [(UITextField *)self isEnabled];
        }
    }
    return enable;
}

- (NSArray *)jk_traverseResponderViews {
    @autoreleasepool {
        NSMutableArray * mutArray = [[NSMutableArray alloc] init];
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj jk_canBecameFirstResponder]) {
                [mutArray addObject:obj];
            }
            
            
            if (obj.subviews.count && obj.isUserInteractionEnabled && !obj.isHidden && obj.alpha > 0.01) {
                [mutArray addObjectsFromArray:[obj jk_traverseResponderViews]];
            }
        }];
        
        
        return [mutArray sortedArrayUsingComparator:^NSComparisonResult(UIView *  _Nonnull view1, UIView *  _Nonnull view2) {
            CGRect frame1 = [view1 convertRect:view1.bounds toView:self];
            CGRect frame2 = [view2 convertRect:view2.bounds toView:self];
            
            CGFloat x1 = CGRectGetMinX(frame1);
            CGFloat y1 = CGRectGetMinY(frame1);
            CGFloat x2 = CGRectGetMinX(frame2);
            CGFloat y2 = CGRectGetMinY(frame2);
            
            if (y1 < y2)  return NSOrderedAscending;
            else if (y1 > y2) return NSOrderedDescending;
            else if (x1 < x2)  return NSOrderedAscending;
            else if (x1 > x2) return NSOrderedDescending;
            else    return NSOrderedSame;
        }];
    }
}


@end
