//
//  MyPageViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/26.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController, UICollectionViewDelegate {
    let postManager = PostManager.sharedPostManager
    
    override func loadView() {
        view = CustomView(manager: postManager)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = view as! CustomView
        customView.collectionView.delegate = self
        customView.collectionView.dataSource = postManager
        navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
