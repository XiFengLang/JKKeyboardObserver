//
//  JKKeyboardManager.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "JKKeyboardManager.h"
#import "JKKeyboardToolBar.h"


static const char * kKeyboardManagerRespondersKey = "kKeyboardManagerRespondersKey";


@interface JKKeyboardManager ()
/**    监听者    */
@property (nonatomic, strong)JKKeyboardObserver * keyboardObserver;

/**    键盘和输入框的距离    */
@property (nonatomic, strong)NSMutableDictionary * topSpacingMutDict;

/**    当前控制器里的textField和textView    */
@property (nonatomic, copy)NSArray * responderArray;


@property (nonatomic, strong) JKKeyboardToolBar * toolBar;


@property (nonatomic, strong)UIButton * leftArrowButton;
@property (nonatomic, strong)UIButton * rightArrowButton;
@property (nonatomic, assign)CGFloat keyboardHeight_temp;

@property (nonatomic, weak) UIViewController * topViewController;
@property (nonatomic, weak) UIView * currentFirstResponder;
@end

@implementation JKKeyboardManager

+ (instancetype)sharedKeyboardManager{
    static JKKeyboardManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[JKKeyboardManager alloc]init];
    });
    return manager;
}

- (CGFloat)keyboardHeight {
    return self.keyboardHeight_temp;
}


#pragma mark - 监听切换响应者
- (void)firstResponderDidBeginEditing:(NSNotification *)notification{
    
    UITextView * firstResponder = notification.object;
    self.currentFirstResponder = firstResponder;
    
    /// 设置inputAccessoryView,显示自定义的ToolBar
    [self firstResponderWillBeginEdting:firstResponder];
    
    
    /// 判断左右切换的按钮使能状态
    if (self.showExtensionToolBar) {
        NSUInteger index = [self.responderArray indexOfObject:self.currentFirstResponder];
        [self adjustExtensionBarWithCurrentFirstResponderIndex:index];
    }
    
    
    UIViewController * currentViewController = self.currentViewController;
    if (nil == currentViewController) {
        return;
    }
    
    /// 遍历当前控制器中所有可以成为第一次响应者的输入框
    if (self.topViewController != currentViewController) {
        self.topViewController = currentViewController;
        [self jk_traverseResponderViews];
    }
    
    
    /// 切换输入框后，重新调整frame
    if (self.keyboardHeight_temp > 0) {
        
        CGFloat windowHeight = self.keyWindow.bounds.size.height;
        CGRect firstResponderFrame = firstResponder.jk_relativeFrame;
        
        CGFloat topSpacingToFirstResponder = self.topSpacingToFirstResponder;
        NSNumber * topSpacing = self.topSpacingMutDict[NSStringFromClass([currentViewController class])];
        if (topSpacing) {
            topSpacingToFirstResponder = topSpacing.floatValue;
        }
        
        CGFloat distance = windowHeight - topSpacingToFirstResponder - self.keyboardHeight_temp - CGRectGetMaxY(firstResponderFrame);
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGRect tempRect = currentViewController.view.frame;
            if (distance < 0 || tempRect.origin.y < 0) {
                tempRect.origin.y += distance;
                currentViewController.view.frame = tempRect;
            }
            
        } completion:nil];
    }
}

/// 遍历当前控制器中所有可以成为第一次响应者的输入框
- (void)jk_traverseResponderViews {
    dispatch_async(dispatch_queue_create(kKeyboardManagerRespondersKey, DISPATCH_QUEUE_CONCURRENT), ^{
        self.responderArray = [self.topViewController.view jk_traverseResponderViews];
        [self adjustExtensionBarWithCurrentFirstResponderIndex:[self.responderArray indexOfObject:self.currentFirstResponder]];
    });
}





#pragma mark - 外部设置
- (void)setTopSpacingToFirstResponder:(CGFloat)distance forViewControllerClass:(Class)ViewControllerClass{
    if ([ViewControllerClass isSubclassOfClass:[UIViewController class]]) {
        NSNumber * topSpacing = [NSNumber numberWithFloat:distance];
        NSString * className = NSStringFromClass(ViewControllerClass);
        [self.topSpacingMutDict setObject:topSpacing forKey:className];
    }else{
        NSLog(@"\nJKKeyboardManager Error: %@ is not subClass of UIViewController.",ViewControllerClass);
    }
}

#pragma mark - 自动移动输入框

// wa: 某些类关闭此功能
- (void)setRobotizationEnable:(BOOL)robotizationEnable{
    _robotizationEnable = robotizationEnable;
    if (_robotizationEnable) {
        [self startObserveKeyboard];
        
        __weak typeof(self) weakSelf = self;
        [self.keyboardObserver keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
            __strong typeof(weakSelf) self = weakSelf;
            self.keyboardHeight_temp = keyboardHeight;
            
            UIViewController * currentViewController = self.currentViewController;
            UITextView * firstResponder = (UITextView *)[currentViewController.view jk_findFirstResponder];
            
            /// 屏蔽网页
            if ([firstResponder isKindOfClass:NSClassFromString(@"WKContentView")]
                || nil == currentViewController
                || nil == firstResponder) {
                return ;
            }
            
            
            /// 设置inputAccessoryView,显示自定义的ToolBar
            [self firstResponderWillBeginEdting:firstResponder];
            
            
            /// 键盘到输入框的间距
            CGRect firstResponderFrame = firstResponder.jk_relativeFrame;
            CGFloat topSpacingToFirstResponder = self.topSpacingToFirstResponder;
            NSNumber * topSpacing = self.topSpacingMutDict[NSStringFromClass([currentViewController class])];
            if (topSpacing) {
                topSpacingToFirstResponder = topSpacing.floatValue;
            }
            
            CGFloat windowHeight = self.keyWindow.bounds.size.height;
            CGFloat distance = windowHeight - topSpacingToFirstResponder - keyboardHeight - CGRectGetMaxY(firstResponderFrame);
            if (distance < 0) {
                CGRect tempRect = currentViewController.view.frame;
                tempRect.origin.y += distance;
                currentViewController.view.frame = tempRect;
            }
        }];
        
        
        [self.keyboardObserver keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
            __strong typeof(weakSelf) self = weakSelf;
            self.keyboardHeight_temp = keyboardHeight;
            UIViewController * currentViewController = self.currentViewController;
            CGRect tempRect = currentViewController.view.frame;
            tempRect.origin.y = 0;
            currentViewController.view.frame = tempRect;
        }];

    } else {
        [self stopObserveKeyboard];
    }
}


