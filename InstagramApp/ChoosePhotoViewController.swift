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
        self.view.backgroundColor = UIColor.lightGrayColor()
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
            
            let frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
            let layout = UICollectionViewFlowLayout()
            let cellSize = self.view.frame.width / 3 - 10
            layout.itemSize = CGSizeMake(cellSize, cellSize)
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            let userPhotosCollectionView = UserPhotosCollectionView(frame: frame, collectionViewLayout: layout)
            userPhotosCollectionView.photoAssets = self.photoAssets
            self.view.addSubview(userPhotosCollectionView)
        }
    }
    
}
