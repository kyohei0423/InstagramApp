//
//  PostManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/25.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostManager: NSObject, UICollectionViewDataSource {
    static let sharedPostManager = PostManager()
    var posts = [Post]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
}
