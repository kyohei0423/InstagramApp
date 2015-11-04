//
//  ChoosePhotoViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/30.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, ChoosePhotoManagerDelegate,  UICollectionViewDelegate{
    let choosePhotoManager = ChoosePhotoManager.sharedChoosePhotoManager
    let choosePhotoModel = ChoosePhotoModel()
    var choosePhotoView: ChoosePhotoView!
    
    override func loadView() {
        view = ChoosePhotoView(model: choosePhotoModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePhotoView = view as! ChoosePhotoView
        choosePhotoView.photoCollectionView.delegate = self
        choosePhotoView.photoCollectionView.dataSource = choosePhotoModel
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .Plain, target: self, action: "transitionModalPostViewController")
    }
    
    override func viewDidAppear(animated: Bool) {
        choosePhotoManager.customDelegate = self
        choosePhotoManager.checkAuthorizationStatus()
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
        
        postViewController._image = choosePhotoView.selectedImage
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        let image = selectedCell.photoImage.image
        choosePhotoView.selectedImageView.image = image
    }
    
    //デリゲートメソッド
    func choosePhotoManager(photoManager: ChoosePhotoManager, showFirstImageView image: UIImage) {
        choosePhotoView.selectedImage = image
        choosePhotoView.selectedImageView.image = choosePhotoView.selectedImage
        choosePhotoView.photoCollectionView.reloadData()
    }
    
    func choosePhotoManagerShowAlert(photoManager: ChoosePhotoManager) {
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
