//
//  InstagramAppExtensions.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/16.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

extension UIImageView {
    //画像を非同期で取得＆表示させる
    func getUrlImageAsynchronous(urlString: String, complitionHander: ((succeeded: Bool, error: NSError?) -> Void)?) {
        let url = NSURL(string:urlString)
        let req = NSURLRequest(URL:url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            guard error == nil else {
                // Handle error...
                complitionHander?(succeeded: false, error: error)
                return
            }
            
            guard let image = UIImage(data: data!) else {
                //不明なエラー
                complitionHander?(succeeded: false, error: nil)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () in
                self.image = image
                complitionHander?(succeeded: true, error: nil)
            })
        }
        task.resume()
    }
}

extension UIImage{
    /**URLから画像を取得**/
    class func imageWithURL(URL url: NSURL, complitionHander:(image:UIImage?, error:NSError?) -> Void){
        let req = NSURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            guard error == nil else{
                // Handle error...
                complitionHander(image: nil, error: error)
                return
            }
            
            if let image = UIImage(data:data!) {
                complitionHander(image: image, error: error)
            }
            else{
                complitionHander(image: nil, error: error)
                return
            }
        }
        task.resume()
    }
    
    /**FacebookIDから画像を取得**/
    class func imageWithFacebookId(FacebookID id:String, complitionHander:(image:UIImage?, error:NSError?) -> Void) {
        let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
        UIImage.imageWithURL(URL: url!, complitionHander: complitionHander)
    }
}