/// 设置inputAccessoryView,显示自定义的ToolBar
- (void)firstResponderWillBeginEdting:(UITextView *)firstResponder {
    if (self.showExtensionToolBar) {
        if (nil == firstResponder.inputAccessoryView) {
            firstResponder.inputAccessoryView = self.toolBar;
            
            /// UITextView要做特殊处理，否则第一次不会出现inputAccessoryView
            if ([firstResponder isKindOfClass:[UITextView class]]) {
                [firstResponder resignFirstResponder];
                [firstResponder becomeFirstResponder];
            }
        }
    } else {
        firstResponder.inputAccessoryView = nil;
    }
}






#pragma mark - 监听事件

- (void)startObserveKeyboard{
    if (!self.keyboardObserver) {
        _keyboardObserver = [[JKKeyboardObserver alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstResponderDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstResponderDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [self.keyboardObserver startObserveKeyboard];
    }
}

- (void)stopObserveKeyboard{
    if (self.keyboardObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
        [self.keyboardObserver stopObserveKeyboard];
        [self.keyboardObserver relieveBlockStrongReference];
        self.keyboardObserver = nil;
    }
}


#pragma mark - 取最上方的ViewController/keyWindow

- (UIViewController *)currentViewController{
    UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findTopsideViewController:viewController];
}

// 遍历正在显示（最上层）的控制器
- (UIViewController *)findTopsideViewController:(UIViewController *)viewController{
    if (viewController.presentedViewController) {
        return [self findTopsideViewController:viewController.presentedViewController];
        
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController * masterViewController = (UISplitViewController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findTopsideViewController:masterViewController.viewControllers.lastObject];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * masterViewController = (UINavigationController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findTopsideViewController:masterViewController.topViewController];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * masterViewController = (UITabBarController *) viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findTopsideViewController:masterViewController.selectedViewController];
        else
            return viewController;
    } else {
        return viewController;
    }
}

- (UIWindow *)keyWindow{
    NSArray * windows = [UIApplication sharedApplication].windows;
    for (id window in windows) {
        if ([window isKindOfClass:[UIWindow class]]) {
            return (UIWindow *)window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}


- (void)relieveBlockStrongReference {
    [self.keyboardObserver relieveBlockStrongReference];
}


#pragma mark - 全局隐藏键盘
- (void)hideKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark - ToolBar事件相关

- (void)adjustExtensionBarWithCurrentFirstResponderIndex:(NSUInteger)index {
    if (self.responderArray && self.responderArray.count) {
        if (index <= self.responderArray.count) {
            if (index == 0) {
                self.toolBar.leftArrowButton.enabled = NO;
                self.toolBar.rightArrowButton.enabled = YES;
            } else if (index == self.responderArray.count -1) {
                self.toolBar.leftArrowButton.enabled = YES;
                self.toolBar.rightArrowButton.enabled = NO;
            }
        } else {
            self.toolBar.leftArrowButton.enabled = NO;
            self.toolBar.rightArrowButton.enabled = NO;
        }
    }
}

- (void)didClickedLeftArrowButton:(UIButton *)button {
    NSUInteger index = [self.responderArray indexOfObject:self.currentFirstResponder];
    if (index < self.responderArray.count) {
        UITextView * nextResponder = [self.responderArray objectAtIndex:index - 1];
        BOOL ret = [nextResponder becomeFirstResponder];
        if (ret) {
            self.currentFirstResponder = nextResponder;
        }
    }
}

- (void)didClickedRightArrowButton:(UIButton *)button {
    NSUInteger index = [self.responderArray indexOfObject:self.currentFirstResponder];
    if (index < self.responderArray.count) {
        UITextView * nextResponder = [self.responderArray objectAtIndex:index + 1];
        BOOL ret = [nextResponder becomeFirstResponder];
        if (ret) {
            self.currentFirstResponder = nextResponder;
        }
    }
}

- (void)didClickedDoneButton:(UIButton *)button {
    [self hideKeyBoard];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)topSpacingMutDict{
    if (!_topSpacingMutDict) {
        _topSpacingMutDict = [[NSMutableDictionary alloc]init];
    }return _topSpacingMutDict;
}



- (JKKeyboardToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[JKKeyboardToolBar alloc]initWithFrame:CGRectMake(0, 0, self.keyWindow.bounds.size.width, 40) target:self leftArrowAction:@selector(didClickedLeftArrowButton:) rightArrowAction:@selector(didClickedRightArrowButton:) doneAction:@selector(didClickedDoneButton:)];
    }return _toolBar;
}
@end
