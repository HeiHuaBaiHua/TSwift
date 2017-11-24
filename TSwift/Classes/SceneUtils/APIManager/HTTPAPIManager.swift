//
//  HTTPAPIManager.swift
//  TAlamoFire
//
//  Created by 黑花白花 on 2017/5/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

import Alamofire
import HandyJSON

import Result
import ReactiveSwift
import ReactiveCocoa

typealias APICompletionHandler = (Any?, APIError?) -> Void

class HTTPAPIManager {
    
    @discardableResult
    func dispatchDataTask(configuration config: HTTPDataTaskConfiguration, completionHandler: @escaping (APICompletionHandler)) -> Int {

        var taskId = [Int]()
        let id = HTTPClient.default.dispatchDataTask(configuration: config) { (response) in
            
            let id = taskId.first!
            self.runingTaskIds.remove(at: self.runingTaskIds.index(of: id)!)
            completionHandler(response.responseValue, self.formatError(response.error))
        }
        taskId.append(id)
        runingTaskIds.append(id)
        return id
    }
    
    func dispatchUploadTask(configuration config: HTTPUploadTaskConfiguration, progressHandler: @escaping Request.ProgressHandler, completionHandler: @escaping (APICompletionHandler)) {

        HTTPClient.default.dispatchUploadTask(configuration: config, progressHandler: progressHandler) { (response) in
            completionHandler(response.responseValue, self.formatError(response.error))
        }
    }
    
    func cancelTask(taskId: Int) {
        
        if let index = runingTaskIds.index(of: taskId) {
            
            HTTPClient.default.cancelTask(taskId: taskId)
            runingTaskIds.remove(at: index)
        }
    }
    
    func cancelAllTasks() {
        
        HTTPClient.default.cancelTasks(taskIds: runingTaskIds)
        runingTaskIds.removeAll()
    }
    
//MARK: Private
    
    private var runingTaskIds = [Int]()
    
    private func formatError(_ originalError: Error?) -> APIError? {
        
        var apiError: APIError?
        if originalError != nil {
            
            if let error = originalError as NSError? {
                
                switch (error.code) {
                    
                case NSURLErrorTimedOut:
                    apiError = APIError( .timeout)
                    
                case NSURLErrorCancelled:
                    apiError = APIError( .canceled)
                    
                case NSURLErrorCannotFindHost,
                     NSURLErrorCannotConnectToHost,
                     NSURLErrorNotConnectedToInternet:
                    apiError = APIError( .noNetwork)
                    
                default:
                    apiError = APIError( .default)
                }
            }
        }
        return apiError
    }
}

