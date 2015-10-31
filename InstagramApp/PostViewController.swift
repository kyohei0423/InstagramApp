//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var image: UIImage!
    var postView: PostView!
    
    override func loadView() {
        let nib = UINib(nibName: "PostView", bundle: nil)
        view = nib.instantiateWithOwner(nil, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postView = view as! PostView
        
        
        //ジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        postView.textView.resignFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postView.imageView.image = image
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "back")
    }

    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDate() -> String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd HH:mm EEE"
        let time = dateFormatter.stringFromDate(now)
        return time
    }
//
//    @IBAction func post(sender: UIButton) {
//        let time = getDate()
//        let post = Post(text: textView.text, image: selectedImage.image!, date: time)
//        post.save()
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
}
