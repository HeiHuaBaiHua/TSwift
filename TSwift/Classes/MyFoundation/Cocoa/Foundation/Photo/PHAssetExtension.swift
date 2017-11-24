//
//  PHAssetExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/9.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    
    var isImage: Bool {
        if #available(iOS 9.1, *) {
            return mediaType == .image && mediaSubtypes != .photoLive
        } else {
            return mediaType == .image
        }
    }
    
    var originImage: UIImage? {
        guard isImage else { return nil }
        
        var image: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHCachingImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (result, _) in
            image = result
        }
        return image
    }
    
    var previewImage: UIImage? {
        guard isImage else { return nil }
        
        var image: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHCachingImageManager.default().requestImage(for: self, targetSize: ScreenBounds.size, contentMode: .aspectFill, options: options) { (result, _) in
            image = result
        }
        return image
    }
    
    func thumbnailImage(size: CGSize) -> UIImage? {
        guard isImage else { return nil }
        
        var image: UIImage?
        let scale = UIScreen.main.scale
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .exact
        PHCachingImageManager.default().requestImage(for: self, targetSize: CGSize(width: size.width * scale, height: size.height * scale), contentMode: .aspectFill, options: options) { (result, _) in
            image = result
        }
        return image
    }
    
    func requestOriginImage(progressHandler: @escaping PHAssetImageProgressHandler, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard isImage else {
            resultHandler(nil, nil)
            return -1
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.progressHandler = progressHandler
        return PHCachingImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options, resultHandler: resultHandler)
    }
    
    func requestPreviewImage(progressHandler: @escaping PHAssetImageProgressHandler, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard isImage else {
            resultHandler(nil, nil)
            return -1
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.progressHandler = progressHandler
        return PHCachingImageManager.default().requestImage(for: self, targetSize: ScreenBounds.size, contentMode: .aspectFill, options: options, resultHandler: resultHandler)
    }
    
    func requestPreviewImage(size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard isImage else {
            resultHandler(nil, nil)
            return -1
        }
        
        let scale = UIScreen.main.scale
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .fast
        return PHCachingImageManager.default().requestImage(for: self, targetSize: CGSize(width: size.width * scale, height: size.height * scale), contentMode: .aspectFill, options: options, resultHandler: resultHandler)
    }

    func requestImageInfo(resultHandler: @escaping ([String: Any]) -> Void) {
        guard isImage else {
            resultHandler([:])
            return
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        PHCachingImageManager.default().requestImageData(for: self, options: options) { (data, _, orientation, info) in
            
            var result = [String: Any]()
            result[kPHAssetImageOrientation] = orientation
            if let data = data {
                result[kPHAssetImageData] = data
                result[kPHAssetImageSize] = data.count
            }
            if let info = info {
                result[kPHAssetImageInfo] = info
            }
            resultHandler(result)
        }
    }
}

