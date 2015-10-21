//
//  UserPhotosCollectionView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class UserPhotosCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var photoAssets = [PHAsset]()
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        //デリゲート
        delegate = self
        dataSource = self
        
        //セルを登録
        registerNib(UINib(nibName: "UserPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserPhotosCollectionViewCell")
        
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier("UserPhotosCollectionViewCell", forIndexPath: indexPath) as! UserPhotosCollectionViewCell
        let asset = photoAssets[indexPath.row]
        let manager = PHImageManager()
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 70, height: 70), contentMode: .AspectFill, options: nil) { (image, info) in
            cell.photoImage.image = image
        }
        return cell
    }
    
    //呼ばれている
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    
}