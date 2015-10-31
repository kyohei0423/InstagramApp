//
//  PostManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/25.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostModel: NSObject {
    static let sharedPostModel = PostModel()
    var posts = [Post]()
    
}