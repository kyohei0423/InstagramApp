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
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lineShareButton: UIButton!
    @IBOutlet weak var twitterShareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
        lineShareButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        lineShareButton.layer.borderWidth = 1
        twitterShareButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        twitterShareButton.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedImage.image = image
        tabBarController?.tabBar.translucent = true
        tabBarController?.tabBar.hidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "投稿", style: .Plain, target: self, action: "post")
        
    }
    
    func post() {
        
        let postModel = PostModel(text: textView.text, image: selectedImage.image, date: <#T##String#>)
    }
    
    func getDate() {
        let date = NSDate()
        
    }
    
    func setPostButton(){
        let postButton = UIButton()
        postButton.frame = CGRectMake(0, view.frame.height - (tabBarController?.tabBar.frame.height)!, view.frame.width, (tabBarController?.tabBar.frame.height)!)
        postButton.titleLabel?.text = "投稿する"
        postButton.titleLabel?.tintColor = UIColor.whiteColor()
        tabBarController?.tabBar.addSubview(postButton)
    }
    
}
