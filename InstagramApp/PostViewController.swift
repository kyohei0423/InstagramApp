//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/24.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    var postView: PostView?
    var image: UIImage!
    
    override func loadView() {
        let nib = UINib(nibName: "PostView", bundle: nil)
        view = nib.instantiateWithOwner(nil, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postView = view as? PostView
        postView!.postButton.addTarget(self, action: "tapPostButton", forControlEvents: .TouchUpInside)
        
        //ジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postView!.imageView.image = image
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        postView!.textView.resignFirstResponder()
    }

    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func tapPostButton() {
        let dateTime = NSDate.getDateTime()
        let post = PostModel(text: postView!.textView.text, image: postView!.imageView.image!, date: dateTime)
        post.save()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
