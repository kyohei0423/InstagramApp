//
//  PhotoManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class PhotoManager: NSObject, UICollectionViewDataSource {
    static let sharedPhotoManager = PhotoManager()
    var photoAssets = [UIImage]()
    
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
}