//
//  CCNavigationController.swift
//  SwiftCode
//
//  Created by zerocc on 2019/9/26.
//  Copyright © 2019 zerocc. All rights reserved.
//

import UIKit

class CCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count>0) {
            viewController.hidesBottomBarWhenPushed = true
            viewController.view.backgroundColor = UIColor.white
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
}
