//
//  UIImage+Extension.swift
//  WBSwift
//
//  Created by Paul on 2017/1/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// 创建头像图像（裁制圆角）
    ///
    /// - parameter size:      尺寸
    /// - parameter backColor: 背景颜色
    ///
    /// - returns: 裁切后的图像
    func xj_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// 生成指定大小的不透明图象
    ///
    /// - parameter size:      尺寸
    /// - parameter backColor: 背景颜色
    ///
    /// - returns: 图像
    func xj_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    //图片上写字
    class func DrawText(_ text: String, Image: UIImage) -> UIImage{
        let font = UIFont(fontName: kRegFont, size: 12)
        let color = BlueColor
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
        
        let size = CGSize.init(width: Image.size.width, height: Image.size.height) //画布大小
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        Image.draw(at: CGPoint.init(x: 0, y: 0))
        
        //创建一个上下文对象
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return Image
        }
        context.drawPath(using: .stroke)
        let nstext = text as? NSString
        //计算出文字的宽度 设置控件限制的最大size为图片的size
        let textSize = nstext?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        // 画文字 让文字处于居中模式
        nstext?.draw(at: CGPoint.init(x: (size.width - (textSize?.width)!) / 2, y: (size.height - (textSize?.height)!) / 2 - 2), withAttributes: attributes)
        // 返回绘制的新图形
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return Image
        }
        UIGraphicsEndImageContext()
        
        return newImage

    }
}
