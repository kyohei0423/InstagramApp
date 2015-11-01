//
//  UnloginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    private let model = SignUpViewModel()
    
    // MARK: 前画面からの受け渡し用のプロパティ
    var email:String?
    var name:String?
    var fb_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SignUpView
        
        view.emailField.text = email
        view.nameField.text = name
        
        view.emailField.delegate = self
        view.nameField.delegate = self
        view.passField.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: "didPushedIconImageView:")
        view.iconImageView.addGestureRecognizer(tapGR)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        if fb_id != nil {
            view.iconImageView.getUrlImageAsynchronous("https://graph.facebook.com/\(fb_id!)/picture?width=200&height=200", complitionHander: nil)
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
        let view = self.view as! SignUpView
        let icon = view.iconImageView.image
        
        model.signUp(view.nameField.text, password: view.passField.text, email: view.emailField.text, icon: icon) { (succeeded, error) in
            if succeeded {
                print("success!!")
            }
            else{
                print(error)
                var message = "不明なエラーです"
                if error?.domain == "InstagramAppError"{
                    switch error!.code{
                    case InstagramAppErrorType.NameNotInput.rawValue:
                        message = "名前が入力されていません"
                        break
                    case InstagramAppErrorType.EmailNotInput.rawValue:
                        message = "メールアドレスが入力されていません"
                        break
                    case InstagramAppErrorType.PasswordNotInput.rawValue:
                        message = "パスワードが入力されていません"
                        break
                    default:
                        break
                    }
                }
                else if error?.domain == "Parse"{
                    switch error!.code{
                    case PFErrorCode.ErrorInvalidEmailAddress.rawValue:
                        message = "メールアドレスが不正です"
                        break
                    case PFErrorCode.ErrorUsernameTaken.rawValue:
                        message = "すでに同じ名前のユーザーが存在します"
                        break
                    case PFErrorCode.ErrorUserEmailTaken.rawValue:
                        view.alertLabel.text = "すでに同じメールアドレスのユーザーが存在します"
                        break
                    default:
                        break
                    }
                }
                let view = self.view as! SignUpView
                view.alertLabelAnimation(message)
            }
        }
    }
    
    func signUpSucceeded(){
        
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
        actionSheet.addAction(UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.Default, handler: { (action) in
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
        model.getIconImage(self) { (image, error) -> Void in
            guard image != nil && error == nil else{
                print("error:loadIconForFacebook()")
                return
            }
            if image != nil {
                let view = self.view as! SignUpView
                dispatch_async(dispatch_get_main_queue(), { () in
                    view.iconImageView.image = image
                })
            }
        }
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
        let view = self.view as! SignUpView
        if info[UIImagePickerControllerOriginalImage] == nil {
            print("pickerView error")
        }
        else{
            let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            dispatch_async(dispatch_get_main_queue(), { () in
                view.iconImageView.image = image
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardDidShow(sender:NSNotification){
        let keyboardFrameEnd = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        print(keyboardFrameEnd)
        if let height = keyboardFrameEnd?.height{
            let view = self.view as! SignUpView
            view.shrinkBackImageViewHeightAnimation(height)
        }
    }
    
    func keyboardWillHide(sender:NSNotification){
        let view = self.view as! SignUpView
        view.setNeedsUpdateConstraints()
        if view.iconImageViewMovedCenterY != nil {
            view.removeConstraint(view.iconImageViewMovedCenterY!)
            view.addConstraint(view.iconImageViewCenterY!)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let view = self.view as! SignUpView
        if textField === view.emailField {
            view.nameField.becomeFirstResponder()
        }
        else if textField === view.nameField {
            view.passField.becomeFirstResponder()
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
