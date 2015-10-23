//
//  NonLoginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class NonLoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var signUpView: UIView!

    @IBOutlet var arrowViewCenterIsSignUpConstraint: NSLayoutConstraint!
    var arrowViewCenterIsLoginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var arrowView: UIView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        nameField.delegate = self
        passField.delegate = self

        emailField.becomeFirstResponder()

        arrowView.backgroundColor = UIColor.clearColor()
        
        arrowViewCenterIsLoginConstraint = NSLayoutConstraint(item: arrowViewCenterIsSignUpConstraint.firstItem,
            attribute: arrowViewCenterIsSignUpConstraint.firstAttribute,
            relatedBy: arrowViewCenterIsSignUpConstraint.relation,
            toItem: loginButton,
            attribute: arrowViewCenterIsSignUpConstraint.secondAttribute,
            multiplier: arrowViewCenterIsSignUpConstraint.multiplier,
            constant: arrowViewCenterIsSignUpConstraint.constant)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - サインアップ関連
    
    @IBAction func didPushedFBSignUpButton(sender: UIButton) {
        getFBPermissions()
    }
    
    func getFBPermissions(){
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) in
            if error != nil{
                print(error)
                return
            }
            else if result.isCancelled {
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
        request.startWithCompletionHandler({ (connection, result, error) in
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUp"{
            if let view = segue.destinationViewController as? SignUpViewController{
                if sender === self.emailField {
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
    
    @IBAction func didPushedSignUpButton(sender: UIButton) {
        signUpView.hidden = false
        
        view.setNeedsUpdateConstraints()
        view.removeConstraint(self.arrowViewCenterIsLoginConstraint)
        view.addConstraint(self.arrowViewCenterIsSignUpConstraint)
        UIView.animateWithDuration(0.3, animations: { () in
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - ログイン関連
    
    @IBAction func login(sender: UIButton) {    //実際にログインする
        let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        ParseAccess().loginUser(nameField.text, password: passField.text) { (succeeded, user, error) in
            if succeeded {
                print("success!!")
                alert.title = "ログインに成功しました"
                self.presentViewController(alert, animated: true, completion: nil)
                self.loginSucceeded()
            }
            else if error != nil {
                if error!.domain == "InstagramAppError"{
                    switch error!.code{
                    case InstagramAppErrorType.NameNotInput.rawValue:
                        alert.message = "名前が入力されていません"
                        break
                    case InstagramAppErrorType.PasswordNotInput.rawValue:
                        alert.message = "パスワードが入力されていません"
                        break
                    default:
                        alert.message = "不明なエラーです"
                        break
                    }
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    alert.message = "不明なエラーです"
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            else{
                alert.message = "不明なエラーです"
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginWithFacebook(sender: UIButton) {    //実際にログインする
        let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        ParseAccess().loginUserWithFacebook { (user, isNew, error) in
            if let _error = error {
                if _error.domain == "InstagramAppError" {
                    if _error.code == InstagramAppErrorType.Canceled.rawValue {
                        print("canceled")
                        alert.title = "Facebookログインがキャンセルされました"
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    else {
                        alert.message = "不明なエラー"
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                else{
                    alert.message = "不明なエラー"
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            else if user != nil{
                if isNew == true {
                    print("success!!")
                    self.loginSucceeded()
                    alert.title = "新規ユーザーを作成し、ログインしました"
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    print("success!!")
                    self.loginSucceeded()
                    alert.title = "ログインに成功しました"
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginSucceeded(){
        print("loginSucceeded")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPushedLoginButton(sender: UIButton) {     //ログイン画面の表示
        signUpView.hidden = true
        emailField.resignFirstResponder()
        
        self.arrowView.setNeedsUpdateConstraints()
        view.removeConstraint(self.arrowViewCenterIsSignUpConstraint)
        view.addConstraint(self.arrowViewCenterIsLoginConstraint)
        UIView.animateWithDuration(0.3, animations: { () in
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === emailField{
            self.performSegueWithIdentifier("SignUp", sender: textField)
        }
        else if textField === nameField{
            passField.becomeFirstResponder()
        }
        else if textField === passField{
            passField.resignFirstResponder()
            login(loginButton)
        }
        return true
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
