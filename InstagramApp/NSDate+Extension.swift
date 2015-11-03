//
//  NSDate+Extension.swift
//  InstagramApp
//
//  Created by Seo Kyohei on 2015/11/01.
//  Copyright © 2015年 Kyohei Seo. All rights reserved.
//

import Foundation

extension NSDate {
    class func getDateTime() -> String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd HH:mm EEE"
        let dateTime = dateFormatter.stringFromDate(now)
        return dateTime
    }
}
