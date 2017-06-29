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
    
    typealias Color = NSColor
#else
    import UIKit
    
    typealias Color = UIColor
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
