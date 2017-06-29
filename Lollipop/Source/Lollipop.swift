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

public enum ALActivation {
    case active, inactive
}

public enum ALConstraintRelation: Int {
    case equalTo = 0
    case lessThanOrEqualTo = -1
    case greaterThanOrEqualTo = 1
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

#if os(OSX)
    public extension EdgeInsets {
        public static var zero = NSEdgeInsetsZero
    }
#endif

public extension Collection where Iterator.Element == ALConstraint {
    public func activate() {
        if let constraints = self as? [ALConstraint] {
            ALConstraint.activate(constraints)
        }
    }
    
    public func deactivate() {
        if let constraints = self as? [ALConstraint] {
            ALConstraint.deactivate(constraints)
        }
    }
}

public extension ALConstraint {
    public func with(priority p: ALConstraintPriority) -> Self {
        priority = p.value
        return self
    }
}

public extension ALConstraint {
    public func set(active: ALActivation) -> Self {
        isActive = (active == .active)
        return self
    }
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
                       offset: ALPoint = .zero,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).with(priority: priority),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).with(priority: priority)
        ]
        
        if isActive == .active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    public func centerX(equalTo view: Lollipop,
                        anchor: ALXAxisAnchor? = nil,
                        offset: ALFloat = 0,
                        priority: ALConstraintPriority = .default,
                        isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        let constraint = centerXAnchor.constraint(equalTo: anchor ?? view.centerXAnchor, constant: offset).with(priority: priority).set(active: isActive)
        return constraint
    }
    
    @discardableResult
    public func centerY(equalTo view: Lollipop,
                        anchor: ALYAxisAnchor? = nil,
                        offset: ALFloat = 0,
                        priority: ALConstraintPriority = .default,
                        isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        let constraint = centerYAnchor.constraint(equalTo: anchor ?? view.centerYAnchor, constant: offset).with(priority: priority).set(active: isActive)
        return constraint
    }
}

// MARK: - Edge
public extension Lollipop {
    @discardableResult
    public func edges(equalTo view: Lollipop,
                      insets: ALEdgeInsets = .zero,
                      priority: ALConstraintPriority = .default,
                      isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).with(priority: priority),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).with(priority: priority),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).with(priority: priority),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).with(priority: priority)
        ]
        
        if isActive == .active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Size/Origin
public extension Lollipop {
    @discardableResult
    public func size(equalTo size: ALSize,
                     priority: ALConstraintPriority = .default,
                     isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width).with(priority: priority),
            heightAnchor.constraint(equalToConstant: size.height).with(priority: priority)
        ]
        
        if isActive == .active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    public func origin(equalTo view: Lollipop,
                       insets: ALVector = .zero,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        let constraints = [
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.dx).with(priority: priority),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.dy).with(priority: priority)
        ]
        
        if isActive == .active {
            ALConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - Width
public extension Lollipop {
    @discardableResult
    public func width(_ relation: ALConstraintRelation,
                      _ width: ALFloat,
                      priority: ALConstraintPriority = .default,
                      isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return widthAnchor.constraint(equalToConstant: width).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return widthAnchor.constraint(lessThanOrEqualToConstant: width).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return widthAnchor.constraint(greaterThanOrEqualToConstant: width).with(priority: priority).set(active: isActive)
        }
    }

    @discardableResult
    public func width(_ relation: ALConstraintRelation,
                      _ view: Lollipop,
                      dimension: NSLayoutDimension? = nil,
                      multiplier: ALFloat = 1,
                      offset: ALFloat = 0,
                      priority: ALConstraintPriority = .default,
                      isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return widthAnchor.constraint(lessThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return widthAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
    
    @discardableResult
    public func width(between range: ALRange? = nil,
                      priority: ALConstraintPriority = .default,
                      isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        var constraints: [ALConstraint] = []
        
        if let min = range?.min {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority: priority).set(active: isActive)
            constraints.append(constraint)
        }
        
        if let max = range?.max {
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: max).with(priority: priority).set(active: isActive)
            constraints.append(constraint)
        }
        
        return constraints
    }
}

// MARK: - Height
public extension Lollipop {
    @discardableResult
    public func height(_ relation: ALConstraintRelation,
                       _ height: ALFloat,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return heightAnchor.constraint(equalToConstant: height).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return heightAnchor.constraint(lessThanOrEqualToConstant: height).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return heightAnchor.constraint(greaterThanOrEqualToConstant: height).with(priority: priority).set(active: isActive)
        }
    }
    
    @discardableResult
    public func height(_ relation: ALConstraintRelation,
                       _ view: Lollipop,
                       dimension: NSLayoutDimension? = nil,
                       multiplier: ALFloat = 1,
                       offset: ALFloat = 0,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return heightAnchor.constraint(lessThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return heightAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
    
    @discardableResult
    public func height(between range: ALRange? = nil,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> [ALConstraint] {
        prepareForLayoutIfNeeded()
        
        var constraints: [ALConstraint] = []
        
        if let min = range?.min {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority: priority).set(active: isActive)
            constraints.append(constraint)
        }
        
        if let max = range?.max {
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: max).with(priority: priority).set(active: isActive)
            constraints.append(constraint)
        }
        
        return constraints
    }
}

