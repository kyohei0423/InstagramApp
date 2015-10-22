//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController, UserPhotoCollectionViewDelegate {
    var photoAssets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        view.backgroundColor = UIColor.lightGrayColor()
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
            getAllPhotosInfo()
        default:
            PHPhotoLibrary.requestAuthorization({ (status) in
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
        assets.enumerateObjectsUsingBlock { (asset, index, stop) in
            
            self.photoAssets.append(asset as! PHAsset)
            
            let frame = CGRect(x: 0, y: self.view.frame.height / 2 - (self.tabBarController?.tabBar.frame.height)!, width: self.view.frame.width, height: self.view.frame.height / 2  - (self.tabBarController?.tabBar.frame.height)! - 15)
            let layout = UICollectionViewFlowLayout()
            let margine: CGFloat = 5
            let cellSize = self.view.frame.width / 3 - margine * 2
            layout.itemSize = CGSizeMake(cellSize, cellSize)
            layout.sectionInset = UIEdgeInsets(top: margine, left: margine, bottom: margine, right: margine)
            let userPhotosCollectionView = UserPhotosCollectionView(frame: frame, collectionViewLayout: layout)
            userPhotosCollectionView.cusutomDelegate = self
            userPhotosCollectionView.photoAssets = self.photoAssets
            self.view.addSubview(userPhotosCollectionView)
        }
    }
    
    func showSelectedPhoto(image: UIImage) {
        let margine: CGFloat = 20
        let imageFrame = CGRectMake(margine, margine, view.frame.width - margine * 2, view.frame.height / 2 - margine * 2)
        let selectedImage = SelectedImageView(frame: imageFrame)
        selectedImage.image = image
        view.addSubview(selectedImage)
    }
    
}
