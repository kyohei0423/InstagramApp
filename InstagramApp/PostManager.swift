//
//  PostManager.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/10/14.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class PostManager: NSObject {
    static let sharedManager = PostManager()
    
    var posts = []
}
