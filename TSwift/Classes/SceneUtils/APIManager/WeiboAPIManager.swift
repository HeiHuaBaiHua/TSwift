//
//  WeiboAPIManager.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import HandyJSON

import Result
import ReactiveSwift
import ReactiveCocoa

//https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00mlsQHD08Vxev42b5b459d8Z2yhDB&page=1&count=20

private let CachedWeiboList: [[[String: Any]]] = {
   
    let filePath = Bundle.main.path(forResource: "weibo", ofType: "plist")!
    return NSArray.init(contentsOfFile: filePath) as! [[[String: Any]]]
}()

class WeiboAPIManager: HTTPAPIManager {
    
    //MARK: 微博列表
    @discardableResult
    func homeTimeLineProducer(page: Int, pageSize: Int) -> APIProducer<[Weibo]?> {
        
//        let config = HTTPDataTaskConfiguration(
//            urlPath: "/statuses/home_timeline.json",
//            parameters: ["page": page,
//                         "count": pageSize,
//                         "access_token": "..."]
//        )
//        return arrayProducer(configuration: config, deserializePath: "statuses")
        
        let page = max(0, page - 1)
        return APIProducer({ (observer, _) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
                
                if page >= CachedWeiboList.count {
                    observer.send(error: APIError(.noMoreData))
                } else {
                    observer.send(value: ([Weibo].deserialize(from: CachedWeiboList[page]) as! [Weibo]))
                    observer.sendCompleted()
                }
            })
        })
    }

    //MARK: 某条微博的转发列表
    func weiboRepostListProducer(id: String, page: Int, pageSize: Int) -> APIProducer<[Weibo]?> {
        guard page < 3 else {
            return APIProducer(error: APIError( .noMoreData))
        }
        
        var result = [Weibo]()
        for i in 0..<20 {
            
            let repost = Weibo()
            repost.id = String(i + (page - 1) * 20)
            result.append(repost)
        }
        return APIProducer({ (observer, _) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                observer.send(value: result)
                observer.sendCompleted()
            })
        })
    }

    //MARK: 某条微博的评论列表
    func weiboCommentListProducer(id: String, page: Int, pageSize: Int) -> APIProducer<[WeiboComment]?> {
        
        guard page < 3 else {
            return APIProducer(error: APIError( .noMoreData))
        }
        
        var result = [WeiboComment]()
        for i in 0..<20 {
            
            let comment = WeiboComment()
            comment.id = String(i + (page - 1) * 20)
            result.append(comment)
        }
        return APIProducer({ (observer, _) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                observer.send(value: result)
                observer.sendCompleted()
            })
        })
    }
    
    //MARK: 某条微博的点赞列表
    func weiboLikeListProducer(id: String, page: Int, pageSize: Int) -> APIProducer<[User]?> {
        return APIProducer(error: APIError( .noData))
    }
    
    //MARK: 给某条微博点赞/取消赞
    func switchLikeStatusProducer(id: String) -> AnyAPIProducer {
        return AnyAPIProducer({ (observer, _) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                if arc4random() % 2 == 1 {
                    observer.send(error: APIError("操作失败~"))
                } else {
                    observer.send(value: true)
                    observer.sendCompleted()
                }
            })
        })
    }
}
