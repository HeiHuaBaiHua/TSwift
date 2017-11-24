//
//  WeiboCellInfoView.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboCellInfoView: UIView {
    private let dealloc = DeinitLogItem(self)

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var vipImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var levelImageView: UIImageView!
    
    @IBOutlet weak var sendDateLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
}
