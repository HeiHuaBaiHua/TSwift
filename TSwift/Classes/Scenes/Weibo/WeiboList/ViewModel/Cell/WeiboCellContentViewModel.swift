//
//  WeiboCellContentViewModel.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import YYText
import ReactiveSwift
import ReactiveCocoa
import MWPhotoBrowser

class WeiboCellContentViewModel {
    private let dealloc = DeinitLogItem(WeiboCellContentViewModel.self)

    private(set) var weibo: Weibo
    private(set) var contentHeight: CGFloat!
    
    private(set) var text: Property<NSAttributedString>!
    private(set) var imageUrls: [URL?]?
    private(set) var largeImageUrls: [MWPhoto]?
    
    var onClickHrefHandler: ((WeiboHrefType) -> ())?
    init(weibo: Weibo) {
        
        self.weibo = weibo
        
        formatText()
        formatImage()
        calculateContentHeight()
    }
    
//MARK: Utils

    private func formatImage() {
        guard let pictures = weibo.picUrls else {
            return
        }
        
        if !pictures.isEmpty {
            
            imageUrls = []
            largeImageUrls = []
            for picUrl in pictures {
                
                let urlString = picUrl["thumbnail_pic"]
                imageUrls?.append(urlString?.replacingOccurrences(of: "thumbnail", with: "bmiddle").url)
                largeImageUrls?.append(MWPhoto(url: urlString?.replacingOccurrences(of: "thumbnail", with: "large").url))
            }
        }
    }
    
    private func formatText()  {
        
        var links = [NSRange]()
        if let txt = weibo.text {
            
            func regex(_ pattern: String) {
                
                if let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) {
                    let matchs = regex.matches(in: txt, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, txt.count))
                    for match in matchs {
                        links.append(match.range)
                    }
                }
            }
            
            regex("#[^#]+#")
            regex("@[^ ]+ ")
            regex("\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?")
        }
        
        let text = NSMutableAttributedString(string: weibo.text ?? "")
        text.yy_font = UIFont.systemFont(ofSize: 17)
        text.yy_color = UIColor(hex: 0x333333)
        text.yy_maximumLineHeight = 20
        text.yy_minimumLineHeight = 20
        for range in links {
            
            text.yy_setTextHighlight(range, color: UIColor(hex: 0x007AFF), backgroundColor: UIColor.clear, userInfo: nil, tapAction: {[weak self] (_, text, range, _) in
                
                let href = text.string.substring(range: range).replacingOccurrences(of: "...", with: "")
                if href.hasPrefix("http") {
                    self?.onClickHrefHandler?(.url(href))
                } else if href.hasPrefix("#") {
                    
                    let topic = href.substring(range: NSMakeRange(1, href.count - 2))
                    self?.onClickHrefHandler?(.topic(topic))
                } else if href.hasPrefix("@") {
                    
                    let nickname = href.substring(range: NSMakeRange(1, href.count - 2))
                    self?.onClickHrefHandler?(.nickname(nickname))
                }
            }, longPressAction: nil)
        }
        self.text = Property(value: text)
    }
    
    private func calculateContentHeight() {
        
        let textHeight = (weibo.text != nil) ? weibo.text!.size(boundingSize: CGSize(width: ScreenWidth - 2 * Interval, height: 999), fontSize: 17).height : 0
        contentHeight = Interval + textHeight
        if let pictures = weibo.picUrls, !pictures.isEmpty {
            
            var imageRows = imageUrls!.count / 3
            imageRows += ((imageUrls!.count % 3) != 0 ? 1 : 0)
            let imageHeight = (ScreenWidth - Interval * 4) / 3
            contentHeight = contentHeight + ((imageHeight + Interval) * CGFloat(imageRows))
        }
    }
}
