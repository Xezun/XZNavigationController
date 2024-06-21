# XZNavigationController

[![CI Status](https://img.shields.io/badge/Build-pass-brightgreen.svg)](https://cocoapods.org/pods/XZNavigationController)
[![Version](https://img.shields.io/cocoapods/v/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)
[![License](https://img.shields.io/cocoapods/l/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/XZNavigationController.svg?style=flat)](https://cocoapods.org/pods/XZNavigationController)

这是一款能使 UINavigationController 支持自定义导航条、全屏手势导航功能的、面向协议的 iOS 组件。

## 功能特性

### 一、面向协议

若要开启自定义导航条支持，遵循 XZNavigationController 协议即可，不需要改变基类，零接入成本。

```swift
// 让您的控制器遵循协议，即可获得自定义导航栏开关属性
class ExampleNavigationController: UINavigationController, XZNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 打开自定义导航栏开关
        self.isCustomizable = true
    }
    
}
```

### 二、自定义导航条

视图仅需要遵循 `XZNavigationBarProtocol` 协议，即可作为控制器的自定义导航条。为了方面开发，框架内置了 `XZNavigationBar` 基类，以此进行开发，自定义导航条更简单。

> 框架默认不会提供自定义导航条，基类 `XZNavigationBar` 只是一个开发选项，自定义导航条仅需要遵循协议即可，并非必须以它为基类。

在内置 Demo 中，利用 XZNavigationBar 模拟了原生导航条，代码极其简单，甚至不用考虑布局。

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

> `XZNavigationBar` 已实现了 `XZNavigationBarProtocol` 协议，所以不需要额外实现。
> 不过 `XZNavigationBarProtocol` 协议的实现并不复杂，只需定义两个属性即可，这两个属性会影响导航条布局，所以需要额外实现。

```swift
public protocol XZNavigationBarProtocol: UIView {
    var isTranslucent: Bool { get set }
    var prefersLargeTitles: Bool { get set }
}
```

### 三、使用自定义导航条

在控制器中使用自定义导航条，仅需要控制器实现 `XZNavigationBarCustomizable` 协议即可。

```swift
public protocol XZNavigationBarCustomizable: UIViewController {
    var navigationBarIfLoaded: XZNavigationBarProtocol? { get }
}
```

没错这个协议，仅需实现一个属性。这个属性其实就是告诉框架，控制器创建了自定义导航条后，框架要通过哪个属性去获取它。

利用 Swift 面向协议的特性，我们可以创建一个拓展，让遵循协议的控制器，自动获得统一的自定义导航条。

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

这样在控制器中，我们就可以直接使用了。

```swift
class ExampleLastViewController: UITableViewController, XZNavigationBarCustomizable {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.title = "尾页"
        self.navigationBar.barTintColor = .systemBrown
    }
}
```

在示例中，我们直接使用的是 `navigationBar` 属性，而不是 `XZNavigationBarCustomizable` 协议中的 `navigationBarIfLoaded` 属性，这是因为 `IfLoaded` 是一个范型对象，在上面的拓展中，我们用具体的 `navigationBar` 类型进行中转，这样我们就不必要去做类型转换了。

### 四、全屏手势导航

原生 UINavigationController 对手势返回的使用条件比较苛刻，所以 XZNavigationController 改进了这一功能。

1. 默认情况下都支持手势返回。
2. 支持手势导航前进到下一个页面。
3. 支持手势导航返回到任意页面。
4. 支持限制导航行为。

要支持如上功能，仅需要遵循`XZNavigationGestureDrivable`一个协议即可。

```swift
public protocol XZNavigationGestureDrivable: UIViewController {
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets?
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController?
    
}
```

协议的第一个方法，通过控制边距，就可以控制手势导航能否触发；实现第二个方法，则可以在手势导航时，去往任何页面；具体可在代码中查看方法注释。

## Example

To run the example project, clone the repo, and run `pod install` from the Pods directory first.

## Requirements

iOS 11.0, Xcode 14.0

## Installation

XZNavigationController is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'XZNavigationController'
```

## Author

Xezun, developer@xezun.com

## License

XZNavigationController is available under the MIT license. See the LICENSE file for more info.
