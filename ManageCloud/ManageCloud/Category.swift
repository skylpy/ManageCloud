//
//  Category.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import BFKit

extension UIView{
    
    func addTapTarget(_ target: Any, Selector: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: Selector)
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
}


extension UIImageView{
    /// base字符串转图片
    func setImageWithBase64String(imgStr: String?, isAvatar: Bool) {
        
        if isAvatar {
            self.image = LoadImage("headPlaceHolder")
        }
        else{
            self.image = LoadImage("imgPlaceHolder")
        }
        if (imgStr?.isEmpty)! { return }
        runInBackground {
            let decodedData = NSData(base64Encoded:imgStr!, options:NSData.Base64DecodingOptions())
            let decodedimage = UIImage(data: decodedData! as Data)
            runOnMainThread {
                if decodedimage != nil{
                    self.image = decodedimage!
                }
                
            }
        }
        
    }
    
    
}


extension UIImage{
    /// 图片转base字符串
    func base64StrForImg() -> String{
        
        let imageData = UIImageJPEGRepresentation(self, 0.8)
        let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        return base64String!
        
    }
    
    
    func zip() -> UIImage{
        //进行图像尺寸的压缩
        let imageSize = self.size //取出要压缩的image尺寸
        var width = imageSize.width //图片宽度
        var height = imageSize.height //图片高度
        ///<1>.缩处理
         //1.宽高大于1280(宽高比不按照2来算，按照1来算)
        if width>1280 && height>1280 {
            if width>height {
                let scale: CGFloat = height/width;
                width = 1280;
                height = width*scale;
            }else{
                let scale: CGFloat = width/height;
                height = 1280;
                width = height*scale;
            }
            //2.宽大于1280高小于1280
        }
        else if width>1280 && height<1280 {
            let scale: CGFloat = height/width;
            width = 1280;
            height = width*scale;
            //3.宽小于1280高大于1280
        }else if width<1280 && height>1280 {
            let scale: CGFloat = width/height;
            height = 1280;
            width = height*scale;
            //4.宽高都小于1280
        }else{
        }
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ///<2>压处理
        //进行图像的画面质量压缩
        var data = UIImageJPEGRepresentation(newImage!, 1.0)!
        if data.count>100*1024 {
            if data.count>1024*1024 {//1M以及以上
                data = UIImageJPEGRepresentation(newImage!, 0.7)!;
                DPrint("size1_____\(Double(data.count)/1024/1024.0)")
            }else if data.count>512*1024 {//0.5M-1M
                data = UIImageJPEGRepresentation(newImage!, 0.8)!;
                DPrint("size2_____\(Double(data.count)/1024/1024.0)")
            }else if data.count>200*1024 {
                //0.25M-0.5M
                data = UIImageJPEGRepresentation(newImage!, 0.9)!;
                DPrint("size3_____\(Double(data.count)/1024/1024.0)")
            }
        }
        return UIImage.init(data: data)!;
    }
}

