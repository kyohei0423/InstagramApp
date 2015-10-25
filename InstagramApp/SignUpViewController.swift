//
//  UnloginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse
import FBSDKLoginKit

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    // MARK: 前画面からの受け渡し用のプロパティ
    var email:String?
    var name:String?
    var fb_id:String?
    
    var animationNow = false
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet var alertLabelTopMargin: NSLayoutConstraint!
    var alertLabelTopMarginZero: NSLayoutConstraint!
    
    @IBOutlet var iconImageViewCenterY: NSLayoutConstraint!
    var iconImageViewMovedCenterY: NSLayoutConstraint?

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: "didPushedIconImageView:")
        iconImageView.addGestureRecognizer(tapGR)
        iconImageView.layer.cornerRadius = 44
        iconImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 170/255, alpha: 1.0).CGColor
        iconImageView.layer.borderWidth = 1.0
        iconImageView.clipsToBounds = true
        
        backImageView.clipsToBounds = true
        
        emailField.text = email
        nameField.text = name
        
        emailField.delegate = self
        nameField.delegate = self
        passField.delegate = self
        
        alertLabelTopMarginZero = NSLayoutConstraint(item: alertLabelTopMargin.firstItem,
            attribute: alertLabelTopMargin.firstAttribute,
            relatedBy: alertLabelTopMargin.relation,
            toItem: alertLabelTopMargin.secondItem,
            attribute: alertLabelTopMargin.secondAttribute,
            multiplier: alertLabelTopMargin.multiplier,
            constant: 0.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        if fb_id != nil{
            self.iconImageView.af_setImageWithURL(NSURL(string: "https://graph.facebook.com/\(fb_id!)/picture?width=200&height=200")!,
                placeholderImage: nil, filter: nil,
                imageTransition: UIImageView.ImageTransition.CrossDissolve(0.5))
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
        
        ParseAccess().signUpUser(nameField.text, password: passField.text, email: emailField.text, icon: icon) { (succeeded, error) in
            if succeeded {
                print("success!!")
                self.signUpSucceeded()
            }
            else{
                self.alertLabelAnimation()
                print(error)
                if error?.domain == "InstagramAppError"{
                    switch error!.code{
                    case InstagramAppErrorType.NameNotInput.rawValue:
                        self.alertLabel.text = "名前が入力されていません"
                        break
                    case InstagramAppErrorType.EmailNotInput.rawValue:
                        self.alertLabel.text = "メールアドレスが入力されていません"
                        break
                    case InstagramAppErrorType.PasswordNotInput.rawValue:
                        self.alertLabel.text = "パスワードが入力されていません"
                        break
                    default:
                        break
                    }
                }
                else if error?.domain == "Parse"{
                    switch error!.code{
                    case PFErrorCode.ErrorInvalidEmailAddress.rawValue:
                        self.alertLabel.text = "メールアドレスが不正です"
                        break
                    case PFErrorCode.ErrorUsernameTaken.rawValue:
                        self.alertLabel.text = "すでに同じ名前のユーザーが存在します"
                        break
                    case PFErrorCode.ErrorUserEmailTaken.rawValue:
                        self.alertLabel.text = "すでに同じメールアドレスのユーザーが存在します"
                        break
                    default:
                        self.alertLabel.text = "不明なエラーです"
                        break
                    }
                }
                else{
                    self.alertLabel.text = "不明なエラーです"
                }
            }
        }
    }
    
    func alertLabelAnimation(){
        if animationNow {
            return
        }
        
        view.setNeedsUpdateConstraints()
        view.removeConstraint(alertLabelTopMargin)
        view.addConstraint(alertLabelTopMarginZero)
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
            self.animationNow = true
            self.alertLabel.alpha = 1.0
            self.view.layoutIfNeeded()
            }) { (animate) in
                self.alertLabel.alpha = 1.0
                self.view.removeConstraint(self.alertLabelTopMarginZero)
                self.view.addConstraint(self.alertLabelTopMargin)
                UIView.animateWithDuration(1.0, delay: 3.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
                    self.animationNow = true
                    self.alertLabel.alpha = 0.0
                    self.view.layoutIfNeeded()
                    }) { (animate) in
                        self.alertLabel.alpha = 0.0
                        self.animationNow = false
                }
        }
    }
    
    func signUpSucceeded(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - アイコン画像選択関連
    
    func didPushedIconImageView(sender:UITapGestureRecognizer){
        let actionSheet = UIAlertController(title: "プロフィール写真を変更", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Facebookからインポート", style: .Default, handler: { (action) in
            self.loadIconForFacebook()
        }))
        
        
        //TODO: シミュレータではカメラを動かせないので動作未検証
        /*
        actionSheet.addAction(UIAlertAction(title: "写真を撮る", style: .Default, handler: { (action) in
        self.launchCamera()
        }))
        */
        
        actionSheet.addAction(UIAlertAction(title: "ライブラリから選択", style: .Default, handler: { (action) in
            self.openCameraLibrary()
        }))
        
        presentViewController(actionSheet, animated: true) { () in
            
        }
    }
    
    // MARK: 外部SNSから読み込み
    
    func loadIconForFacebook(){
        getFBPermissions()
    }
    
    func getFBPermissions(){
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) in
            if error != nil {
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
        let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        let request=FBSDKGraphRequest(graphPath: "/me", parameters: [:], HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) in
            if(error != nil){
                print(error)
                alert.message = "Facebookからユーザ情報を取得できませんでした"
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            else if(result != nil){
                if let fb_id = result.valueForKey("id") as? String{
                    self.iconImageView.af_setImageWithURL(NSURL(string: "https://graph.facebook.com/\(fb_id)/picture?width=200&height=200")!,
                        placeholderImage: nil, filter: nil,
                        imageTransition: UIImageView.ImageTransition.CrossDissolve(0.5))
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
            dispatch_async(dispatch_get_main_queue(), { () in
                self.iconImageView.image = image
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardDidShow(sender:NSNotification){
        let keyboardFrameEnd = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        print(keyboardFrameEnd)
        if let height = keyboardFrameEnd?.height{
            view.setNeedsUpdateConstraints()
            
            view.removeConstraint(iconImageViewCenterY)
            if iconImageViewMovedCenterY != nil{
                view.removeConstraint(iconImageViewMovedCenterY!)
            }
            
            iconImageViewMovedCenterY = NSLayoutConstraint(item: iconImageViewCenterY.firstItem,
                attribute: iconImageViewCenterY.firstAttribute,
                relatedBy: iconImageViewCenterY.relation,
                toItem: iconImageViewCenterY.secondItem,
                attribute: iconImageViewCenterY.secondAttribute,
                multiplier: iconImageViewCenterY.multiplier,
                constant: -height)
            
            view.addConstraint(iconImageViewMovedCenterY!)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
                self.view.layoutIfNeeded()
                self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
            },completion:nil)
        }
    }
    
    func keyboardWillHide(sender:NSNotification){
        view.setNeedsUpdateConstraints()
        if iconImageViewMovedCenterY != nil {
            view.removeConstraint(iconImageViewMovedCenterY!)
            view.addConstraint(iconImageViewCenterY!)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === emailField {
            //textField.resignFirstResponder()
            nameField.becomeFirstResponder()
        }
        else if textField === nameField {
            //textField.resignFirstResponder()
            passField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
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
