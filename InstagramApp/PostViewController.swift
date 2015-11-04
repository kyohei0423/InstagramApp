//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    var _image: UIImage!
    
    override func loadView() {
        let nib = UINib(nibName: "PostView", bundle: nil)
        view = nib.instantiateWithOwner(nil, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let postView = view as! PostView
        postView.postButton.addTarget(self, action: "tapPostButton", forControlEvents: .TouchUpInside)
        
        //ジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let postView = view as! PostView
        postView.imageView.image = _image
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        let postView = view as! PostView
        postView.textView.resignFirstResponder()
    }

    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func tapPostButton() {
        let dateTime = NSDate.getDateTime()
        let postView = view as! PostView
        let post = Post(text: postView.textView.text, image: postView.imageView.image!, date: dateTime)
        post.save()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
