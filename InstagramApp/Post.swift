//
//  PostModel.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/25.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    var text: String
    var image: PFFile
    var date: String
    
    init(text: String, image: UIImage, date: String) {
        self.text = text
        let imageDate = UIImagePNGRepresentation(image)!
        self.image = PFFile(name: "image.png", data: imageDate)!
        self.date = date
    }
    
    func save() {
        let postObject = PFObject(className: "Post")
        postObject["text"] = text
        postObject["image"] = image
        postObject["date"] = date
        postObject.saveInBackgroundWithBlock { (success, error) in
            if success {
                print("投稿成功")
            }
        }
    }
}
