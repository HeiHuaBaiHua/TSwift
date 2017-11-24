//
//  HTTPClient.swift
//  TAlamoFire
//
//  Created by 黑花白花 on 2017/5/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

import Alamofire

protocol NetworkResponse {
    
    var error: Error? { get }
    var responseValue: Any? { get }
}

extension DataResponse: NetworkResponse {
    
    var responseValue: Any? { return self.value }
}

typealias NetworkTaskCompletionHandler = (NetworkResponse) -> Void

final class HTTPClient {
    
    //MARK: Public
    
    static let `default` = {
        return HTTPClient()
    }()
    
    @discardableResult
    func dispatchDataTask(configuration config: HTTPDataTaskConfiguration, completionHandler: @escaping (NetworkTaskCompletionHandler)) -> Int {
        
        let request = HTTPRequestGenerator.default.dataRequest(configuration: config)
        
        var requestId: Int?
        if let task = request.task {
            
            requestId = task.taskIdentifier
            
            lock.wait()
            dispatchTable[requestId!] = request
            lock.signal()
        }
        
        let requestHandler = requestCompletionHandler(forRequest: requestId, completionHandler: completionHandler)
        switch config.responseValue {
            
        case .data:
            request.responseData(completionHandler: requestHandler)
        case .json:
            request.responseJSON(completionHandler: requestHandler)
        case .string:
            request.responseString(completionHandler: requestHandler)
        }
        
        return requestId ?? -1
    }
    
    func dispatchUploadTask(configuration config: HTTPUploadTaskConfiguration, progressHandler: @escaping Request.ProgressHandler, completionHandler: @escaping (NetworkTaskCompletionHandler)) {
        
        HTTPRequestGenerator.default.uploadRequest(configuration: config) { (result) in
            switch result {
            case .success(let request, _, _):
                
                request.uploadProgress(closure: progressHandler)
                switch config.responseValue {
                    
                case .data:
                    request.responseData(completionHandler: completionHandler)
                case .json:
                    request.responseJSON(completionHandler: completionHandler)
                case .string:
                    request.responseString(completionHandler: completionHandler)
                }
            case .failure(let error):
                
                let response = DataResponse(request: nil, response: nil, data: nil, result: Result<Any>.failure(error))
                completionHandler(response)
            }
        }
    }
    
    func cancelTask(taskId: Int) {
        cancelTasks(taskIds: [taskId])
    }
    
    func cancelAllTasks() {
        cancelTasks(taskIds: [Int](dispatchTable.keys))
    }
    
    func cancelTasks(taskIds: [Int]) {
        
        guard taskIds.count > 0 else { return }
        
        lock.wait()
        for Id in taskIds {
            
            if let request = dispatchTable[Id] {
                
                request.cancel()
                dispatchTable[Id] = nil
            }
        }
        lock.signal()
    }
    
//MARK: Private
    
    private var lock: DispatchSemaphore
    private var dispatchTable: [Int: Request]
    
    private init(){
        
        self.lock = DispatchSemaphore(value: 1)
        self.dispatchTable = [:]
    }
    
    private func requestCompletionHandler(forRequest requestId: Int?, completionHandler: @escaping (NetworkTaskCompletionHandler)) -> NetworkTaskCompletionHandler {
        
        return { result in
            
            if let requestId = requestId {
                
                self.lock.wait()
                self.dispatchTable[requestId] = nil
                self.lock.signal()
            }

            completionHandler(result)
        }
    }
}
