//
//  ViewController.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton()
        self.view.addSubview(button)
        button.setTitle("展示相册", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: button.frame.size)
        button.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        
    }
    
    @objc func action(button: UIButton) {
        
        let nav = ETNavigationController.init(rootViewController: ETPhotoBrower())
        self.present(nav, animated: true) {
            
        }
        
        
    }


}

