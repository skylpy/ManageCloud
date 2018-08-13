//
//  MySettingViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos
import PKHUD

class MySettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PickerToolDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    let titleAry = ["姓名","简介","所属部门","密码重置"]
    ///部门数据
    var departmentDate = ["swift", "ObjecTive-C", "C", "C++", "java", "php", "python", "ruby", "js"]
    
    var model:PersonInfoModel = PersonInfoModel()
    var pickTool: PickerTool? = nil
    var selectedAssets: [PHAsset] = [PHAsset]()
    var selectedPhoto: UIImage? = nil
    var cameraPicker: UIImagePickerController!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vm = PersonInfoVM()
        vm.askForPersonInfo({ [weak self](smodel) in
            self?.model = smodel[0]
            self?.tableView.reloadData()
        }) {}
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        self.initTableView()
        
    }
    
    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "MySettingCell", bundle: nil), forCellReuseIdentifier: "MySettingCell")
        self.tableView.register(UINib.init(nibName: "MySettingIMGCell", bundle: nil), forCellReuseIdentifier: "MySettingIMGCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 65
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 1))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 2
        }
        return 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MySettingCell = tableView.dequeueReusableCell(withIdentifier: "MySettingCell") as! MySettingCell
        
        if indexPath.section == 0  {
            
//            if indexPath.row == 0{
//
//                  let cell:MySettingIMGCell = tableView.dequeueReusableCell(withIdentifier: "MySettingIMGCell") as! MySettingIMGCell
//
//
//
//                    cell.userImg.setImageWithBase64String(imgStr: self.model.Photo  ?? "", isAvatar: true)
//
//                return cell
//            }else{
            
                cell.leftTitle.text = self.titleAry[indexPath.row]
                
                //简介没有➡️
                if indexPath.row == 1{
                    cell.arrowIMG.isHidden = true
                    cell.rightTitle.text = self.model.Descr
                }else{
                    cell.arrowIMG.isHidden = false
                    cell.rightTitle.text = self.model.Name
                }
//            }
            
        }else if indexPath.section == 1 {
            cell.leftTitle.text = "所属部门"
            cell.rightTitle.textColor = RGBA(r: 53, g: 53, b: 53, a: 1.0)
            cell.rightTitle.text = self.model.DepName
            cell.arrowIMG.isHidden = true
        }else if indexPath.section == 2{
            
            cell.leftTitle.text = "密码重置"
            cell.rightTitle.text = "修改"
            cell.rightTitle.font = UIFont.systemFont(ofSize: 16)
            cell.rightTitle.textColor = RGBA(r: 152, g: 152, b: 156, a: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
//            if indexPath.row == 0 {//头像
//                self.initHeardImgAlert()
//            }else
            if indexPath.row == 0{//姓名
                
                let nameVC = SettingNameViewController(nibName: "SettingNameViewController", bundle: nil)
                nameVC.model = self.model
                // nameVC.setUserName()
                self.navigationController?.pushViewController(nameVC, animated: true)
                
            }else if indexPath.row == 1{//简介
                
                let introductionVC = SetIntroductionViewController()
                introductionVC.model = self.model;
                self.navigationController?.pushViewController(introductionVC, animated: true)
            }
            
        }else if indexPath.section == 1{//所属部门
            
//            let cell:MySettingCell = tableView.cellForRow(at: indexPath) as! MySettingCell
//            
//           self.departmentAlert(label:cell.rightTitle )
            
        }else if indexPath.section == 2{//修改密码
            let fixVC = FixPassWordsViewController()
            self.navigationController?.pushViewController(fixVC, animated: true)
            
        }

    }
    
    
    
    /// 头像弹框
    func initHeardImgAlert() {
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: "从相册选取", style: .default, isEnabled: true) { (acion) in
            
            if self.pickTool == nil{
                self.pickTool = PickerTool.init(MaxCount: 1, selectedAssets: self.selectedAssets)
                self.pickTool?.delegate = self
                self.pickTool?.allowPickingVideo = false
                
            }
//            self.pickTool?.selectedAssets = self.selectedAssets
            self.present((self.pickTool?.imagePickerVcC)!, animated: true) {}
        }
        alert.addAction(title: "拍照", style: .default, isEnabled: true) { (acion) in
            
            self.initCameraPicker()
        }
        let action = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        action.setValue(RGBA(r: 51, g: 51, b: 51, a: 0.9), forKey: "titleTextColor")
        alert.addAction(action)
        
        alert.show()
    }
    
    /// 相机
    func initCameraPicker(){
        cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        //在需要的地方present出来
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        //获得照片
        self.selectedPhoto = UIImage()
        self.selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.model.Photo = self.selectedPhoto!.base64StrForImg()
        
        HUD.show(.label("正在上传..."))
        let vm = PersonInfoVM()
        vm.askForUpLoadImg(smodel: self.model) { (code, remark) in
            
            HUD.hide()
            self.tableView.reloadData()
        }
    }
    
    /// 部门
    func departmentAlert(label:UILabel) {
        
        UsefulPickerView.showSingleColPicker("", data: self.departmentDate, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
//            label.text = "选中了第\(selectedIndex)行----选中的数据为\(selectedValue)"
            label.text = "\(selectedValue)"

        }
    }
    
    // MARK: - PickerToolDelegate
    
    func didPickedPhotos() {

        if (pickTool?.selectedPhotos?.count)! > 0 {
            self.selectedPhoto = UIImage()
            self.selectedPhoto = self.pickTool!.selectedPhotos![0]
            self.model.Photo = self.selectedPhoto!.base64StrForImg()
            
            HUD.show(.label("正在上传..."))
            let vm = PersonInfoVM()
            vm.askForUpLoadImg(smodel: self.model) { (code, remark) in
                
                HUD.hide()
                self.tableView.reloadData()
            }
        }
        


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
