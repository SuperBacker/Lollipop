//
//  Lollipop.swift
//  Lollipop
//
//  Created by Meniny on 2016-05-19.
//  Copyright © 2016 Meniny. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

// AL == Auto Layout

// MARK: - Abstraction
#if os(OSX)
    public typealias ALView = NSView
    public typealias ALLayoutGuide = NSLayoutGuide
    public typealias ALConstraintAxis = NSLayoutConstraintOrientation
    public typealias ALPriorityValue = NSLayoutPriority
    public typealias ALEdgeInsets = EdgeInsets
#else
    public typealias ALView = UIView
    public typealias ALLayoutGuide = UILayoutGuide
    public typealias ALConstraintAxis = UILayoutConstraintAxis
    public typealias ALPriorityValue = UILayoutPriority
    public typealias ALEdgeInsets = UIEdgeInsets
#endif

//public typealias ALFloat = CGFloat
public typealias ALRange = (min: CGFloat?, max: CGFloat?)
//public typealias ALOffset = (x: CGFloat, y: CGFloat)
//public typealias ALPoint = CGPoint
//public typealias ALVector = CGVector
//public typealias ALSize = CGSize

public typealias ALXAxisAnchor = NSLayoutXAxisAnchor
public typealias ALYAxisAnchor = NSLayoutYAxisAnchor

public typealias ALConstraint = NSLayoutConstraint

public enum CGPointAxis {
    case x, y
}

public enum ALActivation: Int {
    case active = 1
    case inactive = 0
}

public enum ALLayoutPriority: ALPriorityValue {
    case `default` = 1000
    case high = 750
    case low = 250
    case fittingSize = 50
}

#if os(OSX)
    public extension EdgeInsets {
        public static var zero = NSEdgeInsetsZero
    }
#endif

public extension ALEdgeInsets {
    public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}

public extension CGFloat {
    public static var zero: CGFloat = 0
}

fileprivate extension ALConstraint {
    @discardableResult
    fileprivate func priority(_ p: ALLayoutPriority = .default) -> Self {
        priority = p.rawValue
        return self
    }
    
    @discardableResult
    fileprivate func active(_ a: Bool = true) -> Self {
        isActive = a
        return self
    }
}

public extension Collection where Iterator.Element == ALConstraint {
    @discardableResult
    public func activate() -> Self {
        if let constraints = self as? [ALConstraint] {
            ALConstraint.activate(constraints)
        }
        return self
    }
    
    @discardableResult
    public func deactivate() -> Self {
        if let constraints = self as? [ALConstraint] {
            ALConstraint.deactivate(constraints)
        }
        return self
    }
    
//    @discardableResult
//    public func priority(_ p: ALLayoutPriority = .default) -> Self {
//        if let constraints = self as? [ALConstraint] {
//            for c in constraints {
//                c.priority = p.rawValue
//            }
//        }
//        return self
//    }
}

// MARK: - Lollipop

public protocol Lollipop {
    var topAnchor: ALYAxisAnchor { get }
    var bottomAnchor: ALYAxisAnchor { get }
    
    var leftAnchor: ALXAxisAnchor { get }
    var leadingAnchor: ALXAxisAnchor { get }
    
    var rightAnchor: ALXAxisAnchor { get }
    var trailingAnchor: ALXAxisAnchor { get }
    
    var centerXAnchor: ALXAxisAnchor { get }
    var centerYAnchor: ALYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    
    func prepareForLayoutIfNeeded()
}

