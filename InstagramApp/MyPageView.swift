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
    
    required init(model: MyPagePostModel) {
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
        //コレクションビューの設定
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.frame.origin = CGPointZero
        collectionView.frame.size = frame.size
        collectionView.backgroundColor = UIColor.whiteColor()
        
        //コレクションビューのセルの設定
        flowLayout.setCollectionViewLayout(frame.width)
    }
    
}
