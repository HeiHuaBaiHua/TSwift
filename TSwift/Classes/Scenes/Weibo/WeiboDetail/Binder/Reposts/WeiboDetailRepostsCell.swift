//
//  WeiboDetailRepostsCell.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailRepostsCell: UITableViewCell {

    var viewModel: WeiboDetailRepostsCellViewModel! {
        didSet {
            
            textLabel?.text = viewModel.text
            imageView?.image = viewModel.image
        }
    }
}
