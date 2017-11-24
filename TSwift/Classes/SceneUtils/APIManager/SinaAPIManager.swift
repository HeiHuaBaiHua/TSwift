//
//  SinaAPIManager.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SwiftyJSON

class SinaAPIManager: HTTPAPIManager {
    
    private let SinaAPPKEY = "..."
    private let SinaAPPSECRET = "..."

    func upload() {
        
        let parameters = ["text": "什么什么 https://www.baidu.com"]
        let file = UploadFile(data: UIImagePNGRepresentation("tabbar_compose_friends_neo".image!)!, fileName: "image1", fileType: .PNG, uploadKey: "image")
        let file2 = UploadFile(data: UIImagePNGRepresentation("tabbar_compose_friend".image!)!, fileName: "image2", fileType: .PNG, uploadKey: "image")
        
        let config = HTTPUploadTaskConfiguration(urlPath: "http://127.0.0.1:8888/upload", contents: [file, file2], parameters: parameters)
        uploadProducer(configuration: config).startWithResult { (result) in
            
            if result.error != nil {
                print(result.error!)
            } else {
                print(result.value!)
            }
        }
    }
    
    func getSinaOauth(code: String) -> APIProducer<[String: String]> {
        
        let parameters = ["client_id": SinaAPPKEY,
                          "client_secret": SinaAPPSECRET,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": "https://api.weibo.com/oauth2/default.html"]
        let config = HTTPDataTaskConfiguration(urlPath: "https://api.weibo.com/oauth2/access_token",
                                               method: .post,
                                               parameters: parameters,
                                               responseValue: .data)
        return producer(configuration: config).map({ (response) -> [String: String] in
            
            let json = JSON(data: response as! Data)
            var result = [String: String]()
            if let token = json["access_token"].string {
                result["token"] = token
                print("xxx: \(token)")
            }
            if let uid = json["uid"].string {
                result["uid"] = uid
            }
            return result
        })
    }
    
    func revokeSinaOauth(token: String) -> AnyAPIProducer {
        
        let config = HTTPDataTaskConfiguration(urlPath: "https://api.weibo.com/oauth2/revokeoauth2",
                                               method: .post,
                                               parameters: ["access_token": token])
        return producer(configuration: config)
    }
}
