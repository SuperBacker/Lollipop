
<p align="center">
  <img src="./Lollipop.png" alt="Lollipop">
  <br/><a href="https://cocoapods.org/pods/Lollipop">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-brightgreen.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Meniny-blue.svg">
  <img alt="Build Passing" src="https://img.shields.io/badge/build-passing-brightgreen.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-3.0%2B-orange.svg">
  <br/>
  <img alt="Platforms" src="https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20tvOS-lightgrey.svg">
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <br/>
  <img alt="Cocoapods" src="https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg">
  <img alt="Carthage" src="https://img.shields.io/badge/carthage-working%20on-red.svg">
  <img alt="SPM" src="https://img.shields.io/badge/swift%20package%20manager-working%20on-red.svg">
  </a>
</p>

***

# Introduction/介绍

## What's this?/这是什么？

`Lollipop` is a syntactic sugar for `Auto Layout`.

`Lollipop` 是一块 `Auto Layout` 的语法糖。

<p align="center">
  <img src="./Assets/Sample-Lollipop.gif" alt="Sample-Lollipop">
</p>

## Requirements/要求

* iOS 9.0+
* macOS 10.11+
* tvOS 9.0+
* Xcode 8+ with Swift 3+

## Installation/安装

#### CocoaPods

```ruby
pod 'Lollipop'
```

## Contribution/贡献

You are welcome to fork and submit pull requests.

## License/许可

`Lollipop` is open-sourced software, licensed under the `MIT` license.

## Abstraction/抽象

```swift
// AL == Auto Layout

#if os(OSX)
    public typealias ALView = NSView
    public typealias ALLayoutGuide = NSLayoutGuide
    public typealias ALConstraintAxis = NSLayoutConstraintOrientation
    public typealias ALLayoutPriority = NSLayoutPriority
    public typealias ALEdgeInsets = EdgeInsets
#else
    public typealias ALView = UIView
    public typealias ALLayoutGuide = UILayoutGuide
    public typealias ALConstraintAxis = UILayoutConstraintAxis
    public typealias ALLayoutPriority = UILayoutPriority
    public typealias ALEdgeInsets = UIEdgeInsets
#endif

public typealias ALFloat = CGFloat
public typealias ALRange = (min: ALFloat?, max: ALFloat?)
public typealias ALOffset = (x: ALFloat, y: ALFloat)
public typealias ALPoint = CGPoint
public typealias ALVector = CGVector
public typealias ALSize = CGSize

public typealias ALXAxisAnchor = NSLayoutXAxisAnchor
public typealias ALYAxisAnchor = NSLayoutYAxisAnchor

public typealias ALConstraint = NSLayoutConstraint

public enum ALActivation: Int {
    case active = 1
    case inactive = 0
}

public enum ALConstraintRelation: Int {
    case equalTo = 0
    case equalOrLessThan = -1
    case equalOrGreaterThan = 1
}

public enum ALConstraintPriority: ALLayoutPriority {
    case `default` = 1000
    case high = 750
    case low = 250
    case fittingSize = 50

    public var value: ALLayoutPriority {
        return rawValue
    }
}
```

## Usage/用法

* Center

```swift
@discardableResult
public func center(in view: Lollipop,
                   offset: ALPoint = .zero,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> [ALConstraint]

@discardableResult
public func centerX(equalTo view: Lollipop,
                    anchor: ALXAxisAnchor? = nil,
                    offset: ALFloat = 0,
                    priority: ALConstraintPriority = .default,
                    isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func centerY(equalTo view: Lollipop,
                    anchor: ALYAxisAnchor? = nil,
                    offset: ALFloat = 0,
                    priority: ALConstraintPriority = .default,
                    isActive: ALActivation = .active) -> ALConstraint
```

* Edges

```swift
@discardableResult
public func edges(equalTo view: Lollipop,
                  insets: ALEdgeInsets = .zero,
                  priority: ALConstraintPriority = .default,
                  isActive: ALActivation = .active) -> [ALConstraint]
```

* Size/Origin

```swift
@discardableResult
public func size(equalTo size: ALSize,
                 priority: ALConstraintPriority = .default,
                 isActive: ALActivation = .active) -> [ALConstraint]

@discardableResult
public func origin(equalTo view: Lollipop,
                   insets: ALVector = .zero,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> [ALConstraint]
```

