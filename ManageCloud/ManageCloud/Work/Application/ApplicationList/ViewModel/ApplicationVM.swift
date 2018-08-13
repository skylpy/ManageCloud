//
//  ApplicationVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApplicationVM: NSObject {

    /// 请求审批列表
    func askForApplicationList(_ scuBlock:@escaping(_ model:[ApplicationModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        let accountName = HSInstance.share.userInfo?.ACCOUNTNAME
        let OID = HSInstance.share.userInfo?.EIOID
        params.updateValue(accountName ?? "", forKey: "accountName")
        params.updateValue(OID ?? "", forKey: "eitid")
        
        NetTool.request(type: .POST, urlSuffix: ApprovalListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [ApplicationModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [ApplicationModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    /// 请求我的工作流
    func askForMineWorkList( type:String,_ scuBlock:@escaping(_ model:[(String, [ApplicationMineModel])],_ oldMOdel: [ApplicationMineModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        let OID = HSInstance.share.userInfo?.EIOID
        params.updateValue(OID ?? "", forKey: "eitid")
        
        NetTool.request(type: .POST, urlSuffix: MyWorkFlowListURL, paramters: params, successBlock: { (success) in
            
            guard let Arr = success.results as? NSArray  else{return}
            
            let dateSouce = [ApplicationMineModel].deserialize(from: Arr )
            
            var fSource = [ApplicationMineModel]()
            
            if type == "成功"{
              fSource =  self.changeSuccess(arr: dateSouce! as! [ApplicationMineModel])
                
                let source = self.sortByDNameWithArray(fSource)
                scuBlock(source,fSource)
            }else if type == "失败"{
                fSource = self.changeFail(arr: dateSouce! as! [ApplicationMineModel])
                let source = self.sortByDNameWithArray(fSource)
                scuBlock(source,fSource)
            }else{
                //全部
                let source = self.sortByDNameWithArray(dateSouce! as! [ApplicationMineModel])
                scuBlock(source,dateSouce! as! [ApplicationMineModel])
            }
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    /// 成功的状态工作流
    func changeSuccess(arr: [ApplicationMineModel]) -> [ApplicationMineModel]  {
        var temp = arr
        
        for item in temp {
            
            if item.GZLSTATE != "成功"{
                temp.remove(item)
            }
            
        }
        return temp
    }
    
    func changeFail(arr: [ApplicationMineModel]) -> [ApplicationMineModel]  {
        var temp = arr
        
        for item in temp {
            
            if item.GZLSTATE != "失败"{
                temp.remove(item)
            }
            
        }
        return temp
    }
    
    /// 根据时间做分组
    func sortByDNameWithArray(_ arr: [ApplicationMineModel]) -> [(String, [ApplicationMineModel])] {
        var DNameSet: Array<String> = []
        //去重
        for model in arr{
            //"2018/6/2 9:11:55"
            let str = model.BDATE
            let ary = str?.components(separatedBy: " ")
            model.BDATE = ary![0]
//            DNameSet.insert(ary![0])
            
            if !DNameSet.contains(ary![0])
            {
                DNameSet.append(ary![0])
            }
        }
        var newPersonTuple: [(dname: String, personArr:[ApplicationMineModel])] = []
        for dep in DNameSet{
            let DArr = [ApplicationMineModel]()
            let singleTuple = (dep,DArr)
            newPersonTuple.append(singleTuple)
        }
        for model in arr{
            for (offset: index, element: (dname: dname, personArr: var personArr)) in newPersonTuple.enumerated(){
                if dname == model.BDATE!{
                    personArr.append(model)
                    newPersonTuple[index].personArr = personArr
                    break
                }
            }
        }
        return newPersonTuple
    }
    
}
