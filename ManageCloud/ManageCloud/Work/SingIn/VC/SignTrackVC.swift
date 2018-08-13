//
//  SignTrackVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class SignTrackVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate {
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var mapBackView: UIView!
    var mapView: MAMapView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var Table: UITableView!
    
    lazy var pickView: SignDateView = {
        var pick = Bundle.main.loadNibNamed("SignDateView", owner: nil, options: nil)?.first! as! SignDateView
        pick.frame = MainWindow.bounds
        return pick
    }()
    
    var data: [SignListModel] = [SignListModel]()
    var selectedDate: Date = Date()
    //选择的日期
    var selectedDateString: String = ""
    //选择的人员Oid
    var selectedOid: String = ""
    
    var annotations: [MAPointAnnotation] = [MAPointAnnotation]()
    var locationManager: AMapLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        checkWetherCanChoosePeople()
        loadData()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "足迹"
        view.backgroundColor = UIColor.white
        Table.register(UINib.init(nibName: "SignRecordTCell", bundle: nil), forCellReuseIdentifier: SignRecordTCellID)
        Table.tableFooterView = UIView()
        let date = Date.init(timeIntervalSinceNow:0)
        self.selectedDateString = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
        let pointString = selectedDateString.replacingOccurrences(of: ["-"], with: ".")
        timeLB.text = pointString
        nameView.addTapTarget(self, Selector: #selector(tapName))
        dateView.addTapTarget(self, Selector: #selector(tapDate))
        self.selectedOid = MyOid()
        initMapView()
        nameLB.text = MyName()
        leftArrow.isHidden = true
        
    }
    
    fileprivate func initMapView() {
        
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 208))
        mapView.delegate = self
        ///缩放级别
        mapView.zoomLevel = 18
        //显示指南针
        mapView.showsCompass = false
        //显示比例尺
        mapView.showsScale = false
        
        let r =  MAUserLocationRepresentation()
        //显示精度圈
        r.showsAccuracyRing = false
        //是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
        r.showsHeadingIndicator = false
        let myName = MyName()
        let firstLetter = myName.substring(to: 1)
        
        mapView.update(r)
        //最小更新距离
        mapView.distanceFilter = 100
        mapView.headingFilter = 380
        //显示用户位置 YES 为打开定位，NO为关闭定位
        mapView.showsUserLocation = true
        // 追踪用户地理位置更新
        mapView.setUserTrackingMode(.follow, animated: true)
        mapBackView.addSubview(mapView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //查询是否能够查看下属
    func checkWetherCanChoosePeople() {
        SignInVM.LoadSignPersonList(sucBlock: {[weak self] (modelArr) in
            if (modelArr?.count)! > 0{
                self?.leftArrow.isHidden = false
            }
        }) { (resFail) in
        }
    }
    
    
    @objc fileprivate func tapName() {
        if !leftArrow.isHidden {
            let vc = SignSelectPeopleVC()
            vc.selectedBlock = { (model) in
                self.nameLB.text = model.Name!
                self.selectedOid = model.oid!
                self.loadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc fileprivate func tapDate() {
//        var pickerSetting = DatePickerSetting.init()
//        pickerSetting.date = self.selectedDate
//        UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
//            self.selectedDate = date
//            self.selectedDateString = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
//            let pointString = self.selectedDateString.replacingOccurrences(of: ["-"], with: ".")
//            self.timeLB.text = pointString
//            self.loadData()
//        }
        pickView.picker.selectedDate = selectedDate
        pickView.show()
        pickView.selectedBlock = { [weak self] (date) in
            self?.selectedDate = date
            self?.selectedDateString = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
            let pointString = self?.selectedDateString.replacingOccurrences(of: ["-"], with: ".")
            self?.timeLB.text = pointString
            self?.loadData()
            
        }
    }
    
    fileprivate func loadData() {
        
        HUD.show(.labeledProgress(title: nil, subtitle: "加载中"), onView: view)
        SignInVM.LoadPerDaySignList(withTid: self.selectedOid, date: self.selectedDateString, sucBlock: {[weak self] (modelArr) in
             HUD.hide()
            if let dataArr = modelArr{
                self?.data = dataArr
                if self?.data.count == 0{
                    HUD.flash(.label("无签到记录"),delay:1.0)
                }
            }
            self?.configureAnno()
            self?.Table.reloadData()
        }) { (resFail) in
             HUD.hide()
            HUD.flash(.labeledError(title: nil, subtitle: resFail.remark), delay: 1.0)
        }
    }
    
    fileprivate func configureAnno() {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        for index in 0..<data.count{
            let model = data[index]
            let anno = MAPointAnnotation()
            anno.coordinate = CLLocationCoordinate2DMake((model.lat! as NSString).doubleValue, (model.lng! as NSString).doubleValue)
            anno.title = "\(data.count - index)"
            annotations.append(anno)
        }
        if annotations.count == 0 {return}
        mapView.addAnnotations(annotations)
        let firstAnno = annotations.first!
        mapView.setCenter(firstAnno.coordinate, animated: true)
    }
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        // 定位成功
        if mapView.userLocation.location != nil && !wasUserAction{
            
        }
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self){
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
            if annotationView == nil{
                annotationView = MAPinAnnotationView.init(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            //是否允许弹出call out
            annotationView?.canShowCallout = false
            //下落动画
            annotationView?.animatesDrop = true
            //是否支持拖动
            annotationView?.isDraggable = false
            annotationView?.image = UIImage.DrawText(annotation.title!, Image: LoadImage("iconPlaceTip"))
//            annotationView?.image = LoadImage("iconPlaceTip")
            return annotationView
        }
        return MAAnnotationView()
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SignRecordTCellID, for: indexPath) as! SignRecordTCell
        cell.selectionStyle = .none
        cell.type = .MineTodaySign
        cell.myTodaySignModel = model
        cell.countLB.text = String(data.count - indexPath.row)
        cell.separatorInset = UIEdgeInsetsMake(0, 70, 0, 16)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
