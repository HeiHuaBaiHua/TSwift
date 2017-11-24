//
//  TempViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    var onClickHandler: () -> ()
    
    init(onClickHandler: @escaping () -> ()) {
        
        self.onClickHandler = onClickHandler
        super.init(nibName: nil, bundle: nil)
        
        view = UIView(frame: ScreenBounds)
        view.backgroundColor = UIColor(hex: 0xe5e5e5)
        
        let button = self.button
        view.addSubview(button)
        button.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.onClickHandler()
        }
    }
    
    private var button: UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 200, width: ScreenWidth, height: 100)
        button.title = "点一下"
        button.setTitleColor(UIColor.purple, for: .normal)
        return button
    }
}
