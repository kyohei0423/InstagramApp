//
//  UserPhotosCollectionView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

@objc protocol PhotoCollectionViewDelegate {
    func selectedCellImage(image: UIImage)
}


class PhotoCollectionView: UICollectionView, UICollectionViewDelegate {
    let photoManager = PhotoManager.sharedPhotoManager
    weak var customDelegate: PhotoCollectionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //セルを登録
        registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        //デリゲート
        delegate = self
        dataSource = photoManager
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = frame.width / 3
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        customDelegate?.selectedCellImage(selectedCell.photoImage.image!)
    }
    
}