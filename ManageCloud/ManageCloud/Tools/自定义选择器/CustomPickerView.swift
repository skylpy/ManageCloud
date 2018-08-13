//
//  CustomPickerView.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/17.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class CustomModel: NSObject {
    
    var oid:String?
    var title:String?
    
    class func initCustom(title:String,oid:String) -> CustomModel {
        
        let model = CustomModel()
        model.oid = oid
        model.title = title
        return model
    }
}

class CustomPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewBottomLayoutY: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var btnClickBlock:((CustomModel)->())?;

    var customModel:CustomModel!
    lazy var dataArray:NSMutableArray = {
        
        let array = NSMutableArray()
        
        return array
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //将dataSource设置成自己
        self.pickerView.dataSource = self
        //将delegate设置成自己
        self.pickerView.delegate = self
    }
    
    class func initPickerView(view:UIView,dataSource:NSArray,sureBlick:@escaping(_ model:CustomModel)->()) -> UIView {
        
        let picker:CustomPickerView = Bundle.main.loadNibNamed("CustomPickerView", owner: nil, options: nil)?.last as! CustomPickerView
        
        picker.frame = view.bounds
        
        picker.bgView.alpha = 0
        
        picker.dataArray.addObjects(from: dataSource as! [Any])
        
        picker.btnClickBlock = sureBlick
        
        picker.showAction()
        
        picker.pickerView.reloadAllComponents()
        
        view.addSubview(picker)
        
        return picker
    }
    
    func showAction() -> () {
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.6) {
            self.bgView.alpha = 0.3
            self.viewBottomLayoutY.constant = 0
        }
    }
    
    func dissmissAcion() -> () {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.bgView.alpha = 0
            self.viewBottomLayoutY.constant = -230
            
        }) { (finished) in
            
            self.removeFromSuperview()
        }
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        
        self.btnClickBlock!(self.customModel!)
        self.dissmissAcion()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.dissmissAcion()
    }
    
}

extension CustomPickerView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dissmissAcion()
    }
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataArray.count
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        let list:NSArray = self.dataArray[component] as! NSArray
        
        return list.count
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let list:NSArray = self.dataArray[component] as! NSArray
        let model:CustomModel = list[row] as! CustomModel
        self.customModel = model
        return model.title
    }
}
