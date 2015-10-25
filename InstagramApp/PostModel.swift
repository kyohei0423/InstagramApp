//
//  PostModel.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/25.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostModel: NSObject {
    var text: String
    var image: UIImage
    var date: String
    
    init(text: String, image: UIImage, date: String) {
        self.text = text
        self.image = image
        self.date = date
    }
}
