//
//  SingleSelectVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD


class personModel: NSObject, HandyJSON {
    //人员序号
    var EITID: String? = ""
    //销售人员名
    @objc var NAME: String? = ""
    @objc var EINAME: String? = ""
    
    //部门名称
    var DeptName: String? = ""
    //人员编号
    var OID: String? = ""
    var EIOID: String? = ""
    
    //性别
    var Sex: String? = ""
    
    var Photo: String? = ""
    @objc var FirstName: String = ""
    
    var isSelete: Bool = false
    
    required override init() {}
    
    //didSet方法在转模型初始化时不会调用，后面需要手动赋值
    //let Oid = model.OID
    //model.OID = Oid
}

enum selectType {
    case single
    case multi
}

enum personType {
    case subPerson //权限下的人员 指挥
    case AllPerson  //公共人员列表 签到、日志
}

let SelectTCellID = "SelectTCellID"

class SelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //搜索框
    lazy var searchBar: MCSearchBar = {
        let bar = Bundle.main.loadNibNamed("MCSearchBar", owner: nil, options: nil)?.first as! MCSearchBar
        bar.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: searchbarHeight)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapSearch))
        bar.addGestureRecognizer(tap)
        return bar
    }()

    var selectedArr: [personModel] = [personModel]()
    //请求的人员
    var netArr: [(String, [personModel])] = [(String, [personModel])] ()
    
    //全部人员VM
    lazy var selectVM = SelectPeopleVM()
    
    //单选、多选
    var type: selectType = .single
    
    var personType: personType = .subPerson
    
    
    var finishSelectBlock: ((_ OidArr: [personModel]) -> ())?
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: searchbarHeight, width: KWidth, height: KHeight - KNaviBarH - KStatusBarH - searchbarHeight))
        table.register(UINib.init(nibName: "SelectTCell", bundle: nil), forCellReuseIdentifier: SelectTCellID)
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.tintColor = BlueColor
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchBar.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: searchbarHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    
    fileprivate func initUI() {
        view.addSubview(searchBar)
        view.addSubview(Table)
        if self.type == .multi {
            title = "多选"
            let finishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 24), title: "确定")
            finishBtn.rac_signal(for: .touchUpInside).take(until: self.rac_willDeallocSignal()).subscribeNext({ [weak self] (x) in
                
                if (self?.selectedArr.count)! > 0 {
                    self?.finishSelectBlock!((self?.selectedArr)!)
                    self?.navigationController?.popViewController()
                }else {
                    HUD.flash(.label("至少选择一个人"), delay: 2)
                }
                
            }) {}
            let barItem = UIBarButtonItem.init(customView: finishBtn)
            navigationItem.rightBarButtonItem = barItem
        }
        else{
            title = "单选"
        }
    }
    
    @objc fileprivate func tapSearch() {
        let vc = SelectSearchVC()
        vc.type = type
        vc.netArr = netArr
        vc.singleSelectedBlock = { (person) in
            self.finishSelectBlock!([person])
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.popViewController(animated: false)
            
        }
        vc.multiSelectedShowBlock = { (newNetArr) in
            self.netArr = newNetArr
            self.Table.reloadData()
        }
        
        vc.multiSelectedBlock = { (model) in
            if !model.isSelete {
                for person in self.selectedArr{
                    if person.EIOID! == model.EIOID!{
                        self.selectedArr.remove(person)
                        break;
                    }
                }
            }
            else{
                self.selectedArr.append(model)
            }
            
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func loadData() {
        if personType == .subPerson{
            HomeVM.GetAuthorPeopleList(sucBlock: { (personArr) in
                
                guard let source = personArr else{return}
                
                //默认选择
                if self.selectedArr.count > 0{
                    for model in self.selectedArr{
                        for models in source{
                            if model.EIOID! == models.EIOID!{
                                models.isSelete = true
                                break
                            }
                        }
                    }
                }
                
                self.netArr = (self.selectVM.sortByDNameWithArray(source))
                
                self.Table.reloadData()
            }) { (failRes) in
            }
        }
        else{
            selectVM.askForPersonList {[weak self] (sourceData) in
                let source = sourceData
                
                //默认选择
                if (self?.selectedArr.count)! > 0{
                    for model in (self?.selectedArr)!{
                        for models in source{
                            if model.EIOID! == models.EIOID!{
                                models.isSelete = true
                                break
                            }
                        }
                    }
                }
                
                self?.netArr = (self?.selectVM.sortByDNameWithArray(source))!
                
                self?.Table.reloadData()
                
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = self.netArr[section]
        return sectionData.1.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.netArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = self.netArr[indexPath.section].1
        let model = sectionData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTCellID, for: indexPath) as! SelectTCell
        cell.selectionStyle = .gray
        cell.type = type
        cell.personModel = model
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionData = self.netArr[indexPath.section].1
        let model = sectionData[indexPath.row]
        switch self.type {
        case .single:
            selectedArr.append(model)
            finishSelectBlock!(self.selectedArr)
            navigationController?.popViewController()
        default:
            model.isSelete = !model.isSelete
            if model.isSelete{
                selectedArr.append(model)
            }
            else{
                for person in selectedArr{
                    if person.EIOID! == model.EIOID!{
                        selectedArr.remove(person)
                        break;
                    }
                }
                
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
   
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = self.netArr[section].1
        let model = sectionData.first
        let header = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 20))
        header.backgroundColor = COLOR(red: 238, green: 238, blue: 238)
        header.textColor = DarkGrayTitleColor
        header.font = UIFont.init(fontName: kRegFont, size: 15)
        let sectionTitle = model!.DeptName!
//        //不是数字
//        if (model?.FirstName.countNumbers())! == 0{
//            sectionTitle = (model?.FirstName)!
//        }
        header.text = "   " + "\(sectionTitle)"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    

    
    

}

