//
//  CustomView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/26.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView
    
    required init(manager: PostManager) {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.registerNib(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.redColor()
        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        collectionView.backgroundColor = UIColor.whiteColor()
        print(self.frame)
        setCollectionViewLayout()
    }
    
    func setCollectionViewLayout() {
        let itemLength = frame.width / 3
        flowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
}