extension ALView: Lollipop {
    public func prepareForLayoutIfNeeded() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ALLayoutGuide: Lollipop {
    public func prepareForLayoutIfNeeded() {
        // nothing...
    }
}

// MARK: - Center
public extension Lollipop {
    @discardableResult
    public func center(in view: Lollipop,
                       offset: CGPoint = .zero,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).priority(priority),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).priority(priority)
        ]
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    public func centerX(equalTo view: Lollipop,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        return centerX(equalTo: view.centerXAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func centerX(equalTo anchor: ALXAxisAnchor,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        return centerXAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
    }
    
    @discardableResult
    public func centerY(equalTo view: Lollipop,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        return centerY(equalTo: view.centerYAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func centerY(equalTo anchor: ALYAxisAnchor,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        return centerYAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
    }
}

// MARK: - Edge
public extension Lollipop {
    @discardableResult
    public func edges(equalTo view: Lollipop,
                      insets: ALEdgeInsets = .zero,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> [ALConstraint] {
        return edges(top: view.topAnchor,
                     leading: view.leadingAnchor,
                     bottom: view.bottomAnchor,
                     trailing: view.trailingAnchor,
                     insets: insets,
                     priority: priority,
                     active: active)
    }
    
    @discardableResult
    public func edges(top: ALYAxisAnchor,
                      leading: ALXAxisAnchor,
                      bottom: ALYAxisAnchor,
                      trailing: ALXAxisAnchor,
                      insets: ALEdgeInsets = .zero,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            topAnchor.constraint(equalTo: top, constant: insets.top).priority(priority),
            leadingAnchor.constraint(equalTo: leading, constant: insets.left).priority(priority),
            bottomAnchor.constraint(equalTo: bottom, constant: insets.bottom).priority(priority),
            trailingAnchor.constraint(equalTo: trailing, constant: insets.right).priority(priority)
        ]
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Size/Origin
public extension Lollipop {
    @discardableResult
    public func size(equalTo s: CGSize,
                     priority: ALLayoutPriority = .default,
                     active: Bool = true) -> [ALConstraint] {
        return size(equalTo: s.width, by: s.height, priority: priority, active: active)
    }
    
    @discardableResult
    public func size(equalTo width: CGFloat, by height: CGFloat,
                     priority: ALLayoutPriority = .default,
                     active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: width).priority(priority),
            heightAnchor.constraint(equalToConstant: height).priority(priority)
        ]
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    public func origin(equalTo view: Lollipop,
                       offset: CGVector = .zero,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset.dx).priority(priority),
            topAnchor.constraint(equalTo: view.topAnchor, constant: offset.dy).priority(priority)
        ]
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Width
public extension Lollipop {
    @discardableResult
    public func width(_ relation: NSLayoutRelation,
                      to constant: CGFloat,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalToConstant: constant).priority(priority).active(active)
        case .lessThanOrEqual: return widthAnchor.constraint(lessThanOrEqualToConstant: constant).priority(priority).active(active)
        case .greaterThanOrEqual: return widthAnchor.constraint(greaterThanOrEqualToConstant: constant).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func width(_ relation: NSLayoutRelation,
                      to view: Lollipop,
                      multiplier: CGFloat = 1,
                      offset: CGFloat = 0,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> ALConstraint {
        return width(relation, to: view.widthAnchor, multiplier: multiplier, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func width(_ relation: NSLayoutRelation,
                      to dimension: NSLayoutDimension,
                      multiplier: CGFloat = 1,
                      offset: CGFloat = 0,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return widthAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return widthAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func width(from min: CGFloat?,
                      to max: CGFloat?,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()

        var constraints = [ALConstraint]()
        
        if let min = min {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: min).priority(priority))
        }
        
        if let max = max {
            constraints.append(widthAnchor.constraint(lessThanOrEqualToConstant: max).priority(priority))
        }
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Height
public extension Lollipop {
    @discardableResult
    public func height(_ relation: NSLayoutRelation,
                       to constant: CGFloat,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalToConstant: constant).priority(priority).active(active)
        case .lessThanOrEqual: return heightAnchor.constraint(lessThanOrEqualToConstant: constant).priority(priority).active(active)
        case .greaterThanOrEqual: return heightAnchor.constraint(greaterThanOrEqualToConstant: constant).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func height(_ relation: NSLayoutRelation,
                       to view: Lollipop,
                       multiplier: CGFloat = 1,
                       offset: CGFloat = 0,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> ALConstraint {
        return height(relation, to: view.heightAnchor, multiplier: multiplier, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func height(_ relation: NSLayoutRelation,
                       to dimension: NSLayoutDimension,
                       multiplier: CGFloat = 1,
                       offset: CGFloat = 0,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return heightAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return heightAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: offset).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func height(from min: CGFloat?,
                       to max: CGFloat?,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        var constraints = [ALConstraint]()
        
        if let min = min {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualToConstant: min).priority(priority))
        }
        
        if let max = max {
            constraints.append(heightAnchor.constraint(lessThanOrEqualToConstant: max).priority(priority))
        }
        
        if active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Left/Leading
public extension Lollipop {
    @discardableResult
    public func leading(_ relation: NSLayoutRelation,
                        to view: Lollipop,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        return leading(relation, to: view.leadingAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func leading(_ relation: NSLayoutRelation,
                        to anchor: ALXAxisAnchor,
                        offset: CGFloat = 0,
                        priority: ALLayoutPriority = .default,
                        active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return leadingAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func left(_ relation: NSLayoutRelation,
                     to view: ALView,
                     offset: CGFloat = 0,
                     priority: ALLayoutPriority = .default,
                     active: Bool = true) -> ALConstraint {
        return left(relation, to: view.leftAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func left(_ relation: NSLayoutRelation,
                     to anchor: ALXAxisAnchor,
                     offset: CGFloat = 0,
                     priority: ALLayoutPriority = .default,
                     active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return leftAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return leftAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return leftAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
}

// MARK: - Right/Trailing
public extension Lollipop {
    @discardableResult
    public func trailing(_ relation: NSLayoutRelation = .equal,
                         to view: Lollipop,
                         offset: CGFloat = 0,
                         priority: ALLayoutPriority = .default,
                         active: Bool = true) -> ALConstraint {
        return trailing(relation, to: view.trailingAnchor, offset: offset, priority: priority, active: active)
    }
    @discardableResult
    public func trailing(_ relation: NSLayoutRelation = .equal,
                         to anchor: ALXAxisAnchor,
                         offset: CGFloat = 0,
                         priority: ALLayoutPriority = .default,
                         active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return trailingAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
    
    @discardableResult
    public func right(_ relation: NSLayoutRelation,
                      to view: Lollipop,
                      offset: CGFloat = 0,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> ALConstraint {
        return right(relation, to: view.rightAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func right(_ relation: NSLayoutRelation,
                      to anchor: ALXAxisAnchor,
                      offset: CGFloat = 0,
                      priority: ALLayoutPriority = .default,
                      active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return rightAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return rightAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return rightAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
}

// MARK: - Top
public extension Lollipop {
    @discardableResult
    public func top(_ relation: NSLayoutRelation,
                    to view: Lollipop,
                    offset: CGFloat = 0,
                    priority: ALLayoutPriority = .default,
                    active: Bool = true) -> ALConstraint {
        return top(relation, to: view.topAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func top(_ relation: NSLayoutRelation,
                    to anchor: ALYAxisAnchor,
                    offset: CGFloat = 0,
                    priority: ALLayoutPriority = .default,
                    active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return topAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return topAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
}

// MARK: - Bottom
public extension Lollipop {
    @discardableResult
    public func bottom(_ relation: NSLayoutRelation,
                       to view: Lollipop,
                       offset: CGFloat = 0,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> ALConstraint {
        return bottom(relation, to: view.bottomAnchor, offset: offset, priority: priority, active: active)
    }
    
    @discardableResult
    public func bottom(_ relation: NSLayoutRelation,
                       to anchor: ALYAxisAnchor,
                       offset: CGFloat = 0,
                       priority: ALLayoutPriority = .default,
                       active: Bool = true) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equal: return bottomAnchor.constraint(equalTo: anchor, constant: offset).priority(priority).active(active)
        case .lessThanOrEqual: return bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        case .greaterThanOrEqual: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset).priority(priority).active(active)
        }
    }
}

// MARK: - Operators
// MARK: EqualTo
infix operator ~
public func ~ (lhs: NSLayoutDimension, rhs: CGFloat) -> ALConstraint { return lhs.constraint(equalToConstant: rhs).active() }
public func ~ (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> ALConstraint { return lhs.constraint(equalTo: rhs).active() }
public func ~ (lhs: ALXAxisAnchor, rhs: ALXAxisAnchor) -> ALConstraint { return lhs.constraint(equalTo: rhs).active() }
public func ~ (lhs: ALYAxisAnchor, rhs: ALYAxisAnchor) -> ALConstraint { return lhs.constraint(equalTo: rhs).active() }

// MARK: GreaterThanOrEqualTo
infix operator >~
public func >~ (lhs: NSLayoutDimension, rhs: CGFloat) -> ALConstraint { return lhs.constraint(greaterThanOrEqualToConstant: rhs).active() }
public func >= (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> ALConstraint { return lhs.constraint(greaterThanOrEqualTo: rhs).active() }
public func >~ (lhs: ALXAxisAnchor, rhs: ALXAxisAnchor) -> ALConstraint { return lhs.constraint(greaterThanOrEqualTo: rhs).active() }
public func >~ (lhs: ALYAxisAnchor, rhs: ALYAxisAnchor) -> ALConstraint { return lhs.constraint(greaterThanOrEqualTo: rhs).active() }

// MARK: LessThanOrEqualTo
infix operator <~
public func <~ (lhs: NSLayoutDimension, rhs: CGFloat) -> ALConstraint { return lhs.constraint(lessThanOrEqualToConstant: rhs).active() }
public func <~ (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> ALConstraint { return lhs.constraint(lessThanOrEqualTo: rhs).active() }
public func <~ (lhs: ALXAxisAnchor, rhs: ALXAxisAnchor) -> ALConstraint { return lhs.constraint(lessThanOrEqualTo: rhs).active() }
public func <~ (lhs: ALYAxisAnchor, rhs: ALYAxisAnchor) -> ALConstraint { return lhs.constraint(lessThanOrEqualTo: rhs).active() }

// MARK: - Hugging/CompressionResistance
public extension ALView {
    public func setHugging(priority: ALLayoutPriority, for axis: ALConstraintAxis) {
        setContentHuggingPriority(priority.rawValue, for: axis)
    }
    
    public func setCompressionResistance(priority: ALLayoutPriority, for axis: ALConstraintAxis) {
        setContentCompressionResistancePriority(priority.rawValue, for: axis)
    }
}

// MARK: - Stack
public extension ALView {
    @discardableResult
    public func stack(_ views: [ALView],
                      axis: ALConstraintAxis = .vertical,
                      width: CGFloat? = nil,
                      height: CGFloat? = nil,
                      spacing: CGFloat = 0) -> [ALConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var offset: CGFloat = 0
        var previous: ALView?
        var constraints: [ALConstraint] = []
        
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            switch axis {
            case .vertical:
                constraints.append(view.top(.equal, to: previous?.bottomAnchor ?? topAnchor, offset: offset))
                constraints.append(view.left(.equal, to: self))
                constraints.append(view.right(.equal, to: self))
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.bottom(.equal, to: self))
                }
            case .horizontal:
                constraints.append(view.top(.equal, to: self))
                constraints.append(view.bottom(.equal, to: self))
                constraints.append(view.left(.equal, to: previous?.rightAnchor ?? leftAnchor, offset: offset))
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.right(.equal, to: self))
                }
            }
            
            if let width = width {
                constraints.append(view.width(.equal, to: width))
            }
            
            if let height = height {
                constraints.append(view.height(.equal, to: height))
            }
            
            offset = spacing
            previous = view
        }
        
        return constraints
    }
}
