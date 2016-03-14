//
//  AppDelegate+JKKeyboardOberver.m
//  UDP客户端new
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import "AppDelegate+JKKeyboardObserver.h"
#import <objc/runtime.h>

@implementation AppDelegate (KeyboardOberver)



- (void)setKeyboardObserver:(JKKeyboardObserver *)keyboardObserver{
    objc_setAssociatedObject(self, "JKKeyboardObserverKey", keyboardObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JKKeyboardObserver *)keyboardObserver{
    return objc_getAssociatedObject(self, "JKKeyboardObserverKey");
}

+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)startObserveKeyboard{
    if (!self.keyboardObserver) {
        self.keyboardObserver = [[JKKeyboardObserver alloc]init];
    }
}

- (void)stopObserveKeyboard{
    if (self.keyboardObserver) {
        self.keyboardObserver = nil;
        objc_removeAssociatedObjects(self);
    }
}

- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock keyboardWillHide:(KeyboardObserverBlock)willHideBlock{
    [self.keyboardObserver keyboardWillShow:willShowBlock];
    [self.keyboardObserver keyboardWillHide:willHideBlock]; 
}


@end
