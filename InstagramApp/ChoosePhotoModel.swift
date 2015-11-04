//
//  ChoosePhotoModel.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/11/03.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoModel: NSObject, UICollectionViewDataSource {
    var photoAssets = [UIImage]()
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoAssets = ChoosePhotoManager.sharedChoosePhotoManager.photoAssets
        return photoAssets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photoImage.image = photoAssets[indexPath.row]
        return cell
    }
}
