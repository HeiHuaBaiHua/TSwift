//
//  WeiboContentController.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import ReactiveSwift
import ReactiveCocoa
import MWPhotoBrowser

class WeiboCellContentBinder: UIViewController {
    private let dealloc = DeinitLogItem(self)

    override func loadView() {
        
        layoutUI()
        configuration()
    }
    
    var viewModel: WeiboCellContentViewModel! {
        didSet {
            
            let view = self.view as! WeiboCellContentView
            view.textLabel.reactive.attributedText <~ viewModel.text
            let imageCount = viewModel.imageUrls?.count ?? 0
            for idx in 0...8 {
                
                let isHidden = (idx >= imageCount)
                view.imageButtons[idx].isHidden = isHidden
                if !isHidden {
                    view.imageButtons[idx].kf.setImage(with: viewModel.imageUrls?[idx], for:.normal)
                }
            }
            
            viewModel.onClickHrefHandler = { (href) in
                switch href {
                case .url(let url):
                    Router.pushToWebVC(url: url)
                case .topic(let topic):
                    print(topic)
                case .nickname(let nickname):
                    print(nickname)
                }
            }
        }
    }
}

//MARK: MWPhotoBrowserDelegate
extension WeiboCellContentBinder: MWPhotoBrowserDelegate {
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(viewModel.largeImageUrls!.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return viewModel.largeImageUrls![Int(index)]
    }
}

//MARK: Action
extension WeiboCellContentBinder {
    
    func onClickImageButton(sender: UIButton) {
        
        let photoBrowser = MWPhotoBrowser(delegate: self)!
        photoBrowser.setCurrentPhotoIndex(UInt(sender.tag))
        view.navigationController?.pushViewController(photoBrowser, animated: true)
    }
}

//MARK: Utils
extension WeiboCellContentBinder {
    
    fileprivate func layoutUI() {
        view = WeiboCellContentView(frame: .zero)
    }
    
    fileprivate func configuration() {
        
        let view = self.view as! WeiboCellContentView
        for imageButton in view.imageButtons {
            imageButton.addTarget(self, action: #selector(onClickImageButton(sender:)), for: .touchUpInside)
        }
    }
}
