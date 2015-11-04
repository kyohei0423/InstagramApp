//
//  PhotoManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

protocol ChoosePhotoManagerDelegate: class {
    func choosePhotoManager(choosePhotoManager: ChoosePhotoManager, showFirstImageView image: UIImage)
    func choosePhotoManagerShowAlert(choosePhotoManager: ChoosePhotoManager)
}

class ChoosePhotoManager: NSObject {
    
    static let sharedChoosePhotoManager = ChoosePhotoManager()
    var photoAssets = [UIImage]()
    weak var customDelegate: ChoosePhotoManagerDelegate?
    
    
    //フォトライブラリへのアクセス許可を求める
    func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .Authorized:
            getAllPhotosInfo()
        case .Denied:
            customDelegate?.choosePhotoManagerShowAlert(self)
        default:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .Authorized {
                    self.getAllPhotosInfo()
                }
            })
        }
    }
    
    //フォトライブラリから全ての写真のPHAssetオブジェクトを取得する
    func getAllPhotosInfo() {
        //ソート条件を指定
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, _, _) in
            let manager = PHImageManager()
            let options = PHImageRequestOptions()
            options.synchronous = true
            manager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .AspectFill, options: nil) { (image, _) in
                self.photoAssets.append(image!)
            }
        }
        customDelegate?.choosePhotoManager(self, showFirstImageView: photoAssets[0])
    }
    
}
