//
//  SelectSearchVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SelectSearchVC: BaseSearchVC {
    
    //单选、多选
    var type: selectType = .single
    
    //搜索内容
    var searchText: String = ""
    
    //总数据
    var netArr: [(String, [personModel])] = [(String, [personModel])] ()
    
    //搜索结果
    var searchData = [personModel]()
    
    //传回显示的数组
    var multiSelectedShowBlock:((_ personArr:[(String, [personModel])]) -> ())?
    //添加移除选人数组
    var multiSelectedBlock:((personModel) -> ())?
    
    var singleSelectedBlock:((personModel) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        Table.register(UINib.init(nibName: "SelectTCell", bundle: nil), forCellReuseIdentifier: SelectTCellID)
        searchView.searchField.rac_textSignal().take(until: self.rac_willDeallocSignal()).subscribeNext { [weak self](text) in
            self?.searchData = []
            self?.Table.reloadData()
            if let search = text {
                self?.searchText = search as String
                if (self?.searchText.isEmpty)!{
                    self?.searchView.count = "0"
                    return
                }
                self?.loadData()
            }
            
            
        }
        searchView.searchField.becomeFirstResponder()
    }
    
    fileprivate func loadData() {
        for (_, personArr) in netArr{
            for person in personArr{
                if (person.EINAME?.contains(self.searchText))!{
                    searchData.append(person)
                }
            }
        }
        self.searchView.count = "\(searchData.count)"
        Table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = searchData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTCellID, for: indexPath) as! SelectTCell
        cell.selectionStyle = .gray
        cell.type = type
        cell.personModel = model
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = searchData[indexPath.row]
        if type == .multi {
            for (index,(_, personArr)) in netArr.enumerated() {
                var hasHim = false
                for (index1, person) in personArr.enumerated(){
                    if person.EINAME == model.EINAME{
                        hasHim = true
                        person.isSelete = !person.isSelete
                        multiSelectedBlock!(person)
                        var newPersonArr = personArr
                        newPersonArr[index1] = person
                        netArr[index].1 = newPersonArr
                        break
                    }
                }
                if hasHim{break}
            }
            multiSelectedShowBlock!(netArr)
            navigationController?.popViewController(animated: true)
        }
        else{
            singleSelectedBlock!(model)
        }
    }
}
