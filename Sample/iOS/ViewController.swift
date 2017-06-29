//
//  ViewController.swift
//  iOS
//
//  Created by Meniny on 2017-06-29.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.setColor(UIColor.white)
        addItems(to: self.view)
        
        let next = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(showNext))
        self.navigationItem.rightBarButtonItem = next
    }
    
    func showNext() {
        let next = AnimatorViewController()
        self.navigationController?.pushViewController(next, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

