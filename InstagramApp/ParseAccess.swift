//
//  ParseAccess.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse

enum InstagramAppErrorType : Int{
    case NameNotInput = 0
    case PasswordNotInput
    case EmailNotInput
}

class ParseAccess: NSObject {
    func createUser(name:String?, password:String?, email:String?, icon:UIImage?, complitionHander:(succeeded:Bool, error:NSError?) -> Void){
        let user = PFUser()
        
        user.username = name
        user.password = password
        user.email = email
        
        if icon != nil{
            let data = UIImageJPEGRepresentation(icon!, 0.95)
            let file = PFFile(data: data!, contentType: "jpeg")
            user["icon"] = file
        }
        
        let error : NSError
        
        if name == nil || name == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.NameNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        else if password == nil || password == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.PasswordNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        else if email == nil || email == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.EmailNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error != nil{
                complitionHander(succeeded: false, error: error)
            }
            else{
                complitionHander(succeeded: true, error: error)
            }
        }
    }
}
