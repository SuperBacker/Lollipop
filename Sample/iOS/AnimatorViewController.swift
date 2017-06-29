//
//  AnimatorViewController.swift
//  LollipopSample
//
//  Created by Meniny on 2017-06-29.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit

class AnimatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setColor(UIColor.white)
        addStack(self.stack, to: self.view)
    }
    
    var timer: Timer!
    var stack = Stack()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.stack.update()
        }
    }
}
