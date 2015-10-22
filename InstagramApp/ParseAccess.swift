//
//  ParseAccess.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit

enum InstagramAppErrorType : Int{
    case NameNotInput = 0
    case PasswordNotInput
    case EmailNotInput
    case Canceled
}

class ParseAccess: NSObject {
    func signUpUser(name:String?, password:String?, email:String?, icon:UIImage?, complitionHander:(succeeded:Bool, error:NSError?) -> Void){
        let error : NSError
        
        if email == nil || email == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.EmailNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        else if name == nil || name == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.NameNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        else if password == nil || password == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.PasswordNotInput.rawValue, userInfo: nil)
            complitionHander(succeeded: false, error: error)
            return
        }
        
        let user = PFUser()
        
        user.username = name
        user.password = password
        user.email = email
        
        if icon != nil{
            let data = UIImageJPEGRepresentation(icon!, 0.95)
            let file = PFFile(data: data!, contentType: "jpeg")
            user["icon"] = file
        }
        
        user.signUpInBackgroundWithBlock { (succeeded, error) in
            if error != nil {
                complitionHander(succeeded: false, error: error)
                return
            }
            else{
                if PFUser.currentUser() == nil {
                    complitionHander(succeeded: false, error: error)
                }
                else {
                    var dict = [String:AnyObject]()
                    let user = PFUser.currentUser()!
                    dict["username"] = user.username!
                    dict["password"] = user.password!
                    NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "LoginUser")
                    complitionHander(succeeded: true, error: error)
                }
            }
        }
    }
    
    func loginUserWithFacebook(complitionHander:((user:PFUser?, isNew:Bool?, error:NSError?) -> Void)?){
        let permissions = ["user_about_me","email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user, error) in
            if user == nil {
                if error == nil{
                    let canceled = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.Canceled.rawValue, userInfo: nil)
                    complitionHander?(user: nil,isNew: nil, error: canceled)
                }
                else{
                    complitionHander?(user: nil, isNew: nil, error: error)
                }
            }
            else if user!.isNew {
                complitionHander?(user: user, isNew: true, error: error)
            }
            else {
                complitionHander?(user: user, isNew: false, error: error)
            }
        }
    }

    func loginUser(name:String?, password:String?, complitionHander:((succeeded:Bool, user:PFUser?, error:NSError?) -> Void)?){
        let error : NSError
        if name == nil || name == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.NameNotInput.rawValue, userInfo: nil)
            complitionHander?(succeeded: false, user:nil, error: error)
            return
        }
        else if password == nil || password == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.PasswordNotInput.rawValue, userInfo: nil)
            complitionHander?(succeeded: false, user:nil, error: error)
            return
        }
        
        PFUser.logInWithUsernameInBackground(name!, password:password!) { (user, error) in
            if error != nil {
                print(error)
                complitionHander?(succeeded: false, user: nil, error: error)
                return
            }
            if user == nil{
                complitionHander?(succeeded: false, user: nil, error: error)
            }
            else{
                complitionHander?(succeeded: true, user: user, error: error)
            }
            
        }
    }
    
    func resetPassword(email:String?, complitionHander:((succeeded:Bool, error:NSError?) -> Void)?){
        let error : NSError
        if email == nil || email == "" {
            error = NSError(domain: "InstagramAppError", code: InstagramAppErrorType.NameNotInput.rawValue, userInfo: nil)
            complitionHander?(succeeded: false, error: error)
            return
        }
        
        PFUser.requestPasswordResetForEmailInBackground(email!) { (succeeded, error) in
            if error != nil {
                complitionHander?(succeeded: false, error: error)
            }
            else if !succeeded {
                complitionHander?(succeeded: false, error: nil)
            }
            else if succeeded  {
                complitionHander?(succeeded: true, error: nil)
            }
        }
    }
}
