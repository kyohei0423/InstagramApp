//
//  PhotoManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

protocol PhotoManagerDelegate: class {
    func showFirstImageView(image: UIImage)
    func showAlert()
}

class PhotoManager: NSObject, UICollectionViewDataSource {
    static let sharedPhotoManager = PhotoManager()
    var photoAssets = [UIImage]()
    weak var customDelegate: PhotoManagerDelegate?
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photoImage.image = photoAssets[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    //フォトライブラリへのアクセス許可を求める
    func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .Authorized:
            getAllPhotosInfo()
        case .Denied:
            customDelegate?.showAlert()
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
        assets.enumerateObjectsUsingBlock { (asset, index, stop) in
            let manager = PHImageManager()
            manager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: 800, height: 800), contentMode: .AspectFill, options: nil) { (image, info) in
                self.photoAssets.append(image!)
            }
        }
        customDelegate?.showFirstImageView(photoAssets[0])
    }
    
}