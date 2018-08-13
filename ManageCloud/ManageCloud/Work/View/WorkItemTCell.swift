//
//  WorkItemTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

protocol WorkItemTCellDelegate: class  {
    func didSelectItemName(_ name: String)
}

class WorkItemTCell: UITableViewCell {
    
    weak var delegate: WorkItemTCellDelegate?
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    
    @IBOutlet weak var firstLeft: NSLayoutConstraint!
    @IBOutlet weak var secRight: NSLayoutConstraint!
    @IBOutlet weak var thirdLeft: NSLayoutConstraint!
    @IBOutlet weak var forthRight: NSLayoutConstraint!
    
    var rowModel: [WorkItem] = [WorkItem]() {
        didSet{
            for index in 0..<rowModel.count{
                let model:WorkItem = rowModel[index]
                if index == 0{
                    icon1.image = LoadImage(model.icon)
                    name1.text = model.name
                }
                else if index == 1{
                    icon2.image = LoadImage(model.icon)
                    name2.text = model.name
                }
                else if index == 2{
                    icon3.image = LoadImage(model.icon)
                    name3.text = model.name
                }
                else if index == 3{
                    icon4.image = LoadImage(model.icon)
                    name4.text = model.name
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstLeft.constant = (KWidth - 48 * 4) / 8
        secRight.constant = (KWidth - 48 * 4) / 8
        thirdLeft.constant = (KWidth - 48 * 4) / 8
        forthRight.constant = (KWidth - 48 * 4) / 8
        
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tap11))
        icon1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(tap22))
        icon2.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(tap33))
        icon3.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer.init(target: self, action: #selector(tap44))
        icon4.addGestureRecognizer(tap4)
        
        
    }
    
    @objc fileprivate func tap11() {
        delegate?.didSelectItemName(name1.text!)
    }
    
    @objc fileprivate func tap22() {
        delegate?.didSelectItemName(name2.text!)
    }
    
    @objc fileprivate func tap33() {
        delegate?.didSelectItemName(name3.text!)
    }
    
    @objc fileprivate func tap44() {
        delegate?.didSelectItemName(name4.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
