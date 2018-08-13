//
//  WorkAnounceTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import RollingNotice_Swift



class WorkAnounceTCell: UITableViewCell, GYRollingNoticeViewDelegate, GYRollingNoticeViewDataSource  {
    
    let GYNoticeViewCellID = "GYNoticeViewCellID"
    
    // MARK: - GYRollingNoticeView
    func numberOfRowsFor(roolingView: GYRollingNoticeView) -> Int {
        return data.count
    }
    
    func rollingNoticeView(roolingView: GYRollingNoticeView, cellAtIndex index: Int) -> GYNoticeViewCell {
        let cell = rollingView.dequeueReusableCell(withIdentifier: GYNoticeViewCellID) as! GYNoticeViewCell
        cell.textLabel?.text = data[index]
        cell.textLabel?.font = UIFont.init(fontName: kRegFont, size: 13)
        cell.textLabel?.textColor = COLOR(red: 109, green: 109, blue: 114)
        return cell
    }
    
    var data:[String] = [String](){
        didSet{
            if data.count > 0{
                rollingView.reloadDataAndStartRoll()
            }
            
        }
    }

    @IBOutlet weak var rollingView: GYRollingNoticeView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rollingView.delegate = self
        rollingView.dataSource = self
        rollingView.register(GYNoticeViewCell.self, forCellReuseIdentifier: GYNoticeViewCellID)
    }

    @IBAction func selectMore(_ sender: UIButton) {
        let vc = AnnouncementViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
