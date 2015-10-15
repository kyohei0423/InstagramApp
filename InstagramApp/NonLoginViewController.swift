//
//  NonLoginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class NonLoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var FBLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPushedNextButton(sender: UIButton) {
        self.performSegueWithIdentifier("SignUp", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUp"{
            if let view = segue.destinationViewController as? SignUpViewController{
                if sender === self.nextButton {
                    view.email = self.emailField.text
                }
                else{
                    if let dict = sender as? [String:String]{
                        view.email = dict["email"]
                        view.name = dict["name"]
                        view.fb_id = dict["fb_id"]
                    }
                }
            }
        }
    }
    
    @IBAction func didPushedFBLoginButton(sender: UIButton) {
        getFBPermissions()
    }
    
    func getFBPermissions(){
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            else if result.isCancelled == true{
                print("Cancelled")
            }
            else{
                if (result.grantedPermissions.contains("public_profile") && result.grantedPermissions.contains("email")) {
                    self.getUerDateForFB()
                }
            }
        }
    }
    
    func getUerDateForFB(){
        let request=FBSDKGraphRequest(graphPath: "/me?fields=first_name,last_name,email", parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            if(error != nil){
                print(error)
                return
            }
            else if(result != nil){
                let firstName = result.valueForKey("first_name") as! String
                let lastName = result.valueForKey("last_name") as! String
                let name = firstName + lastName
                
                let email = result.valueForKey("email") as! String
                let id = result.valueForKey("id") as! String

                let dict = ["name":name, "email":email, "fb_id":id]
                
                self.performSegueWithIdentifier("SignUp", sender: dict)
            }
            else{
                print("Can't get user datas")
            }
            
        })
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
