![version](https://img.shields.io/badge/Version-v1.2.0-blue.svg) ![platform](https://img.shields.io/badge/platform-iOS-ligtgrey.svg)  ![ios](https://img.shields.io/badge/Requirements-iOS8%2B-green.svg)

## JKKeyboardManager

全局监听键盘弹出事件，自动处理键盘遮盖问题，动态调整输入框和键盘的相对位置。


## Usage

* 在`application didFinishLaunchingWithOptions` 中初始化并设置全局属性

```Object-C

    KeyboardManager().robotizationEnable = YES;
    // 设置键盘到输入框的距离
    KeyboardManager().topSpacingToFirstResponder = 20;
    // 显示自定义的toolBar，切换输入框或者隐藏键盘
    KeyboardManager().showExtensionToolBar = YES;
    
    // 内联函数，返回单例
	static inline JKKeyboardManager * KeyboardManager() {
	    return [JKKeyboardManager sharedKeyboardManager];
	}
```


* 为特定类定制属性，比如键盘到输入框的距离

```Object-C
	[KeyboardManager() setTopSpacingToFirstResponder:30 forViewControllerClass:self.class];
```


## 其他

* 隐藏键盘（全局效果）

```Object-C
   [KeyboardManager() hideKeyboard];
```

* 取当前显示的window

```Object-C
	KeyboardManager().keyWindow
```

* 取最上层的控制器（当前显示的控制器）

```Object-C
	KeyboardManager().currentViewController
```

![gif](http://wx1.sinaimg.cn/mw690/c56eaed1gy1fetak12q21g20bf0kjtlg.gif)