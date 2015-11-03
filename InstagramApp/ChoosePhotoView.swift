//
//  ChoosePhotoView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/30.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class ChoosePhotoView: UIView {
    var flowLayout: UICollectionViewFlowLayout
    var photoCollectionView: PhotoCollectionView
    var selectedImageView: UIImageView
    var photoModel: PhotoModel
    var selectedImage: UIImage?
    
    required init(model: PhotoModel) {
        photoModel = model
        selectedImageView = UIImageView(frame: CGRectZero)
        flowLayout = UICollectionViewFlowLayout()
        photoCollectionView = PhotoCollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        photoCollectionView.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        super.init(frame: CGRectZero)
        addSubview(selectedImageView)
        addSubview(photoCollectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //画像の設定
        selectedImageView.frame.origin = CGPointZero
        selectedImageView.frame.size = CGSize(width: frame.width, height: (frame.height + 44) / 2)
        selectedImageView.contentMode = .ScaleAspectFill
        
        //コレクションビューの設定
        photoCollectionView.backgroundColor = UIColor.whiteColor()
        photoCollectionView.frame.origin = CGPoint(x: 0, y: (frame.height + 44) / 2)
        photoCollectionView.frame.size = CGSize(width: frame.width, height: (frame.height - 44) / 2)
        
        //コレクションビューのセルのレイアウト
        flowLayout.setCollectionViewLayout(frame.width)
    }
    
}
