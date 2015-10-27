//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController, PhotoCollectionViewDelegate, PhotoManagerDelegate {
    let photoManager = PhotoManager.sharedPhotoManager
    var selectedImage: UIImage!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: PhotoCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoManager.customDelegate = self
        photoManager.checkAuthorizationStatus()
//        selectedImageView.image = photoManager.photoAssets[0]
        photoCollectionView.customDelegate = self
        photoCollectionView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .Plain, target: self, action: "modalPostViewController")
    }
    
    func modalPostViewController() {
        performSegueWithIdentifier("modalPostViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navigationController = segue.destinationViewController as! UINavigationController
        let postViewController = navigationController.topViewController as! PostViewController
        postViewController.image = selectedImage
    }
    //デリゲートメソッド
    func selectedCellImage(image: UIImage) {
        selectedImage = image
        selectedImageView.image = selectedImage
    }
    
    func showFirstImageView(image: UIImage) {
        selectedImageView.image = image
    }
}
