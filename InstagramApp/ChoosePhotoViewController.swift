//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/30.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, PhotoManagerDelegate, PhotoCollectionViewDelegate {
    let photoManager = PhotoManager.sharedPhotoManager
    var selectedImage: UIImage!
    var choosePhotoView: ChoosePhotoView!
    
    override func loadView() {
        view = ChoosePhotoView(managr: photoManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePhotoView = view as! ChoosePhotoView
        
        choosePhotoView.photoCollectionView.dataSource = photoManager
        choosePhotoView.photoCollectionView.customDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .Plain, target: self, action: "modalPostViewController")
//        photoManager.customDelegate = self
//        photoManager.checkAuthorizationStatus()
    }
    
    override func viewDidAppear(animated: Bool) {
        photoManager.customDelegate = self
        photoManager.checkAuthorizationStatus()
    }
    
    func modalPostViewController() {
        performSegueWithIdentifier("ModalPostViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navigationController = segue.destinationViewController as! UINavigationController
        let postViewController = navigationController.topViewController as! PostViewController
        postViewController.image = selectedImage
    }
    //デリゲートメソッド
    func showFirstImageView(image: UIImage) {
        selectedImage = image
        choosePhotoView.selectedImageView.image = selectedImage
        choosePhotoView.photoCollectionView.reloadData()
    }
    
    func showSelectedCellImage(image: UIImage) {
        selectedImage = image
        choosePhotoView.selectedImageView.image = selectedImage
    }
    
    func showAlert () {
        let alertController = UIAlertController(title: nil, message: "カメラロールへのアクセスが許可されていません", preferredStyle: .Alert)
        let configAction = UIAlertAction(title: "設定画面へ", style: .Default, handler: { (action: UIAlertAction) in
            self.moveConfig()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Default, handler: nil)
        alertController.addAction(configAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //設定画面を呼び出す
    func moveConfig() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)        
    }
    
}
