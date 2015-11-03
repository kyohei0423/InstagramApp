//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/30.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, PhotoManagerDelegate,  UICollectionViewDelegate{
    let photoManager = PhotoManager.sharedPhotoManager
    var photoModel = PhotoModel()
    var choosePhotoView: ChoosePhotoView!
    
    override func loadView() {
        view = ChoosePhotoView(model: photoModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePhotoView = view as! ChoosePhotoView
        choosePhotoView.photoCollectionView.delegate = self
        choosePhotoView.photoCollectionView.dataSource = photoModel
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .Plain, target: self, action: "transitionModalPostViewController")
    }
    
    override func viewDidAppear(animated: Bool) {
        photoManager.customDelegate = self
        photoManager.checkAuthorizationStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionModalPostViewController() {
        performSegueWithIdentifier("ModalPostViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navigationController = segue.destinationViewController as! UINavigationController
        let postViewController = navigationController.topViewController as! PostViewController
        
        postViewController.image = choosePhotoView.selectedImage
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        let image = selectedCell.photoImage.image
        choosePhotoView.selectedImageView.image = image
    }
    
    //デリゲートメソッド
    func photoManager(photoManager: PhotoManager, showFirstImageView image: UIImage) {
        choosePhotoView.selectedImage = image
        choosePhotoView.selectedImageView.image = choosePhotoView.selectedImage
        choosePhotoView.photoCollectionView.reloadData()
    }
    
    func photoManagerShowAlert(photoManager: PhotoManager) {
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
