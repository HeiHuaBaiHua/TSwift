//
//  ErrorView.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/23.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

protocol ErrorViewProtocol {
    
    var errorImageView: UIImageView! { get }
    var errorTextButton: UIButton! { get }
    var isHidden: Bool{ set get }
    
    func setError(_ error: Error)
}

class ErrorView: UIView {

    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorTextButton: UIButton!
}

extension ErrorView: ErrorViewProtocol {
    
    func setError(_ error: Error) {
        
        func attributedText(_ prefixText: String, _ suffixText: String) -> NSMutableAttributedString {
            
            let prefixTextColor = UIColor(r: 126, g: 132, b: 145, a: 1)
            let suffixTextColor = UIColor(r: 86, g: 162, b: 247, a: 1)
            let attributedText = NSMutableAttributedString(string: prefixText, attributes: [NSForegroundColorAttributeName: prefixTextColor])
            attributedText.append(NSAttributedString(string: suffixText, attributes: [NSForegroundColorAttributeName: suffixTextColor, NSUnderlineStyleAttributeName: 1, NSUnderlineColorAttributeName: suffixTextColor]))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, attributedText.length))
            return attributedText;
        }
        
        var errorCode = TaskError.default.rawValue
        if let error = error as? APIError {
            errorCode = error.code
        }
        
        errorTextButton.isUserInteractionEnabled = true
        switch (errorCode) {
            
        case TaskError.noData.rawValue:
            errorTextButton.isUserInteractionEnabled = false
            errorTextButton.title = "暂无数据"
            errorTextButton.setAttributedTitle(nil, for: .normal)
            errorImageView.image = "UI_errorNoData".image;
        
        case TaskError.noNetwork.rawValue:
            errorTextButton.title = nil
            errorTextButton.setAttributedTitle(attributedText("没有网络, ", "点击重试"), for: .normal)
            errorImageView.image = "UI_errorNoNetwork".image;
            
        default:
            errorTextButton.title = nil
            errorTextButton.setAttributedTitle(attributedText("加载失败, ", "点击重试"), for: .normal)
            errorImageView.image = "UI_errorDefault".image;
        }
    }
}

