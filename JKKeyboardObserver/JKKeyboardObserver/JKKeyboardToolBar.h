//
//  JKKeyboardToolBar.h
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 17/1/12.
//  Copyright © 2017年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKKeyboardToolBar : UIToolbar
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
              leftArrowAction:(SEL)leftArrowAction
             rightArrowAction:(SEL)rightArrowAction
                   doneAction:(SEL)doneAction;

@property (nonatomic, strong) UIButton * leftArrowButton;
@property (nonatomic, strong) UIButton * rightArrowButton;
@property (nonatomic, strong) UIButton * doneButton;


@end
