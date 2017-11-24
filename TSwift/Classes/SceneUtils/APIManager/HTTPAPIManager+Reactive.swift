//
//  HTTPAPIManager+Reactive.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/30.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

import Result
import ReactiveSwift
import ReactiveCocoa

import HandyJSON

extension TSwift.HTTPAPIManager {

    @discardableResult
    public func producer(configuration config: HTTPDataTaskConfiguration) -> AnyAPIProducer {
        return AnyAPIProducer({(subscriber, _) in
            
            self.dispatchDataTask(configuration: config, completionHandler: { (value, error) in
                
                if error != nil {
                    subscriber.send(error: error!)
                } else {
                    subscriber.send(value: value)
                    subscriber.sendCompleted()
                }
            })
        }).observe(on: UIScheduler())
    }
    
    @discardableResult
    public func objectProducer<T: HandyJSON>(configuration config: HTTPDataTaskConfiguration, deserializePath path: String? = nil) -> APIProducer<T?> {
        return APIProducer({(subscriber, _) in

            config.responseValue = .string
            self.dispatchDataTask(configuration: config, completionHandler: { (value, error) in

                var result: T?
                var error = error
                if error == nil {

                    if let json: String = value as? String,
                        let deserialize = T.deserialize(from: json, designatedPath: path){
                        result = deserialize
                    } else {
                        error = APIError( .noData)
                    }
                }

                if error != nil {
                    subscriber.send(error: error!)
                } else {
                    subscriber.send(value: result)
                    subscriber.sendCompleted()
                }
            })
        }).observe(on: UIScheduler())
    }

    @discardableResult
    public func arrayProducer<T: HandyJSON>(configuration config: HTTPDataTaskConfiguration, deserializePath path: String? = nil) -> APIProducer<[T]?> {
        return APIProducer({(subscriber, _) in

            config.responseValue = .string
            self.dispatchDataTask(configuration: config, completionHandler: { (value, error) in

                var result: [T]?
                var error = error
                if error == nil {
                    
                    if let json: String = value as? String,
                        let deserialize = [T].deserialize(from: json, designatedPath: path) {

                        result = deserialize.flatMap{ $0 }
                    }

                    if result?.count == 0 {
                        
                        let page = config.parameters?["page"] as? Int ?? 1
                        let errorCode = (page == 1 ? TaskError.noData : TaskError.noMoreData)
                        error = APIError(errorCode)
                    }
                }

                if error != nil {
                    subscriber.send(error: error!)
                } else {
                    subscriber.send(value: result)
                    subscriber.sendCompleted()
                }
            })
        }).observe(on: UIScheduler())
    }
    
    @discardableResult
    public func uploadProducer(configuration config: HTTPUploadTaskConfiguration) -> APIProducer<(Float, Any?)> {
        return APIProducer({(subscriber, _) in
            
            self.dispatchUploadTask(configuration: config, progressHandler: { (progress) in
                
                if progress.totalUnitCount != 0 {
                    subscriber.send(value: (Float(progress.completedUnitCount) / Float(progress.totalUnitCount), nil))
                }
            }, completionHandler: { (value, error) in
                
                if error != nil {
                    subscriber.send(error: error!)
                } else {
                    subscriber.send(value: (1, value))
                    subscriber.sendCompleted()
                }
            })
        }).observe(on: UIScheduler())
    }
}
