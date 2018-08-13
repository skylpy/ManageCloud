//
//  EmailSenderViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EmailSenderViewController: EmailReceiptViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib.init(nibName: "EmailReceiptCell", bundle: nil), forCellReuseIdentifier: "EmailReceiptCell")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
