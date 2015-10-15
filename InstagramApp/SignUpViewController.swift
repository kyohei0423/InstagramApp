//
//  UnloginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse
class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    // MARK: 前画面からの受け渡し用のプロパティ
    var email:String?
    var name:String?
    var fb_id:String?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = NSUserDefaults.standardUserDefaults().objectForKey("LoginUser") as? [String:String]{
            let username = user["username"]!
            let password = user["password"]!
            ParseAccess().loginUser(username, password: password, complitionHander: nil)
        }

        let tapGR = UITapGestureRecognizer(target: self, action: "didPushedIconImageView:")
        iconImageView.addGestureRecognizer(tapGR)
        iconImageView.layer.cornerRadius = 44
        iconImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 170/255, alpha: 1.0).CGColor
        iconImageView.layer.borderWidth = 3.0
        iconImageView.clipsToBounds = true

        emailField.text = email
        nameField.text = name
        if fb_id != nil{
            self.iconImageView.getUrlImageAsynchronous("https://graph.facebook.com/\(fb_id!)/picture?width=200&height=200", complitionHander: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - サインアップ関連
    @IBAction func didPushedSignInButton(sender: AnyObject) {
        let icon = iconImageView.image
        
        ParseAccess().signUpUser(nameField.text, password: passField.text, email: emailField.text, icon: icon) { (succeeded, error) -> Void in
            if succeeded == true{
                print("success!!")

            }
            else{
                print(error)
            }
        }
    }
    
    // MARK: - アイコン画像選択関連
    
    func didPushedIconImageView(sender:UITapGestureRecognizer){
        let actionSheet = UIAlertController(title: "プロフィール写真を変更", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Facebookからインポート", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.loadIconForFacebook()
        }))
        
        
        //TODO: シミュレータではカメラを動かせないので動作未検証
        /*
        actionSheet.addAction(UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.launchCamera()
        }))
        */
        
        actionSheet.addAction(UIAlertAction(title: "ライブラリから選択", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.openCameraLibrary()
        }))
        
        presentViewController(actionSheet, animated: true) { () -> Void in
            
        }
    }
    
    // MARK: 外部SNSから読み込み
    
    func loadIconForFacebook(){
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
        let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        let request=FBSDKGraphRequest(graphPath: "/me", parameters: [:], HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            if(error != nil){
                print(error)
                alert.message = "Facebookからユーザ情報を取得できませんでした"
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            else if(result != nil){
                if let id = result.valueForKey("id") as? String{
                    self.iconImageView.getUrlImageAsynchronous("https://graph.facebook.com/\(id)/picture?width=200&height=200", complitionHander: { (succeeded, error) -> Void in
                        if succeeded == false{
                            if error != nil{
                                alert.message = "画像を取得できませんでした"
                            }
                            else{
                                alert.message = "予期せぬエラーが発生しました"
                            }
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
            else{
                alert.message = "Facebookからユーザ情報を取得できませんでした"
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: imagePicker使用部分
    func openCameraLibrary(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func launchCamera(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] == nil {
            print("pickerView error")
        }
        else{
            let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.iconImageView.image = image
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
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
