//
//  TabBarController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        
        layoutUI()
        configuration()
    }
    
//MARK: Utils
    private func layoutUI() {
        
        func configTabBarItem(_ item: UITabBarItem, _ title: String ,_ noramlImage: String, _ selectedImage: String) {
            
            item.title = title
            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .normal)
            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .selected)
            
            item.image = noramlImage.image?.withRenderingMode(.alwaysOriginal)
            item.selectedImage = selectedImage.image?.withRenderingMode(.alwaysOriginal)
        }
        
        let weiboNavVC = UIBuilder.navigationController(rootVC: Router.tempVC(onClickHandler: {
            Router.pushToWeiboListVC()
        }))
        let chatNavVC = UIBuilder.navigationController(rootVC: Router.tempVC(onClickHandler: {
            self.toast("留个坑 后天写")
        }))
        let composeNavVC = UIBuilder.navigationController(rootVC: Router.tempVC(onClickHandler: {
            self.toast("留个坑 后天写")
        }))
        let musicNavVC = UIBuilder.navigationController(rootVC: Router.tempVC(onClickHandler: {
            self.toast("留个坑 后天写")
        }))
        let profileNavVC = UIBuilder.navigationController(rootVC: Router.tempVC(onClickHandler: {
            Router.pushToRegisterVC()
        }))
        viewControllers = [weiboNavVC, chatNavVC, composeNavVC, musicNavVC, profileNavVC]
        
        let itemConfig = [("微博", "tabbar_home", "tabbar_home_selected"),
                          ("消息","tabbar_message_center", "tabbar_message_center_selected"),
                          ("","tabbar_compose_background_icon_add", "tabbar_compose_background_icon_add"),
                          ("音乐","tabbar_discover", "tabbar_discover_selected"),
                          ("我","tabbar_profile", "tabbar_profile_selected")];
        for i in 0..<viewControllers!.count {
            
            let vc = viewControllers![i] as! UINavigationController
            vc.navigationBar.isTranslucent = false
            configTabBarItem((vc.tabBarItem)!, itemConfig[i].0, itemConfig[i].1, itemConfig[i].2)
        }
    }
    
    private func configuration() {
        
        selectedIndex = 0
        tabBar.isTranslucent = false
    }
}
