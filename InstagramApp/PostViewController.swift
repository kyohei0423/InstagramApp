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
        
        //ジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedImage.image = image
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "back")
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setPostButton(){
        let postButton = UIButton()
        postButton.frame = CGRectMake(0, view.frame.height - (tabBarController?.tabBar.frame.height)!, view.frame.width, (tabBarController?.tabBar.frame.height)!)
        postButton.titleLabel?.text = "投稿する"
        postButton.titleLabel?.tintColor = UIColor.whiteColor()
        tabBarController?.tabBar.addSubview(postButton)
    }
    
    func getDate() -> String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd HH:mm EEE"
        let time = dateFormatter.stringFromDate(now)
        print(time)
        return time
    }
    
    @IBAction func post(sender: UIButton) {
        let time = getDate()
        let post = Post(text: textView.text, image: selectedImage.image!, date: time)
        post.save()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
