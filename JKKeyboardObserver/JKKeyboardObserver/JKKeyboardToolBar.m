//
//  JKKeyboardToolBar.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 17/1/12.
//  Copyright © 2017年 蒋鹏. All rights reserved.
//

#import "JKKeyboardToolBar.h"
#import "UIView+JKFirstResponder.h"

@implementation JKKeyboardToolBar

- (UIButton *)buttonWithBounds:(CGRect)bounds image:(UIImage *)image target:(id)target action:(SEL)action{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = bounds;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}


- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
              leftArrowAction:(SEL)leftArrowAction
             rightArrowAction:(SEL)rightArrowAction
                   doneAction:(SEL)doneAction {
    
    if (self = [super initWithFrame:frame]) {
        CGFloat arrowWidthHeight = 21.0;
        
        UIImage * leftArrowImage = [[UIImage imageNamed:@"jk_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        CGFloat scale = leftArrowImage.size.width / leftArrowImage.size.height;
        self.leftArrowButton = [self buttonWithBounds:CGRectMake(0, 0, scale*arrowWidthHeight, arrowWidthHeight)
                                                    image:leftArrowImage
                                                   target:target
                                                   action:leftArrowAction];
        UIBarButtonItem * leftArrow = [[UIBarButtonItem alloc]initWithCustomView:self.leftArrowButton];
        
        UIBarButtonItem * fixedSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceItem.width = 20;
        
        UIImage * rightArrowImage = [[UIImage imageNamed:@"jk_arrow_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        scale = rightArrowImage.size.width / rightArrowImage.size.height;
        self.rightArrowButton = [self buttonWithBounds:CGRectMake(0, 0, scale*arrowWidthHeight, arrowWidthHeight)
                                                     image:rightArrowImage
                                                    target:target
                                                    action:rightArrowAction];
        UIBarButtonItem * rightArrow = [[UIBarButtonItem alloc]initWithCustomView:self.rightArrowButton];
        
        UIBarButtonItem * flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:target action:doneAction];
        
        [self setItems:@[leftArrow,fixedSpaceItem,rightArrow,flexibleSpaceItem,doneItem]];
        self.tintColor = [UIColor blackColor];
    }return self;
}


@end
