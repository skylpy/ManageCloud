//
//  AnnouncementViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class AnnouncementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var vm:AnnouncementVM = AnnouncementVM()
    var dateSource:[AnnouncementModel] = [AnnouncementModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "公告"
        self.initTableView()
    }
    
    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "AnnouncementCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 155
        
        self.vm.askForAnnouncementList ({ (modelAry) in
            
            self.dateSource = modelAry
            
            if self.dateSource.count == 0{
                HUD.flash(.label("暂无公告"), onView: self.view, delay: 1.0)
            }
            self.tableView.reloadData()
        }){}
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AnnouncementCell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as! AnnouncementCell
        let model:AnnouncementModel = self.dateSource[indexPath.section]
        
        cell.setViewValue(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = AnnouncementDetailVC()
        let model:AnnouncementModel = self.dateSource[indexPath.section]
        vc.strTid = model.Tid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
