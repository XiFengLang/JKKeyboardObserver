//
//  UIControl+JKSecurityExtension.h
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/27.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

// 默认的点击间隔
static NSTimeInterval const kMaximumClickInterval = 0.75;

@interface UIControl (JKSecurityExtension)
@property (nonatomic, assign)NSTimeInterval lastClickTime;
/**    可自定义    */
@property (nonatomic, assign)NSTimeInterval maximumClickInterval;



@end
