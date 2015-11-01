//
//  PasswordResetViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/17.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //このViewControllerがRootViewControllerで無いならば
        //Cancelボタンはいらないので消す
        if self.navigationController?.viewControllers.first !== self {
            self.navigationItem.leftBarButtonItem = nil
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPushedSendButton(sender: UIButton) {
        let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        ParseAccess().resetPassword(emailField.text) { (succeeded, error) in
            if succeeded {
                print("success!!")
                alert.title = "パスワードをリセットしました"
                alert.message = "メールに記載されている\nURLから再設定を行ってください"
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else if error != nil {
                if error!.domain == "InstagramAppError"{
                    switch error!.code{
                    case InstagramAppErrorType.EmailNotInput.rawValue:
                        alert.message = "メールアドレスが入力されていません"
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
    
    @IBAction func didPushedCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
