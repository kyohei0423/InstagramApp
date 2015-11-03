//
//  MyPagePostModel.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/11/03.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class MyPagePostModel: UIView, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
        //最終的には配列の数に置き換える
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCollectionViewCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        return cell
    }

}
