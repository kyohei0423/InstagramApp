//
//  UnloginViewController.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/15.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGR = UITapGestureRecognizer(target: self, action: "didPushedIconImageView:")
        iconImageView.addGestureRecognizer(tapGR)
        iconImageView.layer.cornerRadius = 44
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 170/255, alpha: 1.0).CGColor
        iconImageView.layer.borderWidth = 3.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPushedSignInButton(sender: AnyObject) {
        let icon = iconImageView.image
        
        ParseAccess().createUser(NameField.text, password: PassField.text, email: EmailField.text, icon: icon) { (succeeded, error) -> Void in
            if succeeded == true{
                print("success!!")
            }
            else{
                print(error)
            }
        }
    }
    
    func didPushedIconImageView(sender:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
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
