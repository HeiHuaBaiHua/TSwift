//
//  PhotoManager.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/9.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import Photos

class PhotoManager {
    
    static let `default` = {
        return PhotoManager()
    }()
    
    private var isAuthorized = false;
    private init(){}
    
    func checkAuthorizationStatus(completionHandler handler: ((Bool) -> Void)? = nil) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        isAuthorized = (status == .authorized)
        if (status != .notDetermined) {
            handler?(isAuthorized)
        } else {
            
            PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                
                self.isAuthorized = (authorizationStatus == .authorized)
                handler?(self.isAuthorized)
            })
        }
    }

//MARK: Albums
    
    var allPhotoAlbums: [PHAssetCollection] {
        
        var albums = [PHAssetCollection]()
        guard isAuthorized else {
            return albums
        }
        
        let firstAlbums = [NSLocalizedString(PhotoAlbumAllPhotos, comment: ""),
                           NSLocalizedString(PhotoAlbumCameraRoll, comment: "")]
        let ignoreAlbums = [NSLocalizedString(PhotoAlbumHidden, comment: ""),
                            NSLocalizedString(PhotoAlbumRecentlyDeleted, comment: "")]
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let topLevelAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        
        var idx = 0
        while idx < smartAlbums.count {
            
            let album = smartAlbums[idx]
            idx += 1
            if ignoreAlbums.contains(album.localizedTitle!) { continue }
            
            if albums.count > 0 && firstAlbums.contains(album.localizedTitle!) {
                albums.insert(album, at: 0)
            } else {
                albums.append(album)
            }
        }
        
        idx = 0
        while idx < topLevelAlbums.count {
            albums.append(topLevelAlbums[idx])
            idx += 1
        }

        return albums
    }
    
//MARK: Photos
    
    var allPhotos: PHFetchResult<PHAsset> {
        guard isAuthorized else {
            return PHFetchResult<PHAsset>()
        }
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: options)
    }
    
    func photos(inAlbum album: PHAssetCollection) -> PHFetchResult<PHAsset> {
        guard isAuthorized else {
            return PHFetchResult<PHAsset>()
        }
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(in: album, options: options)
    }
}

