//
//  UIColorExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat,a: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    public convenience init(hex: UInt32) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
                  blue: CGFloat((hex & 0xFF)) / 255.0,
                  alpha: 1.0)
    }
    
    public var image: UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(rect)
        let image = context?.makeImage()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!)
    }
}
