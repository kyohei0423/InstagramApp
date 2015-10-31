//
//  CustomView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/26.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class MyPageView: UIView {
    
    var flowLayout: UICollectionViewFlowLayout
    var collectionView: UICollectionView
    
    required init(manager: MyPagePostManager) {
        flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.registerNib(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        super.init(frame: CGRectZero)
        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.frame.origin = CGPointZero
        collectionView.frame.size = frame.size
        collectionView.backgroundColor = UIColor.whiteColor()
        setCollectionViewLayout()
    }
    
    func setCollectionViewLayout() {
        let itemLength = frame.width / 3
        flowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    
}