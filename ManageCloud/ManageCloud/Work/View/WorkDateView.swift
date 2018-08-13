//
//  WorkDateView.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit


class WorkDateView: UIView {

    
    @IBOutlet weak var EmailBtn: UIButton!
    @IBOutlet weak var redSpot: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    @IBOutlet weak var dateLB: UILabel!
    
    override func awakeFromNib() {
        redSpot.isHidden = true
        loadData()
        NotificationCenter.default.rac_addObserver(forName: NotificationName_ReloadSendEmailList, object: nil).take(until: self.rac_willDeallocSignal()).subscribeNext({ [weak self] (x) in
            self?.loadData()
        }) {}
        
        
    }
    
    @IBAction func ToEmail(_ sender: UIButton) {
        let myEmail = MyEmailViewController()
        self.viewController?.navigationController?.pushViewController(myEmail)
    }
    
    
    func loadData() {
        HomeVM.GetNewEmailCount(sucBlock: { (num) in
            if num != "0"{
                self.redSpot.isHidden = false
                if Int(num)! > 99{
                    self.redSpot.text = "99"
                }
                else{
                    self.redSpot.text = num
                }
                
            }
            else{
                self.redSpot.isHidden = true
            }
        }) { (failSuc) in
            
        }
        let date = Date.init(timeIntervalSinceNow: 0)
        let dateString = date.dateString(format: "yyyy-MM-dd HH:mm", locale: "en_US_POSIX")
        let yearName = dateString.substring(to: 4)
        let monthName = dateString.substring(with: Range.init(NSRange.init(location: 5, length: 2))!)
        let dayName = dateString.substring(with: Range.init(NSRange.init(location: 8, length: 2))!)
        let dateStrings = "\(yearName)年\(NSString.init(format: "%d", Int(monthName)!))月\(NSString.init(format: "%d", Int(dayName)!))日"
        dateLB.text = dateStrings
    }
    
}
