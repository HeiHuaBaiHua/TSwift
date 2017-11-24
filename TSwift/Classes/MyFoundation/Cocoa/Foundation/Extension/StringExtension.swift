//
//  StringExtension.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension String {
    
    public func size(boundingSize: CGSize, fontSize: CGFloat) -> CGSize {
        
        let text = self as NSString
        return text.boundingRect(with: boundingSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil).size
    }
    
    public func substring(to toIndex: Int) -> String {
        guard toIndex < count else {
            return self
        }
        
        return substring(to: index(startIndex, offsetBy: toIndex))
    }
    
    public func substring(from fromIndex: Int) -> String {
        guard fromIndex < count else {
            return self
        }
        
        return substring(from: index(startIndex, offsetBy: fromIndex))
    }
    
    public func substring(range: NSRange) -> String {
        guard range.location + range.length <= count else {
            return self
        }

        let begin = index(startIndex, offsetBy: range.location)
        let end = index(begin, offsetBy: range.length)
        return self[begin..<end];
    }
}

extension String {
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    public var image: UIImage? {
        return UIImage(named: self)
    }
    
    public var isValidPhoneNum: Bool {
        
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         */
        let cm = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,185,186
         */
        let cu = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        
        /**
         * 中国电信：China Telecom
         * 133,1349,153,180,189
         */
        let ct = "^1((33|53|8[09])[0-9]|349)\\d{7}$"

        return NSPredicate(format: "SELF MATCHES %@", mobile).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", cm).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", cu).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", ct).evaluate(with: self)
    }
}
