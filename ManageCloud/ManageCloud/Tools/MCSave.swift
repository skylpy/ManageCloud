//
//  MCSave.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit


class MCSave: NSObject {
    /// 保存密码
    let SavePassWords = "SavePassWords"
    let isLogin = "isLogin"
    
    
    class func getLocalLibraryPath() -> String {
        let fileManager = FileManager.default
        let fullPath = DocumentPath.appending("LocalLibrary")
        if !fileManager.fileExists(atPath: fullPath) {
            do{
                try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch{}
            
        }
        return fullPath
    }
    
    // MARK: - UserDefault
    
    //用于非基本类型存储：model要遵循Codable协议
    class func saveData<T>(Model model: T?, withKey key:String) where T : Encodable{
//        let data = NSKeyedArchiver.archivedData(withRootObject: model) as Data
        if model == nil {
            UserDefaults.standard.set(nil, forKey: key)
            UserDefaults.standard.synchronize()
        }
        do {
            let data = try JSONEncoder().encode(model)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
        }
    }
    
    
    
    class func getDataWithKey<T>(_ type: T.Type, key: String ) -> Any? where T : Decodable{
        let data = UserDefaults.standard.object(forKey: key)
        if data == nil{
            return nil
        }
        do {
            let model = try JSONDecoder().decode(type, from: data as! Data)
            return model
        } catch {
            return nil
        }
    }
    
    //仅限基本类型存储
    class func saveData(Basic basic: Any, withKey key:String){
        let data = NSKeyedArchiver.archivedData(withRootObject: basic) as Data
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    
    class func getDataWithKey(key: String) -> Any?{
        let data = UserDefaults.standard.object(forKey: key)
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
    }
    
    
    class func removeObjectAndKey(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: - 沙盒
    
    //仅限基本类型存储
    class func saveData(Model model: Any, AppendPath path:String) {
        let filePath = DocumentPath.appending(path)
        NSKeyedArchiver.archiveRootObject(model, toFile: filePath)
    }
    
    class func getData(Path path: String) -> Any? {
        let filePath = DocumentPath.appending(path)
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
    }
    
    
    
}
