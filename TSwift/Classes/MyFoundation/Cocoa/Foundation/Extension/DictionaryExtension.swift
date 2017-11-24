//
//  DictionaryExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

extension Dictionary {
    
    var jsDictionaryString: String {
        
        var result = "{"
        for (key, value) in self {
            
            if result != "{" { result += "," }
            result += "\"\(key)\":`\(value)`"
        }
        result += "}"
        return result
    }
}
