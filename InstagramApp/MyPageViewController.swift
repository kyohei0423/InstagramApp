//
//  MyPageViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/26.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController, UICollectionViewDelegate {
    let myPagePostManager = MyPagePostManager()
    
    override func loadView() {
        view = MyPageView(manager: myPagePostManager)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let myPageView = view as! MyPageView
        myPageView.collectionView.delegate = self
        myPageView.collectionView.dataSource = myPagePostManager
        navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
