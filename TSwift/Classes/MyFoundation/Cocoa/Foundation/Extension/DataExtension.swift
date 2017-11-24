//
//  DataExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/7.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Data {
    
    public var string: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }

    public var image: UIImage? {
        return UIImage(data: self)
    }
}
