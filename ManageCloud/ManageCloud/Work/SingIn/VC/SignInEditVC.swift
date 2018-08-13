//
//  SignInEditVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView
import AssetsLibrary
import Photos
import ReactiveObjC
import PKHUD
import Alamofire

//let EditGrowingTextViewNoti = "editGrowingTextView"

class SignInEditVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PickerToolDelegate, GrowingTextViewDelegate{
    ///------签到相关
    @IBOutlet weak var bottomScroll: UIScrollView!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    
    var editPoint: CGPoint? = CGPoint.init(x: 0, y: 0)

    // 失败重连次数
    let MaxFaildCount: Int = 3
    var faildIndex: Int = 0
    
    //定位超时时间
    let LocationTimeout: Int = 6
    let ReGeocodeTimeout: Int = 3
    
    //定位获取的地理名称
    var addressString: String = ""
    
    //当前选择位置的经纬度
    var lat: String = ""
    var long: String = ""
    
    var request: DataRequest? = nil
    
    // 签到限制距离
    let LimitDistance = 500
    // 当前地理位置
    var location: CLLocation? = nil
    // 当前逆地理位置
    var regeocode: AMapLocationReGeocode? = nil
    // 签到限制距离
    lazy var locationManager: AMapLocationManager = {
        let manager = AMapLocationManager.init()
        //设置期望定位精度
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //设置允许在后台定位
        manager.allowsBackgroundLocationUpdates = true
        //设置定位超时时间
        manager.locationTimeout = LocationTimeout
        //设置逆地理超时时间
        manager.reGeocodeTimeout = ReGeocodeTimeout
        return manager
    }()
    
    var upLoadVM: PostEmailVM = PostEmailVM()

    
    var timer: Timer!
    
    ///-------
    
    @IBOutlet weak var iconMap: UIImageView!
    
    @IBOutlet weak var contentCellHeight: NSLayoutConstraint!
    @IBOutlet weak var locationCellHeight: NSLayoutConstraint!
    
    lazy var signVM = SignInVM()

    @IBOutlet weak var contentTextView: GrowingTextView!
    @IBOutlet weak var locationTextView: GrowingTextView!
    
    @IBOutlet weak var toolBarFromBottom: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var pickTool: PickerTool? = nil
    
    var selectedPhoto: [UIImage] = [UIImage]()
    
    var selectedAssets: [PHAsset] = [PHAsset]()
    
    var completionBlock: AMapLocatingCompletionBlock!
    
    var attach:[AttachmentInfo] = [AttachmentInfo]()
    
