//
//  Post.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/14.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class Post: NSObject {
    let descript: String
    let image: String
    
    
    init(descript: String, image: String) {
        self.descript = descript
        self.image = image
    }

}
