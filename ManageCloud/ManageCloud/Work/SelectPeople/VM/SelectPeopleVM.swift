//
//  SelectPeopleVM.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class SelectPeopleVM {
    
    
    func askForPersonList(_ sucBlock:@escaping ([personModel]) -> ()) {
        var params = paramDic()
        NetTool.request(type: .POST, urlSuffix: PersonList, paramters: nil, successBlock: { (resSuc) in
            guard let personArr = resSuc.results as? NSArray  else{return}
            if let personModelArr = [personModel].deserialize(from: personArr )
            {
                sucBlock(personModelArr as! [personModel])
            }
            else{
                HUD.flash(.label("无下属"), delay: 1.0)
            }
            
        }) { (resFail) in
             HUD.flash(.labeledError(title: nil, subtitle: resFail.remark), delay: 1.0)
        }
    }
    
    func sortByDNameWithArray(_ arr: [personModel]) -> [(String, [personModel])] {
        var DNameSet: Set<String> = []
        //去重
        for model in arr{
            DNameSet.insert(model.DeptName!)
        }
        var newPersonTuple: [(dname: String, personArr:[personModel])] = []
        for dep in DNameSet{
            var DArr = [personModel]()
            var singleTuple = (dep,DArr)
            newPersonTuple.append(singleTuple)
        }
        for model in arr{
            for (offset: index, element: (dname: dname, personArr: var personArr)) in newPersonTuple.enumerated(){
                if dname == model.DeptName!{
                    personArr.append(model)
                    newPersonTuple[index].personArr = personArr
                    break
                }
            }
        }
        return newPersonTuple
    }
    
    func sortObjectsAccordingToInitial(_ arr:[personModel]) -> [[personModel]] {
        // 初始化UILocalizedIndexedCollation
        let collation = UILocalizedIndexedCollation.current()
        //得出collation索引的数量，这里是27个（26个字母和1个#）
        let sectionTitlesCount: Int = collation.sectionTitles.count
        //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
        var newSectionsArray = [[personModel]]()
        
        //初始化27个空数组加入newSectionsArray
        for index in 0..<sectionTitlesCount{
            let sectionArr = [personModel]()
            newSectionsArray.append(sectionArr)
        }
        
        //将每个名字分到某个section下
        for model in arr{
            //获取First属性的值所在的位置
            let sectionNumber = collation.section(for: model, collationStringSelector: #selector(getter: personModel.FirstName))
            //把name为“林丹”加入newSectionsArray中去
            var sectionNames = newSectionsArray[sectionNumber]
            sectionNames.append(model)
            newSectionsArray[sectionNumber] = sectionNames
            
        }
        
        //对每个section中的数组按照name属性排序
        for index in 0..<sectionTitlesCount{
            let personArrayForSection = newSectionsArray[index]
            let sortedPersonArrayForSection = collation.sortedArray(from: personArrayForSection, collationStringSelector: #selector(getter: personModel.EINAME)) as? [personModel]
            newSectionsArray[index] = sortedPersonArrayForSection ?? [personModel]()
        }
        
        //删除空的数组
        var finalArr = [[personModel]]()
        for index in 0..<sectionTitlesCount{
            if newSectionsArray[index].count != 0{
                finalArr.append(newSectionsArray[index])
            }
        }
        return finalArr
    }
    
    

}
