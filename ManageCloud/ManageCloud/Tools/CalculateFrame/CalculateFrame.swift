//
//  CalculateFrame.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit


class CalculateFrame: NSObject {
    
    class func getHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        
        let dic = NSDictionary(object: font, forKey: kCTFontAttributeName as! NSCopying)
        
        let maxHeight = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: (dic as! [NSAttributedStringKey : Any]), context: nil).size.height
        
        return maxHeight
        
    }
    
    
   class func getWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        
        let dic = NSDictionary(object: font, forKey: kCTFontAttributeName as! NSCopying)
        
        let maxWidth = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: (dic as! [NSAttributedStringKey : Any]), context: nil).size.width
        
        return maxWidth
        
    }
    
    
    
}
