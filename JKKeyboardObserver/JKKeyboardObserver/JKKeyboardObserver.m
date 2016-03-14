
//  JKKeyboardObserver.m
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import "JKKeyboardObserver.h"

@interface JKKeyboardObserver ()
@property (nonatomic,copy)KeyboardObserverBlock showBlock;
@property (nonatomic,copy)KeyboardObserverBlock hideBlock;
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
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];
    
    
    UIKeyboardInputModeController *key = [UIKeyboardInputModeController sharedInputModeController];
    
    //当前输入法
    UIKeyboardInputMode *currentInputMode = [key currentInputMode];
    
    //第三方扩展输入法
    NSArray *extensionInputModes = [key extensionInputModes];
    
    
    if ([extensionInputModes containsObject:currentInputMode]) {
        //NSLog(@"current input mode (%@) is the 3rd party input mode", currentInputMode.identifier);
//        if (time == 0.0) {
//            time = 0.25;
//        }
        time = 0.0;
    } else {
        //NSLog(@"current input mode (%@) is build-in input mode", currentInputMode.identifier);
    }
    
    
    
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.showBlock) {
            self.showBlock(keyboardSize.height,time);
        }
    } completion:nil];
}

- (void)keyboardWillHideWithNotification:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.hideBlock) {
            self.hideBlock(0,time);
        }
    } completion:nil];
    
}


- (void)keyboardWillShow:(KeyboardObserverBlock)block{
    _showBlock = block;
}

- (void)keyboardWillHide:(KeyboardObserverBlock)block{
    _hideBlock = block;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    _showBlock = nil;
    _hideBlock = nil;
}


@end
