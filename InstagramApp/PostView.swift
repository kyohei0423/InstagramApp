//
//  PostView.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/31.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    override func layoutSubviews() {
        textView.layer.borderWidth = 3
        textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        twitterButton.layer.borderWidth = 2
        twitterButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        lineButton.layer.borderWidth = 2
        lineButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
    }
}
