//
//  SignUpViewModel.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/22.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignUpViewModel: NSObject {
    var email:String?
    var name:String?
    var fb_id:String?
    
    var animationNow = false
    
    override init() {
        super.init()
    }
    
    func signUp(name:String?, password:String?, email:String?, icon:UIImage?, complitionHander:(succeeded:Bool, error:NSError?)->Void){
        ParseAccess().signUpUser(name, password: password, email: email, icon: icon) { (succeeded, error) in
            complitionHander(succeeded: succeeded, error: error)
        }
    }
    
    private func getFBPermissions(viewController:UIViewController, complitionHander:(image:UIImage?, error:NSError?)->Void){
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email"], fromViewController: viewController) { (result, error) in
            if error != nil {
                complitionHander(image: nil, error: error)
                return
            }
            else if result.isCancelled {
                print("Cancelled")
            }
            else{
                if (result.grantedPermissions.contains("public_profile") && result.grantedPermissions.contains("email")) {
                    self.getIconImage(viewController, complitionHander: complitionHander)
                }
            }
        }
    }
    
    func getIconImage(viewController:UIViewController,complitionHander:(image:UIImage?, error:NSError?)->Void){
//        if FBSDKAccessToken.currentAccessToken() == nil {
//            getFBPermissions(viewController,complitionHander: complitionHander)
//            return
//        }
        let request=FBSDKGraphRequest(graphPath: "/me", parameters: [:], HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) in
            guard error == nil && result != nil else{
                complitionHander(image: nil, error: error)
                return
            }
                
            if let id = result.valueForKey("id") as? String{
                UIImage.imageWithFacebookId(FacebookID: id, complitionHander: { (image, error) in
                    complitionHander(image: image, error: nil)
                })
            }
        })
    }
}
