//
//  PassApplicationViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView

class PassApplicationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var context: GrowingTextView!
    
    /// 通过，拒绝，同意
    var titleStr = "通过"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = titleStr
        if titleStr == "通过" {
            setTableView()
        }
        
        self.context.placeholder = "  请输入审批意见"
        self.context.font = UIFont.systemFont(ofSize: 16.0)
        
    }
    
    func setTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "PassApplicationViewCell", bundle: nil), forCellReuseIdentifier: "PassApplicationViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PassApplicationViewCell = tableView.dequeueReusableCell(withIdentifier: "PassApplicationViewCell") as! PassApplicationViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vc = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 16), backgroundColor: UIColor.clear)
        return vc
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
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