// MARK: - Left/Leading
public extension Lollipop {
    @discardableResult
    public func leading(_ relation: ALConstraintRelation,
                        _ view: Lollipop,
                        anchor: ALXAxisAnchor? = nil,
                        offset: ALFloat = 0,
                        priority: ALConstraintPriority = .default,
                        isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return leadingAnchor.constraint(equalTo: anchor ?? view.leadingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return leadingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
    
    @discardableResult
    public func left(_ relation: ALConstraintRelation,
                     _ view: Lollipop,
                     anchor: ALXAxisAnchor? = nil,
                     offset: ALFloat = 0,
                     priority: ALConstraintPriority = .default,
                     isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return leftAnchor.constraint(equalTo: anchor ?? view.leftAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return leftAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return leftAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
}

// MARK: - Right/Trailing
public extension Lollipop {
    @discardableResult
    public func trailing(_ relation: ALConstraintRelation = .equalTo,
                         _ view: Lollipop,
                         anchor: ALXAxisAnchor? = nil,
                         offset: ALFloat = 0,
                         priority: ALConstraintPriority = .default,
                         isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return trailingAnchor.constraint(equalTo: anchor ?? view.trailingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return trailingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
    
    @discardableResult
    public func right(_ relation: ALConstraintRelation,
                      _ view: Lollipop,
                      anchor: ALXAxisAnchor? = nil,
                      offset: ALFloat = 0,
                      priority: ALConstraintPriority = .default,
                      isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return rightAnchor.constraint(equalTo: anchor ?? view.rightAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return rightAnchor.constraint(lessThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return rightAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
}

// MARK: - Top
public extension Lollipop {
    @discardableResult
    public func top(_ relation: ALConstraintRelation,
                    _ view: Lollipop,
                    anchor: ALYAxisAnchor? = nil,
                    offset: ALFloat = 0,
                    priority: ALConstraintPriority = .default,
                    isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return topAnchor.constraint(equalTo: anchor ?? view.topAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return topAnchor.constraint(lessThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return topAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
}

// MARK: - Bottom
public extension Lollipop {
    @discardableResult
    public func bottom(_ relation: ALConstraintRelation,
                       _ view: Lollipop,
                       anchor: ALYAxisAnchor? = nil,
                       offset: ALFloat = 0,
                       priority: ALConstraintPriority = .default,
                       isActive: ALActivation = .active) -> ALConstraint {
        prepareForLayoutIfNeeded()
        
        switch relation {
        case .equalTo: return bottomAnchor.constraint(equalTo: anchor ?? view.bottomAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .lessThanOrEqualTo: return bottomAnchor.constraint(lessThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority: priority).set(active: isActive)
        case .greaterThanOrEqualTo: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority: priority).set(active: isActive)
        }
    }
}

// MARK: - Hugging/CompressionResistance
public extension ALView {
    public func setHugging(priority: ALConstraintPriority, for axis: ALConstraintAxis) {
        setContentHuggingPriority(priority.value, for: axis)
    }
    
    public func setCompressionResistance(priority: ALConstraintPriority, for axis: ALConstraintAxis) {
        setContentCompressionResistancePriority(priority.value, for: axis)
    }
}

// MARK: - Stack
public extension ALView {
    @discardableResult
    public func stack(_ views: [ALView],
                      axis: ALConstraintAxis = .vertical,
                      width: ALFloat? = nil,
                      height: ALFloat? = nil,
                      spacing: ALFloat = 0) -> [ALConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var offset: ALFloat = 0
        var previous: ALView?
        var constraints: [ALConstraint] = []
        
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            switch axis {
            case .vertical:
                constraints.append(view.top(.equalTo, previous ?? self, anchor: previous?.bottomAnchor ?? topAnchor, offset: offset))
                constraints.append(view.left(.equalTo, self))
                constraints.append(view.right(.equalTo, self))
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.bottom(.equalTo, self))
                }
            case .horizontal:
                constraints.append(view.top(.equalTo, self))
                constraints.append(view.bottom(.equalTo, self))
                constraints.append(view.left(.equalTo, previous ?? self, anchor: previous?.rightAnchor ?? leftAnchor, offset: offset))
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.right(.equalTo, self))
                }
            }
            
            if let width = width {
                constraints.append(view.width(.equalTo, width))
            }
            
            if let height = height {
                constraints.append(view.height(.equalTo, height))
            }
            
            offset = spacing
            previous = view
        }
        
        return constraints
    }
}
