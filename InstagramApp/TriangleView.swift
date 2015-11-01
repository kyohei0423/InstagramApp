//
//  TriangleView.swift
//  InstagramApp
//
//  Created by 井上 龍一 on 2015/10/17.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.whiteColor().setFill()
        let ctx = UIGraphicsGetCurrentContext()
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        CGContextMoveToPoint(ctx, width / 2, 0)
        CGContextAddLineToPoint(ctx, width, height)
        CGContextAddLineToPoint(ctx, 0, height)
        
        CGContextFillPath(ctx)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
