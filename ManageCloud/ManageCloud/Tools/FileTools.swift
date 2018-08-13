//
//  FileTools.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

/// 文件管理
let FileManag = FileManager.default
let UrlForDocument = FileManag.urls( for: .documentDirectory,
                                   in:.userDomainMask)
/// 路径
let FilePath:String = NSHomeDirectory() + "/Documents/myFolder/"



class FileTools {

    
   /// 检测沙盒是否有此文件
   ///
   /// - Parameter name: 文件名（FileName）
   /// - Returns: 是/否
   class func exist(name:String) -> Bool {
    
        let file = UrlForDocument[0].appendingPathComponent(name)
        return FileManag.fileExists(atPath: file.path)

    }
    
    /// 创建文件
    ///
    /// - Parameters:
    ///   - name: 文件名称
    ///   - baseStr: 文件内容
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    class func createFile(name:String, baseStr:String,_ scuBlock:@escaping(_ code:Bool)->(),_ failBlock:@escaping(_ size:String)->()){
        
        //let manager = FileManager.default
        
        let file = UrlForDocument[0].appendingPathComponent(name)
        print("文件: \(file)")
        let exist = FileManag.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:baseStr ,options:.ignoreUnknownCharacters)
            let createSuccess = FileManag.createFile(atPath: file.path,contents:data,attributes:nil)
            scuBlock(createSuccess)
        }else{
            
            let strz = FileTools.getFileSize(patch: file.path)
            print("文件存在")
            failBlock(strz)
        }
    }
    

    
    /// 获取文件大小
   class func getFileSize(patch:String) -> String {
        
        let attributes = try? FileManag.attributesOfItem(atPath: patch) //结果为Dictionary类型
        
//        print("创建时间：\(attributes![FileAttributeKey.creationDate]!)")
//        print("修改时间：\(attributes![FileAttributeKey.modificationDate]!)")
//        print("文件大小：\(attributes![FileAttributeKey.size]!)")

        let size = stringWithFileSize(size: attributes![FileAttributeKey.size]! as! CDouble)
    
        return size
    }
    
    /// 字节大小加单位的字符串
    ///
    /// - Parameters:
    ///   - size: 字节大小

    /// - Returns: 字节大小加单位的字符串
    class func stringWithFileSize(size:Double) -> String {
    
        var str = ""
//        if size < 1024  && type != 1{
//
////            str = String(format: "%.1fB", size)
//
//        }else
        if size < 1024 * 1024{
        
            let v = size / 1024
            str = String(format: "%.2fKB", v)
            
        }else if (size < 1024 * 1024 * 1024){
            
            let v = size / 1024 / 1024
            str = String(format: "%.2fMB", v)
            
        }
        
        return str
    }
    
    /// 下载的时候 回来的数据以KB为单位
    class func DownFileWithSize(size:Double) -> String {
        
        var str = ""
        //        if size < 1024  && type != 1{
        //
        ////            str = String(format: "%.1fB", size)
        //
        //        }else
        if size < 1024 {
            
            let v = size
            str = String(format: "%.2fKB", v)
            
        }else if (size < 1024 * 1024 ){
            
            let v = size / 1024
            str = String(format: "%.2fMB", v)
            
        }
        
        return str
    }
    
    
    /// 不带单位 纯大小
    class func getFileSizeNotKB(patch:String) -> CDouble {
        
        let attributes = try? FileManag.attributesOfItem(atPath: patch) //结果为Dictionary类型
        
        //        print("创建时间：\(attributes![FileAttributeKey.creationDate]!)")
        //        print("修改时间：\(attributes![FileAttributeKey.modificationDate]!)")
        //        print("文件大小：\(attributes![FileAttributeKey.size]!)")
        
//        let size = stringWithFileSizeNotKB(size: attributes![FileAttributeKey.size]! as! CDouble)
        
        return attributes![FileAttributeKey.size]! as! CDouble
    }
    
    /// 转换成KB (上传以KB为单位)
    class func toKB (size:String) ->Double {
        
        if size.has("KB") {
         let  sizeKB = size.replacingOccurrences(of: ["KB"], with: "")
            return  Double(sizeKB)!
        }else if size.has("MB") {
            
            let  sizeKB = size.replacingOccurrences(of: ["MB"], with: "")
            let fileSize = Double(sizeKB)! * 1024
            return fileSize
        }else if size.has("B"){
            let  sizeKB = size.replacingOccurrences(of: ["B"], with: "")
            let fileSize = Double(sizeKB)! / 1024
            return fileSize
        }else{
            
            let  sizeKB = size.replacingOccurrences(of: ["GB"], with: "")
            let fileSize = Double(sizeKB)! * 1024 * 1024
            return fileSize
        }
    }
    
    /// 转MB
//    func toMB(size:Double) -> String {
//        
//        var str = ""
//        if size < 1024 {
//            
//            str = String(format: "%.1fB", size)
//            
//        }else if size < 1024 * 1024{
//            
//            let v = size / 1024
//            str = String(format: "%.2fKB", v)
//            
//        }else if (size < 1024 * 1024 * 1024){
//            
//            let v = size / 1024 / 1024
//            str = String(format: "%.2fMB", v)
//            
//        }
//        
//        return str
//    }
    
    /// 不带单位
//    class func stringWithFileSizeNotKB(size:CDouble) -> CDouble {
//
//       // var str = ""
//        if size < 1024 {
//
//            str = String(format: "%.1f", size)
//
//        }else if size < 1024 * 1024{
//
//            let v = size / 1024
//            str = String(format: "%.2f", v)
//
//        }else if (size < 1024 * 1024 * 1024){
//
//            let v = size / 1024 / 1024
//            str = String(format: "%.2f", v)
//
//        }
//
//        return str
//    }
}