* Width

```swift
@discardableResult
public func width(_ relation: ALConstraintRelation,
                  _ width: ALFloat,
                  priority: ALConstraintPriority = .default,
                  isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func width(_ relation: ALConstraintRelation,
                  _ view: Lollipop,
                  dimension: NSLayoutDimension? = nil,
                  multiplier: ALFloat = 1,
                  offset: ALFloat = 0,
                  priority: ALConstraintPriority = .default,
                  isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func width(between range: ALRange? = nil,
                  priority: ALConstraintPriority = .default,
                  isActive: ALActivation = .active) -> [ALConstraint]
```

* Height

```swift
@discardableResult
public func height(_ relation: ALConstraintRelation,
                   _ height: ALFloat,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func height(_ relation: ALConstraintRelation,
                   _ view: Lollipop,
                   dimension: NSLayoutDimension? = nil,
                   multiplier: ALFloat = 1,
                   offset: ALFloat = 0,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func height(between range: ALRange? = nil,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> [ALConstraint]
```

* Leading/Left

```swift
@discardableResult
public func leading(_ relation: ALConstraintRelation,
                    _ view: Lollipop,
                    anchor: ALXAxisAnchor? = nil,
                    offset: ALFloat = 0,
                    priority: ALConstraintPriority = .default,
                    isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func left(_ relation: ALConstraintRelation,
                 _ view: Lollipop,
                 anchor: ALXAxisAnchor? = nil,
                 offset: ALFloat = 0,
                 priority: ALConstraintPriority = .default,
                 isActive: ALActivation = .active) -> ALConstraint
```

* Trailing/Right

```swift
@discardableResult
public func trailing(_ relation: ALConstraintRelation = .equalTo,
                     _ view: Lollipop,
                     anchor: ALXAxisAnchor? = nil,
                     offset: ALFloat = 0,
                     priority: ALConstraintPriority = .default,
                     isActive: ALActivation = .active) -> ALConstraint

@discardableResult
public func right(_ relation: ALConstraintRelation,
                  _ view: Lollipop,
                  anchor: ALXAxisAnchor? = nil,
                  offset: ALFloat = 0,
                  priority: ALConstraintPriority = .default,
                  isActive: ALActivation = .active) -> ALConstraint
```

* Top

```swift
@discardableResult
public func top(_ relation: ALConstraintRelation,
                _ view: Lollipop,
                anchor: ALYAxisAnchor? = nil,
                offset: ALFloat = 0,
                priority: ALConstraintPriority = .default,
                isActive: ALActivation = .active) -> ALConstraint
```

* Bottom

```swift
@discardableResult
public func bottom(_ relation: ALConstraintRelation,
                   _ view: Lollipop,
                   anchor: ALYAxisAnchor? = nil,
                   offset: ALFloat = 0,
                   priority: ALConstraintPriority = .default,
                   isActive: ALActivation = .active) -> ALConstraint
```

## Samples/示例

```swift
import Foundation
#if os(OSX)
    import AppKit

    public typealias Color = NSColor
    public typealias Controller = NSViewController
#else
    import UIKit

    public typealias Color = UIColor
    public typealias Controller = UIViewController
#endif
import Lollipop

public func addItems(to view: ALView) {
    let max = 10
    for i in 1...max {
        let value: ALFloat = 1 - ALFloat(i) / ALFloat(max)
        let color = Color(red: value, green: value, blue: value, alpha: 1.0)
        let item = ALView()
        #if os(OSX)
            item.wantsLayer = true
            item.layer?.backgroundColor = color.cgColor
        #else
            item.backgroundColor = color
        #endif
        view.addSubview(item)
        item.width(.equalTo, view, dimension: nil, multiplier: value, offset: 0, priority: .default, isActive: .active)
        item.height(.equalTo, item, dimension: item.widthAnchor, multiplier: 1, offset: 0, priority: .default, isActive: .active)
        item.center(in: view)
    }
}

class ViewController: Controller {
    override func viewDidLoad() {
        super.viewDidLoad()
        addItems(to: self.view)
    }
}
```
