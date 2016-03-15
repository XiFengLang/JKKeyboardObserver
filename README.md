# JKKeyboardObserver
iOS全局监听键盘活动

[详情戳简书](http://www.jianshu.com/p/8c5fb5b06771)

```Object-C
导入#import "AppDelegate+JKKeyboardObserver.h" 
 
 *************************************用法1.App全局监听*************************************
 
 // AppDelegate的2个方法中调用开始、结束监听
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self startObserveKeyboard];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopObserveKeyboard];
}


// 相关的控制器里调用监听的方法，block自带动画，第三方输入法升起会瞬间完成动画（时间为0）
 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 
 [[AppDelegate appDelegate]keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 }];
 }
 
 
 
 
************************************** 用法2.控制器局部监听*************************************
 
 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 
 // 步骤1.开始监听,开始后才能 初始化键盘监听者
 [[AppDelegate appDelegate]startObserveKeyboard];
 
 // 步骤2.处理事件，步骤1写在appdelegate后步骤2可全局使用
 [[AppDelegate appDelegate]keyboardWillShow:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 } keyboardWillHide:^(CGFloat keyboardHeight, CGFloat duration) {
 // do something
 
 }];
 }
 
 
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 
 // 步骤3.结束监听,有开始就必须有结束，避免内存泄露
 [[AppDelegate appDelegate]stopObserveKeyboard];
 
 }
```
