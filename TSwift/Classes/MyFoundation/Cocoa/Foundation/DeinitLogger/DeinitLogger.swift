//
//  DeinitLogger.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

class DeinitLogItem {
    var className: String = ""
    init(_ item: Any) {
        
        var className = String(describing: type(of: item))
//        print(className)
        className = className.components(separatedBy: " ").last!
        className = className.components(separatedBy: ".").first!
        self.className = className
    }
    
    deinit {
        DeinitLogger.pushClass(className)
    }
}

class DeinitLogger {
    
    static var hasController = false
    static var logLevel_1 = [String]()
    static var logLevel_2 = [String]()
    static var logLevel_3 = [String]()
    
    static func pushClass(_ className: String) {
        
        let isCell = className.lowercased().contains("cell") || className.hasSuffix("ItemView")
        if className.hasSuffix("Binder") || className.hasSuffix("Cell") {
            
            if isCell && logLevel_1.contains(className) { return }
            logLevel_1.append(className)
        } else if className.hasSuffix("View") {
            
            if isCell && logLevel_2.contains(className) { return }
            logLevel_2.append(className)
        } else if className.hasSuffix("ViewModel") {
            
            if isCell && logLevel_3.contains(className) { return }
            logLevel_3.append(className)
        } else if className.hasSuffix("Controller") {
            
            hasController = true
            logClass(className, 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                hasController = false
                
                for itemName in logLevel_1 { logClass(itemName, 1) }
                for itemName in logLevel_2 { logClass(itemName, 2) }
                for itemName in logLevel_3 { logClass(itemName, 3) }
                logLevel_1.removeAll(); logLevel_2.removeAll(); logLevel_3.removeAll()
                logClass(className, 0)
            })
        }
    }

    static func logClass(_ className: String, _ level: Int) {
        
        switch level {
        case 0:
            print("********************************************\(className)********************************************")
        case 1:
            print("|----------\(className)")
        case 2:
            print("|--------------------\(className)")
        case 3:
            print("|------------------------------\(className)")
        default: break
        }
    }
}


