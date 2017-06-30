//
//  Common.swift
//  LollipopSample
//
//  Created by Meniny on 2017-06-29.
//  Copyright © 2017年 Meniny. All rights reserved.
//

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

public extension Controller {
    public func addItems(to v: ALView) {
        let max = 10
        for i in 1...max {
            let value: CGFloat = 1 - CGFloat(i) / CGFloat(max)
            let item = ALView()
            item.setColor(Color(red: value, green: value, blue: value, alpha: 1.0))
            v.addSubview(item)
            item.width(.equal, to: v, multiplier: value)
            item.height(.equal, to: item.widthAnchor)
            item.center(in: v)
        }
    }
    #if os(macOS)
    #else
    public func addStack(_ stack: Stack, to view: ALView) {
        view.addSubview(stack)
        stack.width(.equal, to: view)
        stack.height(.equal, to: view)
        stack.center(in: view)
    }
    #endif
}

public extension ALView {
    public func setColor(_ color: Color) {
        #if os(OSX)
            self.wantsLayer = true
            self.layer?.backgroundColor = color.cgColor
        #else
            self.backgroundColor = color
        #endif
    }
}

#if os(macOS)
#else
public class Stack: ALView {
    var lastBottomConstraint: ALConstraint?
    var lastSubview: ALView?
    let margin: CGFloat = 20
    var counter = 0
    var heights: [ALConstraint] = []
    var container = ALView()
    
    convenience init() {
        self.init(frame: .zero)
        addSubview(container)
        container.width(.equal, to: self.widthAnchor)
        container.height(from: 200, to: nil)
        container.height(.equal, to: 200, priority: .low)
        container.center(in: self)
    }
    
    func appendRect() {
        let color = Color(red:0.13, green:0.45, blue:0.33, alpha:1.00)
        
        let sub = ALView()
        sub.setColor(color)
        sub.setHugging(priority: .low, for: .vertical)
        sub.setCompressionResistance(priority: .high, for: .vertical)
        container.addSubview(sub)
        
        sub.top(.equal, to: lastSubview?.bottomAnchor ?? container.topAnchor, offset: margin)
        sub.left(.equal, to: container, offset: margin)
        sub.right(.equal, to: container, offset: -margin)
        
        layoutIfNeeded()
        
        heights.append(sub.height(.equal, to: lastSubview ?? container, priority: .low))
        heights.append(contentsOf: sub.height(from: 100, to: 200, priority: .high))
        
        lastBottomConstraint?.isActive = false
        lastBottomConstraint = sub.bottom(.lessThanOrEqual, to: container, offset: -margin)
        lastSubview = sub
        counter += 1
    }
    
    public func collapse() {
        heights.forEach { $0.constant = 0 }
        counter = 0
        UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.7) { [weak self] in
            self?.container.subviews.forEach {
                $0.alpha = 0
            }
            }.startAnimation()
    }
    
    public func reset() {
        container.subviews.forEach { $0.removeFromSuperview() }
        heights.removeAll()
        lastSubview = nil
        lastBottomConstraint = nil
    }
    
    public func update() {
        if counter >= 4 {
            collapse()
        } else {
            if counter == 0 {
                reset()
            }
            appendRect()
        }
        
        UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7) { [weak self] in
            self?.layoutIfNeeded()
            }.startAnimation()
    }
}
#endif
