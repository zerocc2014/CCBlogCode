//
//  CCTabBarController.swift
//  SwiftCode
//
//  Created by zerocc on 2019/9/26.
//  Copyright © 2019 zerocc. All rights reserved.
//

import UIKit

class CCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        addChildController()
    }
    
    private func addChildController() {
        addOneChlildVc(CCSwiftVC(), title: "Swift", normalImage: "tabbar_home", selectedImage: "tabbar_home_selected")
        addOneChlildVc(CCThirdPartyAnalyzeVC(), title: "Analyze", normalImage: "tabbar_home", selectedImage: "tabbar_home_selected")
        addOneChlildVc(CCKitVC(), title: "CCKit", normalImage: "tabbar_home", selectedImage: "tabbar_home_selected")
        addOneChlildVc(CCAlgorithmVC(), title: "Algorithm", normalImage: "tabbar_home", selectedImage: "tabbar_home_selected")
    }
    
    private func addOneChlildVc(_ childVc:UIViewController,title:String, normalImage:String, selectedImage:String){
        childVc.title = title
        childVc.view.backgroundColor = UIColor.white
        childVc.tabBarItem.image = UIImage(named:normalImage)
        childVc.tabBarItem.selectedImage = UIImage(named:selectedImage)
        let navigationController = CCNavigationController(rootViewController:childVc)
        addChild(navigationController)
    }
    
    
}







