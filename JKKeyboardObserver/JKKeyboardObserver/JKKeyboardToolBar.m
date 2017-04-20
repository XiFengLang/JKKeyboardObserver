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
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

- (UIImage *)redrawIcon:(UIImage *)icon contextSize:(CGSize)size iconSize:(CGSize)iconSize {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect iconFrame = CGRectMake((size.width - iconSize.width) / 2.0,
                                  (size.height - iconSize.height) / 2.0,
                                  iconSize.width, iconSize.height);
    
    [icon drawInRect:iconFrame];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
              leftArrowAction:(SEL)leftArrowAction
             rightArrowAction:(SEL)rightArrowAction
                   doneAction:(SEL)doneAction {
    
    /// height: 40px
    if (self = [super initWithFrame:frame]) {
        CGFloat arrowWidthHeight = 21.0;
        
        UIImage * icon = [UIImage imageNamed:@"jk_arrow_left"];
        CGFloat scale = icon.size.width / icon.size.height;
        UIImage * image = [self redrawIcon:icon contextSize:CGSizeMake(35, 35)
                                  iconSize:CGSizeMake(scale*arrowWidthHeight, arrowWidthHeight)];
        UIImage * leftArrowImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.leftArrowButton = [self buttonWithBounds:CGRectMake(0, 0, 35, 35)
                                                image:leftArrowImage
                                               target:target
                                               action:leftArrowAction];
        UIBarButtonItem * leftArrow = [[UIBarButtonItem alloc]initWithCustomView:self.leftArrowButton];
        
        
        icon = [UIImage imageNamed:@"jk_arrow_right"];
        scale = icon.size.width / icon.size.height;
        image = [self redrawIcon:icon contextSize:CGSizeMake(35, 35)
                        iconSize:CGSizeMake(scale*arrowWidthHeight, arrowWidthHeight)];
        UIImage * rightArrowImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.rightArrowButton = [self buttonWithBounds:CGRectMake(0, 0, 35, 35)
                                                 image:rightArrowImage
                                                target:target
                                                action:rightArrowAction];
        UIBarButtonItem * rightArrow = [[UIBarButtonItem alloc]initWithCustomView:self.rightArrowButton];
        
        UIBarButtonItem * flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:target action:doneAction];
        doneItem.tintColor = [UIColor blackColor];
        
        [self setItems:@[leftArrow,rightArrow,flexibleSpaceItem,doneItem]];
        self.tintColor = [UIColor blackColor];
    }return self;
}


@end
