//
//  UICollectionViewFlowLayout+Extension.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/11/02.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    func setCollectionViewLayout(frameWidth: CGFloat) {
        let itemLength = frameWidth / 3
        itemSize = CGSize(width: itemLength, height: itemLength)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}
