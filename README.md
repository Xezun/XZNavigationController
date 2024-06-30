# XZNavigationController

[![CI Status](https://img.shields.io/badge/Build-pass-brightgreen.svg)](https://cocoapods.org/pods/XZNavigationController)
[![Version](https://img.shields.io/cocoapods/v/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)
[![License](https://img.shields.io/cocoapods/l/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)

XZNavigationController 是一款面向协议的、使原生的 UINavigationController 能够支持自定义导航条、全屏手势导航功能的 iOS 开源组件。

XZNavigationController is a protocol oriented iOS open source component that enables native UINavigationController to support custom navigation bars and full screen gesture navigation functions.

## 示例项目 Example

在拉取代码后，在示例项目中 `Pods` 目录下执行 `pod install` 命令后，就可以运行项目，体验所有功能效果。

To run the example project, clone the repo, and run `pod install` from the Pods directory first.

## 版本要求 Requirements

iOS 11.0, Xcode 14.0

## 安装使用 Installation

推荐使用 [CocoaPods](https://cocoapods.org) 安装。

XZNavigationController is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'XZNavigationController'
```

## 功能特性

`XZNavigationController`是对原生`UINavigationController`的增强辅助协议，它增强的原生`UINavigationController`的功能。

1. 使`UINavigationController`支持自定义导航条

当开启自定义功能后，通过`XZNavigationBarCustomizable`协议，导航栈内的控制器可以设置定义的导航条。

自定义导航条会展示在原生导航条之上，而不是取代它，所以原生导航条的功能和特性，都还是保留的。

拥有自定义导航条的控制，可以摆脱在`viewWillAppear`中对导航条状态的维护了，因为`XZNavigationController`在展示控制器时，会自动根据控制器的自定义导航条的状态，设置原生导航条的状态。

2. 使`UINavigationController`支持全屏手势导航

原生仅支持手势返回，且限制颇多，所以`XZNavigationController`重写了手势，不仅支持全屏手势返回，还支持手势进入下一页。

3. 支持更多转场效果（TODO）

由于完全是自定义的转场，`XZNavigationController`有能力实现，支持更多转场效果，或者提供更简便的自定义转场实现方式。

## 如何使用

### 一、面向协议

`XZNavigationController` 是一个 `protocol` 协议，仅需要遵循它，可以获得开启自定义导航条、全屏手势的功能。

```swift
class ExampleNavigationController: UINavigationController, XZNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isCustomizable = true  // 打开自定义导航栏、全屏手势功能支持
    }
    
}
```

`XZNavigationController` 几乎是一个零接入成本的接入框架，因为它不需要改变基类，不需要改变现有的代码逻辑，仅仅需要在用到它的页面配置功能即可。

```
// 页面若要自定义导航条，仅需遵循 XZNavigationBarCustomizable 协议即可。
extension ExampleNextViewController: XZNavigationBarCustomizable {
    var navigationBarIfLoaded: XZNavigationBarProtocol? {
        // return your custom navigation bar
    }
}

// 页面若要支持全屏手势导航，仅需遵循 XZNavigationGestureDrivable 协议即可。
extension ExampleNextViewController: XZNavigationGestureDrivable {
}
```

如何自定义导航条及如何控制手势导航，请继续查看下文。

### 二、自定义导航条

`UIView` 视图遵循 `XZNavigationBarProtocol` 协议，就可作为控制器的自定义导航条。

> 为了方面开发，框架内置了 `XZNavigationBar` 基类，以此进行开发，自定义导航条更简单。
> 框架默认不会提供自定义导航条，基类 `XZNavigationBar` 只是一个开发选项，自定义导航条仅需要遵循协议即可，并非必须以它为基类。

`XZNavigationBarProtocol` 协议要求很简单，仅需两个会影响导航条外观属性即可。

```swift
public protocol XZNavigationBarProtocol: UIView {
    var isTranslucent: Bool { get set }
    var prefersLargeTitles: Bool { get set }
}
```

在示例项目中，利用 `XZNavigationBar` 作为基类，模拟了原生导航条，主要代码如下。

```swift
public class ExampleNavigationBar: XZNavigationBar {
    
    public var title: String? {
        get {
            return (self.titleView as? UILabel)?.text
        }
        set {
            if titleView == nil {
                // 1. 配置 titleLabel 和 largeTitleLabel
                ...
                
                // 2. largeTitleLabel 可以直接作为 largeTitleView，但示例中，为了要实现覆盖的效果额外增加一个容器视图
                let largeTitleView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: 52))
                largeTitleView.addSubview(largeTitleLabel)
                
                // 3. 使用 XZNavigationBar 只需要赋值 titleView 和 largeTitleView 即可，布局会自动进行
                self.titleView = titleLabel
                self.largeTitleView = largeTitleView
            } 
            titleLabel.text = newValue
            largeTitleLabel.text = newValue
        }
    }
    
    private let titleLabel = UILabel.init()
    private let largeTitleLabel = UILabel.init()
}
```

示例中，自定义导航条添加展示标题和大标题的功能，利用 `XZNaviagtionBar` 基类，代码极其简单，甚至不用考虑布局。


### 三、使用自定义导航条

在上面提到，在控制器中使用自定义导航条，需要控制器实现 `XZNavigationBarCustomizable` 协议。

```swift
public protocol XZNavigationBarCustomizable: UIViewController {
    var navigationBarIfLoaded: XZNavigationBarProtocol? { get }
}
```

这个协议也很简单，因为它需要告诉 `XZNavigationController` 控制器如何它的自定义的导航条，也就是一个属性即可。

如果有统一的导航条样式，那么我们利用 Swift 面向协议的特性，创建一个拓展，让遵循协议的控制器，自动获得统一的自定义导航条，就像示例项目中那样。

```swift
extension XZNavigationBarCustomizable {
    
    public var navigationBarIfLoaded: XZNavigationBarProtocol? {
        return self.navigationBar
    }
    
    public var navigationBar: ExampleNavigationBar {
        if let navigationBar = objc_getAssociatedObject(self, &_navigationBar) as? ExampleNavigationBar {
            return navigationBar
        }
        let navigationBar = ExampleNavigationBar(for: self, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        objc_setAssociatedObject(self, &_navigationBar, navigationBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navigationBar
    }
}
```

通过示例，我们可以看到为什么协议中定义的是 `navigationBarIfLoaded` 属性，因为框架把 `navigationBar` 留给了开发者使用。
而且，通过这种类型的中转，这样项目中，我们就可以避免不必要的类型转换代码。

当我们设立了统一自定义导航条后，我们就可以在控制器中使用了。

```swift
class ExampleLastViewController: UITableViewController, XZNavigationBarCustomizable {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.title = "尾页"
        self.navigationBar.barTintColor = .systemBrown
    }
}
```

另外，我们还可以为页面单独去实现 `XZNavigationBarCustomizable` 协议，为页面使用独立样式的导航条。

### 四、全屏手势导航

原生的 UINavigationController 对手势返回的使用条件比较苛刻，所以 XZNavigationController 改进了这一功能。

1. 所有页面都支持手势返回。
2. 支持手势导航到下一个页面。
3. 支持手势导航返回到任意页面。

当然，手势导航的行为都可以通过 `XZNavigationGestureDrivable` 协议进行控制，以满足各种需求。

```swift
public protocol XZNavigationGestureDrivable: UIViewController {
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets?
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController?
    
}
```

协议的第一个方法，通过控制边距，就可以控制手势导航能否触发。

1. 返回 nil，表示全屏可手势触发导航行为，默认。
2. 其它值表示可触发手势导航的边缘范围。

协议的第二个方法，则可以在手势导航时，去往任何页面。

1. Push 时，返回目标控制器，即触发 push 进入目标页面，返回 nil 不触发。
2. Pop 时，返回 nil 表示返回上一个页面，返回其它值，表示返回到指定的栈内页面。

## Author

Xezun, developer@xezun.com

## License

XZNavigationController is available under the MIT license. See the LICENSE file for more info.