    lazy var saveBtn:UIButton = {
        let saveBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 24), title: "保存")
        saveBtn.rac_signal(for: .touchUpInside).take(until: self.rac_willDeallocSignal()).subscribeNext({ [weak self] (x) in
            
            self?.view.endEditing(true)
            //            if (self?.contentTextView.text.isEmpty)!{
            //                HUD.flash(.labeledError(title: nil, subtitle: "请输入签到内容"), delay: 1.0)
            //                return
            //            }
            if (self?.addressString.isEmpty)!{
                HUD.flash(.labeledError(title: nil, subtitle: "定位还未成功，请重新定位"), delay: 1.0)
                return
            }
            x?.isEnabled = false
            DPrint("CLICKKKKKKKKKKKKKKKKKKKKKKK")
            DPrint("lat:\(self?.lat)__lon:\(self?.long)")
            if (self?.selectedPhoto.count)! > 0{
                HUD.show(.labeledProgress(title: nil, subtitle:"上传中..."), onView: self?.view)
                //记录上传成功的图片数
                var Count: Int = 0
                for photo in (self?.selectedPhoto)!{
                    self?.upLoadVM.askForUpdateFile(file: photo, PurposeFileName: ".jpg", URL: SignUpLoad, { (code, remark, uuid) in
                        Count += 1
                        let attachc = AttachmentInfo()
                        attachc.FileName = uuid
                        self?.attach.append(attachc)
                        if self?.attach.count == self?.selectedPhoto.count{
                            if self == nil{
                                return
                            }
                            self?.Sign()
                        }
                    }, {
                        x?.isEnabled = true
                        HUD.flash(.labeledError(title: nil, subtitle: "上传失败，请重试"), delay: 1.0)
                    })
                }
            }
            else{
                
                
                self?.Sign()
            }
            
            
        }) {}
        return saveBtn
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        observe()
        initCompleteBlock()
        Locate()
        view.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        creatTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        denitTimer()
    }
    
    
    deinit {
        
    }
    
    // MARK: - Custom Method
    
    fileprivate func initUI() {
        title = "签到"
        
        let savebarItem = UIBarButtonItem.init(customView: saveBtn)
        navigationItem.rightBarButtonItem = savebarItem
        
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 24), title: "取消")
        cancelBtn.rac_signal(for: .touchUpInside).take(until: self.rac_willDeallocSignal()).subscribeNext({ [weak self] (x) in
            if self?.request != nil{
                self?.request?.cancel()
            }
            self?.navigationController?.popViewController()
        }) {}
        let cancelbarItem = UIBarButtonItem.init(customView: cancelBtn)
        navigationItem.leftBarButtonItem = cancelbarItem
        
        collection.register(UINib.init(nibName: "SignImageCCell", bundle: nil), forCellWithReuseIdentifier: "SignImageCCellID")
        locationTextView.delegate = self
        contentTextView.delegate = self
        contentTextView.becomeFirstResponder()
        
    }
    
    
    fileprivate func Sign() {
        HUD.show(.labeledProgress(title: nil, subtitle:"签到中..."), onView: self.view)
        self.request = SignInVM.ToSignIn(withAddress: self.addressString, Lat: self.lat, Long: self.long, content: self.contentTextView.text, attach: self.attach, sucBlock: {[weak self] in
            NotificationCenter.default.post(name: NSNotification.Name.init(refreshSignHome), object: nil)
            HUD.flash(.labeledSuccess(title: nil, subtitle: "签到成功"), onView: self?.view, delay: 1.0, completion: { (finish) in
                self?.navigationController?.popViewController()
            })
            
            }, failBlock: {(response) in
                HUD.flash(.labeledError(title: nil, subtitle: response.remark), delay: 1.0)
                self.saveBtn.isEnabled = true
        })
        
    }
    
    
    fileprivate func observe() {
        NotificationCenter.default.rac_addObserver(forName: NSNotification.Name.UIKeyboardWillShow.rawValue, object: nil).take(until: self.rac_willDeallocSignal()).subscribeNext {[weak self] (x) in
            let info = x?.userInfo
            let after = ((info![UIKeyboardFrameEndUserInfoKey]) as! NSValue).cgRectValue
//            if (self?.editPoint?.y)! > after.origin.y - 42
//            {
//                self?.scrollViewTop.constant = -((self?.editPoint?.y)! - (after.origin.y - 42))
//            }
            self?.toolBarFromBottom.constant = KHeight - after.origin.y
        }
        
        NotificationCenter.default.rac_addObserver(forName: NSNotification.Name.UIKeyboardWillHide.rawValue, object: nil).take(until:
            self.rac_willDeallocSignal()).subscribeNext {[weak self] (x) in
//            self?.scrollViewTop.constant = 0.0
//            self?.editPoint = CGPoint.init(x: 0, y: 0)
            let info = x?.userInfo
            let after = ((info![UIKeyboardFrameEndUserInfoKey]) as! NSValue).cgRectValue
            self?.toolBarFromBottom.constant = KHeight - after.origin.y
        }
//        self.bottomScroll.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
//        NotificationCenter.default.rac_addObserver(forName: NSNotification.Name.init(EditGrowingTextViewNoti).rawValue, object: nil).take(until: self.rac_willDeallocSignal()).subscribeNext {[weak self] (x) in
//            let touch = x?.object as! UITouch
//            self?.editPoint = touch.location(in: self?.view)
//        }
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize"{
//            Container.height = (change![NSKeyValueChangeKey.newKey] as! CGSize).height
//        }
//    }
    fileprivate func denitTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc fileprivate func Locate() {
        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    
    fileprivate func creatTimer() {
        timer = Timer.scheduledTimer(timeInterval: 200, target: self, selector: #selector(Locate), userInfo: nil, repeats: true)
    }
    
    
    fileprivate func initCompleteBlock() {
        completionBlock = { [weak self] (location, regeocodesf, errorsf) in
            guard let error = errorsf as NSError? else{
                DPrint("lat:\(location?.coordinate.latitude)__lon:\(location?.coordinate.longitude)---accuracy:\(String.init(format: "%.2f", (location?.horizontalAccuracy)!))m")
                
                //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                guard let regeocode = regeocodesf else{ return}
                self?.location = location!
                self?.lat = "\(location!.coordinate.latitude)"
                self?.long = "\(location!.coordinate.longitude)"
                self?.regeocode = regeocode
                self?.addressString = regeocode.formattedAddress
                self?.reloadLocationView()
                return
                
            }
            if error.code ==  AMapLocationErrorCode.locateFailed.rawValue{
                //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            }
            else if error.code ==  AMapLocationErrorCode.riskOfFakeLocation.rawValue{
                //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
                
            }
            else{
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            }
            DPrint("定位错误:{\(error.code) - \(error.localizedDescription)}")
            self?.locatingFaild()
        }
    }
    
    fileprivate func reloadLocationView() {
        iconMap.image = LoadImage("iconMapPre")
        locationTextView.text = self.addressString
    }
    
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        if textView == contentTextView {
            if height < 101 {return}
            contentCellHeight.constant = height + 79
        }
        else
        {
            if height < 40 {return}
            locationCellHeight.constant = height + 10
        }
        var height = KHeight - KStatusBarH - KNaviBarH + contentCellHeight.constant - 101 + locationCellHeight.constant - 40
        height += 100
        bottomScroll.contentSize = CGSize.init(width: 0, height: height)
        containerHeight.constant = height
    }
    
    
    fileprivate func locatingFaild() {
        let netReachable = NetObserve.isReachable
        if faildIndex >= MaxFaildCount || !netReachable{
            HUD.flash(.labeledError(title:"无法获取当前位置", subtitle: "请确认网络连接正常,然后重试!"), delay: 2.0)
            return
        }
        let errorTips = "正在第\(faildIndex + 1)次重试,请稍后..."
        HUD.flash(.labeledError(title: "无法获取当前位置", subtitle: errorTips), delay: 2.0)
        faildIndex += 1
        Locate()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        pickTool?.getPreViewVC(WithIndex: indexPath.item)
        present((pickTool?.imagePreviewVC)!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignImageCCellID", for: indexPath) as! SignImageCCell
        cell.imgV.image = selectedPhoto[indexPath.item]
        
        cell.delBtn.rac_signal(for: .touchUpInside).take(until: cell.rac_prepareForReuseSignal as! RACSignal<AnyObject>).subscribeNext {[weak self] (x) in
            self?.selectedPhoto.remove(at: indexPath.item)
            self?.selectedAssets.remove(at: indexPath.item)
            self?.collection.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 5是删除按钮凸出来的
        return CGSize.init(width: 83 + 5, height: 64 + 5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    
    

    @IBAction func ToLibrary(_ sender: UIButton) {
        if pickTool == nil{
            pickTool = PickerTool.init(MaxCount: 3, selectedAssets: self.selectedAssets)
            pickTool?.delegate = self
            pickTool?.allowPickingVideo = false
            
        }
        pickTool?.selectedAssets = self.selectedAssets
        present((pickTool?.imagePickerVcC)!, animated: true) {}
    }
    
    // MARK: - PickerToolDelegate
    
    func didPickedPhotos() {
        selectedPhoto.removeAll()
        selectedAssets.removeAll()
        if (pickTool?.selectedPhotos?.count)! > 0 {
            selectedPhoto += (pickTool?.selectedPhotos)!
        }
        if (pickTool?.selectedAssets?.count)!  > 0{
            selectedAssets += (pickTool?.selectedAssets) as! [PHAsset]
        }
        collection.reloadData()
    }
    
    

    @IBAction func takePhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func morePlace(_ sender: UIButton) {
        if location != nil{
            let vc = SignInChoosePlaceVC()
            vc.selectedBlock = {[weak self] (POI) in
                let selectedPalce: String = "[\(POI.name!)] \(POI.province!)\(POI.city!)\(POI.district!)\(POI.address!)"
                self?.addressString = selectedPalce
                self?.lat = "\(POI.location.latitude)"
                self?.long = "\(POI.location.longitude)"
                self?.reloadLocationView()
            }
            vc.location = location
            vc.district =  (regeocode?.district)!
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            HUD.flash(.labeledError(title: nil, subtitle: "正在获取当前位置\n请稍后重试"), delay: 2.0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
}
