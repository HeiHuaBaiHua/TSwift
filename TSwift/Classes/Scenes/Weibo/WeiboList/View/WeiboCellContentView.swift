//
//  WeiBoCellContentView.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import YYText
import SnapKit

class WeiboCellContentView: UIView {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealloc = DeinitLogItem(self)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
        configuration()
    }
    
//MARK: Utils
    
    private func configuration() {
        backgroundColor = UIColor.white
    }
    
    private func layoutUI() {
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Interval)
            make.left.equalTo(self).offset(Interval)
            make.right.equalTo(self).offset(-Interval)
        }
        
        let imageHeight = (ScreenWidth - Interval * 4) / 3
        for (idx, imageView) in imageButtons.enumerated() {
            addSubview(imageView)
            
            let top = (imageHeight + Interval) * CGFloat(idx / 3) + Interval
            let left = (imageHeight + Interval) * CGFloat(idx % 3) + Interval
            imageButtons[idx].snp.makeConstraints({ (make) in
                
                make.top.equalTo(textLabel.snp.bottom).offset(top)
                make.left.equalTo(self).offset(left)
                make.size.equalTo(CGSize(width: imageHeight, height: imageHeight))
            })
        }
    }
    
//MARK: Getter
    
    lazy var textLabel: YYLabel = {
        
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = ScreenWidth - Interval * 2
        return $0
    }(YYLabel())
    
    lazy var imageButtons: [UIButton] = {
       
        var imageButtons = [UIButton]()
        for i in 0...8 {
            
            let imageButton = UIButton(type: .custom)
            imageButton.tag = i
            imageButton.imageView?.contentMode = .scaleAspectFill
            imageButton.contentVerticalAlignment = .fill
            imageButton.contentHorizontalAlignment = .fill
            imageButton.layer.masksToBounds = true
            imageButtons.append(imageButton)
        }
        return imageButtons
    }()
}
