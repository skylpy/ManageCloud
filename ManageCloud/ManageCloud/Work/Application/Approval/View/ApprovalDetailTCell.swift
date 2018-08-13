//
//  ApprovalDetailTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

let ApproveTableTCellID = "ApproveTableTCellID"


let ReloadApproveTableHeight = "ReloadApproveTableHeight"

class ApprovalDetailTCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    var data: [String] = []{
        didSet{
            var totalHeight:CGFloat = 0.0
            for string in data {
                let height = CalculateFrame.getHeigh(labelStr: string, font: UIFont.init(fontName: kRegFont, size: 16), width: KWidth - 110)
                totalHeight += (height + 6)
            }
            tableHeight.constant = totalHeight
            Table.reloadData()
        }
    }
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var Table: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.font = UIFont.init(fontName: kRegFont, size: 17)
        nameLB.textColor = DarkTitleColor
       
        
        Table.delegate = self
        Table.dataSource = self
        Table.estimatedRowHeight = 28.0
        Table.register(UINib.init(nibName: "ApproveTableTCell", bundle: nil), forCellReuseIdentifier: ApproveTableTCellID)
        tableHeight.constant = 100
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApproveTableTCellID, for: indexPath) as! ApproveTableTCell
        cell.contentLB.text = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
