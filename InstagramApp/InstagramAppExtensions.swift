//
//  InstagramAppExtensions.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/16.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

extension UIImageView{
    //画像を非同期で取得＆表示させる
    func getUrlImageAsynchronous(urlString:String, complitionHander:((succeeded:Bool, error:NSError?) -> Void)?){
        let url = NSURL(string:urlString)
        let req = NSURLRequest(URL:url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if error != nil {
                // Handle error...
                complitionHander?(succeeded: false, error: error)
                return
            }
            
            if let image = UIImage(data:data!){
                dispatch_async(dispatch_get_main_queue(), { () in
                    self.image=image
                    complitionHander?(succeeded: true, error: nil)
                })
            }
            else{
                //不明なエラー
                complitionHander?(succeeded: false, error: nil)
            }
        }
        task.resume()
    }
}
