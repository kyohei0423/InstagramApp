//
//  UserPhotosCollectionView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewDelegate: class {
    func showSelectedCellImage(image: UIImage)
}

class PhotoCollectionView: UICollectionView, UICollectionViewDelegate {
    let photoManager = PhotoManager.sharedPhotoManager
    weak var customDelegate: PhotoCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        //セルを登録
        registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        dataSource = photoManager
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = frame.width / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        let selectedCellImage = selectedCell.photoImage.image
        customDelegate?.showSelectedCellImage(selectedCellImage!)
    }
    
}