//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController, PhotoCollectionViewDelegate {
    let photoManager = PhotoManager.sharedPhotoManager
    var selectedImage: UIImage!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: PhotoCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        
        photoCollectionView.customDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .Plain, target: self, action: "showPostViewController")
        tabBarController?.tabBar.translucent = false
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        selectedImageView.image = photoManager.photoAssets[0]
    }
    
    //フォトライブラリへのアクセス許可を求める
    private func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .Authorized:
            getAllPhotosInfo()
        default:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .Authorized {
                    self.getAllPhotosInfo()
                }
            })
        }
    }
    
    //フォトライブラリから全ての写真のPHAssetオブジェクトを取得する
    private func getAllPhotosInfo() {
        //ソート条件を指定
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) in
            let manager = PHImageManager()
            manager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .AspectFill, options: nil) { (image, info) in
                self.photoManager.photoAssets.append(image!)
            }
        }
    }
    
    func selectedCellImage(image: UIImage) {
        selectedImage = image
        selectedImageView.image = selectedImage
    }
    
    func showPostViewController() {
        performSegueWithIdentifier("showPostViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let postViewController = segue.destinationViewController as! PostViewController
        postViewController.image = selectedImage
    }
}
