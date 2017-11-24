//
//  UIExtension.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import MBProgressHUD

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let ScreenBounds = UIScreen.main.bounds

let NavBarHeight: CGFloat = 44
let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
let TopBarHeight = StatusBarHeight + NavBarHeight

let ScreenMinusTopHeight = ScreenHeight - TopBarHeight
let ScreenMinusTopBounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenMinusTopHeight)

let Interval: CGFloat = 10
let InitialTag: Int = 101

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
    }
    
    
    public var left: CGFloat {
        
        get {
            return self.frame.origin.x
        }
        set {
            
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
        
    }
    
    public var right: CGFloat {
        
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            
            var temp = self.frame
            temp.origin.x = newValue - temp.size.width
            self.frame = temp
        }
        
    }
    
    public var top: CGFloat {
        
        get {
            return self.frame.origin.y
        }
        set {
            
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
        
    }
    
    
    public var bottom: CGFloat {
        
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            
            var temp = self.frame
            temp.origin.y = newValue - self.frame.size.height
            self.frame = temp
        }
        
    }
    
    public var width: CGFloat {
        
        get {
            return self.frame.size.width
        }
        set {
            
            var temp = self.frame
            temp.size.width = newValue
            self.frame = temp
        }
        
    }
    
    public var height: CGFloat {
        
        get {
            return self.frame.size.height
        }
        set {
            
            var temp = self.frame
            temp.size.height = newValue
            self.frame = temp
        }
        
    }
    
    public var origin: CGPoint {
        
        get {
            return self.frame.origin
        }
        set {
            
            var temp = self.frame
            temp.origin = newValue
            self.frame = temp
        }
        
    }
}

//MARK: IB
extension UIView {
    
    static func IBInstance<T: UIView>() -> T {
        let className = self.description().components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first! as! T
    }
}

//MARK: ViewController
extension UIView {
    
    var viewController: UIViewController? {
        
        var nextResponder = next
        while nextResponder != nil {
            if let vc = nextResponder as? UIViewController {
                
                if  vc.navigationController != nil ||
                    vc.presentingViewController != nil ||
                    vc.tabBarController != nil {
                    return vc
                } else {
                    nextResponder = vc.view.superview
                }
            }
            nextResponder = nextResponder!.next
        }
        return nil
    }
    
    var navigationController: UINavigationController? {
        return self.viewController?.navigationController
    }
}

//MARK: Toast
extension UIView {
    func toast(_ text: String) {
        
        guard text.count > 0,
            let window = UIApplication.shared.keyWindow else {
                return
        }
        
        let toast = MBProgressHUD.showAdded(to: window, animated: true)
        toast?.mode = .text
        toast?.labelText = text
        toast?.labelColor = UIColor.white
        toast?.hide(true, afterDelay: 1.5)
    }
}

//MARK: HUD
extension UIView {
    func showHUD(_ text: String? = nil) {
        
        var HUD = viewWithTag(131) as? MBProgressHUD
        HUD?.hide(true)
        if HUD === nil {
            HUD = MBProgressHUD(view: self)
            HUD?.mode = .indeterminate
            HUD?.labelColor = UIColor.white
            HUD?.tag = 131
        }
        
        HUD?.labelText = text
        addSubview(HUD!)
        HUD?.show(true)
    }
    
    func hideHUD() {
        if let HUD = viewWithTag(131) as? MBProgressHUD {
            HUD.hide(true)
        }
    }
}
