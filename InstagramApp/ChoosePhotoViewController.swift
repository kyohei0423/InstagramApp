//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController {
    var photoAssets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //フォトライブラリへのアクセス許可を求める
    private func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .Authorized:
            self.getAllPhotosInfo()
        default:
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status == .Authorized {
                    self.getAllPhotosInfo()
                }
            })
        }
    }
    
    //フォトライブラリから全ての写真のPHAssetオブジェクトを取得する
    private func getAllPhotosInfo() {
        photoAssets = []
        
        //ソート条件を指定
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
            let manager = PHImageManager()
            manager.requestImageForAsset(asset as! PHAsset, targetSize: CGSizeMake(70, 70), contentMode: .AspectFill, options: nil, resultHandler: { (image, info) -> Void in
                //collectionViewに画像を表示させる
                print(image)
            })
        }
    }
    
    
}
