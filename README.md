# 自动监听键盘弹出，自动处理键盘遮盖问题,动画调整输入框和键盘的相对位置。
`1.1`


~~[详情戳简书](http://www.jianshu.com/p/8c5fb5b06771)~~，改版太大，参考意义不大。

-------

**几行代码即可**
```Object-C
    KeyboardManager().robotizationEnable = YES;
    KeyboardManager().topSpacingToFirstResponder = 20;  // 设置键盘到输入框的距离的全局效果，
    KeyboardManager().showExtensionToolBar = YES;      // 可以切换上下左右的输入框
    
     // 设置特定控制器中键盘到输入框的距离
//    [KeyboardManager() setTopSpacingToFirstResponder:30 forViewControllerClass:self.class];
```



**隐藏键盘**
```Object-C
     [KeyboardManager() hideKeyboard];
```
