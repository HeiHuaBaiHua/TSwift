//
//  ProfileViewController.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我"
        view.backgroundColor = UIColor.white
    }
    
    @IBAction func onClickRegisterButton(_ sender: UIButton) {
        Router.pushToRegisterVC()
    }
    
    @IBAction func onClickLoginButton(_ sender: UIButton) {
        Router.pushToLoginVC()
    }
    
    @IBAction func onClickLogoutButton(_ sender: UIButton) {
        SinaAPIManager().revokeSinaOauth(token: UserDefaults.sinaToken).start()
    }
}
