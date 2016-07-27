
//  JKKeyboardObserver.m
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import "JKKeyboardManager.h"

@interface JKKeyboardObserver ()
@property (nonatomic,copy)KeyboardObserverBlock showBlock;
@property (nonatomic,copy)KeyboardObserverBlock hideBlock;
@property (nonatomic,copy)KeyboardObserverCompletionBlock showCompletion;
@property (nonatomic,copy)KeyboardObserverCompletionBlock hideCompletion;
@end


@implementation JKKeyboardObserver

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideWithNotification:) name:UIKeyboardWillHideNotification object:nil];
    }return self;
}

- (void)keyboardWillShowWithNotification:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
//    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    CGFloat time = [duration floatValue];
    
    CGRect startFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //JKLog(@"duration    %@     start    %@      end      %@       size    %@",duration,NSStringFromCGRect(startFrame),NSStringFromCGRect(endFrame),NSStringFromCGSize(keyboardSize));
    
    if (startFrame.size.height > 0 && endFrame.size.height == keyboardSize.height) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.showBlock) {
                self.showBlock(keyboardSize.height,0.25);
            }
        } completion:^(BOOL finished) {
            //            if (finished) {
            if (self.showCompletion) {
                self.showCompletion();
            }
            //            }
        }];
    }
}

- (void)keyboardWillHideWithNotification:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.hideBlock) {
            self.hideBlock(0,time);
        }
    } completion:^(BOOL finished) {
        //        if (finished) {
        if (self.hideCompletion) {
            self.hideCompletion();
        }
        //        }
    }];
    
}


- (void)keyboardWillShow:(KeyboardObserverBlock)block{
    _showBlock = block;
}

- (void)keyboardWillHide:(KeyboardObserverBlock)block{
    _hideBlock = block;
}

- (void)keyboardWillShow:(KeyboardObserverBlock)block completion:(KeyboardObserverCompletionBlock)completion{
    _showBlock = block;
    _showCompletion = completion;
}

- (void)keyboardWillHide:(KeyboardObserverBlock)block completion:(KeyboardObserverCompletionBlock)completion{
    _hideBlock = block;
    _hideCompletion = completion;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _showBlock = nil;
    _hideBlock = nil;
    _showCompletion = nil;
    _hideCompletion = nil;
}


@end
