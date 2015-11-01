//
//  SignUpView.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/22.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class SignUpView: UIView {
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
    
    var animationNow = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        iconImageView.layer.cornerRadius = 44
        iconImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 170/255, alpha: 1.0).CGColor
        iconImageView.layer.borderWidth = 1.0
        iconImageView.clipsToBounds = true
        
        backImageView.clipsToBounds = true
        
        alertLabelTopMarginZero = NSLayoutConstraint(item: alertLabelTopMargin.firstItem,
            attribute: alertLabelTopMargin.firstAttribute,
            relatedBy: alertLabelTopMargin.relation,
            toItem: alertLabelTopMargin.secondItem,
            attribute: alertLabelTopMargin.secondAttribute,
            multiplier: alertLabelTopMargin.multiplier,
            constant: 0.0)
    }
    
    func alertLabelAnimation(message:String){
        if animationNow {
            return
        }
        alertLabel.text = message
        
        setNeedsUpdateConstraints()
        removeConstraint(alertLabelTopMargin)
        addConstraint(alertLabelTopMarginZero)
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
            self.animationNow = true
            self.alertLabel.alpha = 1.0
            self.layoutIfNeeded()
            }) { (animate) in
                self.alertLabel.alpha = 1.0
                self.removeConstraint(self.alertLabelTopMarginZero)
                self.addConstraint(self.alertLabelTopMargin)
                UIView.animateWithDuration(1.0, delay: 3.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
                    self.animationNow = true
                    self.alertLabel.alpha = 0.0
                    self.layoutIfNeeded()
                    }) { (animate) in
                        self.alertLabel.alpha = 0.0
                        self.animationNow = false
                }
        }
    }
    
    func shrinkBackImageViewHeightAnimation(height:CGFloat){
        self.setNeedsUpdateConstraints()
        
        self.removeConstraint(iconImageViewCenterY)
        if iconImageViewMovedCenterY != nil{
            self.removeConstraint(iconImageViewMovedCenterY!)
        }
        
        iconImageViewMovedCenterY = NSLayoutConstraint(item: iconImageViewCenterY.firstItem,
            attribute: iconImageViewCenterY.firstAttribute,
            relatedBy: iconImageViewCenterY.relation,
            toItem: iconImageViewCenterY.secondItem,
            attribute: iconImageViewCenterY.secondAttribute,
            multiplier: iconImageViewCenterY.multiplier,
            constant: -height)
        
        self.addConstraint(iconImageViewMovedCenterY!)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () in
            self.layoutIfNeeded()
            self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
            },completion:nil)
    }
}
