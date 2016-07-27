//
//  JKKeyboardManager.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/7/26.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "JKKeyboardManager.h"

@interface JKKeyboardManager ()

/**    键盘和输入框的距离    */
@property (nonatomic, strong)NSMutableDictionary * topSpacingMutDict;
/**    当前控制器里的textField和textView    */
@property (nonatomic, strong)NSMutableArray * responderArray;



@property (nonatomic, strong)UIToolbar * toolBar;
@property (nonatomic, strong)UIButton * leftArrowButton;
@property (nonatomic, strong)UIButton * rightArrowButton;
@end

@implementation JKKeyboardManager

+ (instancetype)sharedKeyboardManager{
    static dispatch_once_t once;
    static JKKeyboardManager * manager = nil;
    dispatch_once(&once, ^{
        manager = [[JKKeyboardManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if (self =[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstResponderDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstResponderDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
    }return self;
}


#pragma mark - 监听切换响应者
- (void)firstResponderDidBeginEditing:(NSNotification *)notification{
    
    UITextField * firstResponder = notification.object;
    if (self.showExtensionToolBar) {
        firstResponder.inputAccessoryView = nil;
        firstResponder.inputAccessoryView = self.toolBar;
        if ([firstResponder isKindOfClass:[UITextView class]]) {
            firstResponder.inputAccessoryView = nil;
            firstResponder.inputAccessoryView = self.toolBar;
        }
    }else{
        firstResponder.inputAccessoryView = nil;
    }
    
    if (self.keyboardHeight > 0) {
        UIViewController * currentViewController = self.currentViewController;
        CGFloat windowHeight = self.keyWindow.bounds.size.height;
        CGRect firstResponderFrame = firstResponder.jk_relativeFrame;
        
        CGFloat topSpacingToFirstResponder = self.topSpacingToFirstResponder;
        NSNumber * topSpacing = self.topSpacingMutDict[NSStringFromClass([currentViewController class])];
        if (topSpacing) {
            topSpacingToFirstResponder = topSpacing.floatValue;
        }
        
        CGFloat distance = windowHeight - topSpacingToFirstResponder - self.keyboardHeight - CGRectGetMaxY(firstResponderFrame);
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGRect tempRect = currentViewController.view.frame;
            if (distance < 0 || tempRect.origin.y < 0) {
                tempRect.origin.y += distance;
                currentViewController.view.frame = tempRect;
            }
            
        } completion:nil];
    }
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
    if (robotizationEnable) {
        [self startObserveKeyboard];
        [self keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
            _keyboardHeight = keyboardHeight;
            
            UIViewController * currentViewController = self.currentViewController;
            UIView * firstResponder = [currentViewController.view jk_findFirstResponder];
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
            
        } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
            _keyboardHeight = keyboardHeight;
            UIViewController * currentViewController = self.currentViewController;
            CGRect tempRect = currentViewController.view.frame;
            tempRect.origin.y = 0;
            currentViewController.view.frame = tempRect;
        }];
    }
}


#pragma mark - 监听事件

- (void)startObserveKeyboard{
    if (!self.keyboardObserver) {
        _keyboardObserver = [[JKKeyboardObserver alloc] init];
    }
}

- (void)stopObserveKeyboard{
    if (self.keyboardObserver) {
        _keyboardObserver = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock keyboardWillHide:(KeyboardObserverBlock)willHideBlock{
    [self.keyboardObserver keyboardWillShow:willShowBlock];
    [self.keyboardObserver keyboardWillHide:willHideBlock];
}


- (void)keyboardWillShow:(KeyboardObserverBlock)willShowBlock showAnimationCompletion:(KeyboardObserverCompletionBlock)showCompletion keyboardWillHide:(KeyboardObserverBlock)willHideBlock hideAnimationCompletion:(KeyboardObserverCompletionBlock)hideCompletion{
    [self.keyboardObserver keyboardWillShow:willShowBlock completion:showCompletion];
    [self.keyboardObserver keyboardWillHide:willHideBlock completion:hideCompletion];
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

#pragma mark - 全局隐藏键盘
- (void)hideKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark - ToolBar事件相关

- (void)disClickedLeftArrowButton:(UIButton *)button{

}

- (void)disClickedRightArrowButton:(UIButton *)button{
    
}

#pragma mark - 懒加载
- (NSMutableDictionary *)topSpacingMutDict{
    if (!_topSpacingMutDict) {
        _topSpacingMutDict = [[NSMutableDictionary alloc]init];
    }return _topSpacingMutDict;
}

- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.keyWindow.bounds.size.width, 40)];
        CGFloat arrowWidthHeight = 21.0;
        
        UIImage * leftArrowImage = [[UIImage imageNamed:@"jk_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        CGFloat scale = leftArrowImage.size.width / leftArrowImage.size.height;
        self.leftArrowButton = [UIButton buttonWithBounds:CGRectMake(0, 0, scale*arrowWidthHeight, arrowWidthHeight)
                                                image:leftArrowImage
                                               target:self
                                               action:@selector(disClickedLeftArrowButton:)];
        UIBarButtonItem * leftArrow = [[UIBarButtonItem alloc]initWithCustomView:self.leftArrowButton];
        
        UIBarButtonItem * fixedSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceItem.width = 20;
        
        UIImage * rightArrowImage = [[UIImage imageNamed:@"jk_arrow_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        scale = rightArrowImage.size.width / rightArrowImage.size.height;
        self.rightArrowButton = [UIButton buttonWithBounds:CGRectMake(0, 0, scale*arrowWidthHeight, arrowWidthHeight)
                                                 image:rightArrowImage
                                                target:self
                                                action:@selector(disClickedLeftArrowButton:)];
        UIBarButtonItem * rightArrow = [[UIBarButtonItem alloc]initWithCustomView:self.rightArrowButton];
        
        UIBarButtonItem * flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyBoard)];
        
        [_toolBar setItems:@[leftArrow,fixedSpaceItem,rightArrow,flexibleSpaceItem,doneItem]];
        _toolBar.tintColor = [UIColor blackColor];
        
    }return _toolBar;
}





@end
