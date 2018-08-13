//
//  SignRecordTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import SKPhotoBrowser


class SignRecordTCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var LBToPlaceIcon: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var timeLBTopTOICON: NSLayoutConstraint!
    @IBOutlet weak var timeLBLeading: NSLayoutConstraint!
    
    enum SignRecordTCellType {
        case MineTodaySign
        case MineAllSign
    }
    
    @IBOutlet weak var monthLB: UILabel!
    @IBOutlet weak var dayLB: UILabel!
    
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var placeLB: UILabel!
    
    @IBOutlet weak var markLB: UILabel!
    @IBOutlet weak var placelIcon: UIImageView!
    
    var data: [UIImage] = [UIImage](){
        didSet{
            collection.reloadData()
        }
    }
    
    var type: SignRecordTCellType = .MineTodaySign{
        didSet{
            if type == .MineAllSign {
                placelIcon.isHidden = true
                countLB.isHidden = true
                LBToPlaceIcon.constant = 21 + 22
                timeLBLeading.constant = 5
                timeLBTopTOICON.constant = -15
            }
            else{
                monthLB.isHidden = true
                dayLB.isHidden = true
            }
        }
    }
    
    
    
    
    var myTodaySignModel: SignListModel! {
        didSet{
            let hourMinute = myTodaySignModel.Bdate?.components(separatedBy:" ").last!.substring(to: 5)
            timeLB.text = hourMinute
            var addressString: NSString = "无"
            if myTodaySignModel.Address != nil{
                addressString = "地点：" + myTodaySignModel.Address! as NSString
            }
            let addressAtt: NSMutableAttributedString = NSMutableAttributedString.init(string: addressString as String)
            let range = addressString.range(of: "地点：")
            addressAtt.addAttributes([NSAttributedStringKey.foregroundColor : GrayTitleColor], range: range)
            placeLB.attributedText = addressAtt
            
            var contentString: NSString = "无"
            if myTodaySignModel.content != nil{
                contentString = "备注：" + myTodaySignModel.content! as NSString
            }
            
            let contentAtt: NSMutableAttributedString = NSMutableAttributedString.init(string: contentString as String)
            let range1 = contentString.range(of: "备注：")
            contentAtt.addAttributes([NSAttributedStringKey.foregroundColor: GrayTitleColor], range: range1)
            markLB.attributedText = contentAtt
            
            if (myTodaySignModel.thecontent?.isEmpty)! {
                collectionHeight.constant = 0
            }
            else{
                collectionHeight.constant = 69
            }
            if type == .MineAllSign {
                let date = myTodaySignModel.Bdate?.components(separatedBy:" ").first!
                let month = date?.components(separatedBy: "-")[1]
                let day = date?.components(separatedBy: "-")[2]
                dayLB.text = NSString.init(format: "%d", Int(day!)!) as String
                monthLB.text = "/\(NSString.init(format: "%d", Int(month!)!))月"
            }
            data.removeAll()
            for index in 0..<myTodaySignModel.thecontent!.count {
                let photoModel = myTodaySignModel.thecontent![index]
                let file = UrlForDocument[0].appendingPathComponent(photoModel.GFileName!)
                let exist = FileManag.fileExists(atPath: file.path)
                if exist{
                    do{
                        try self.data.append(UIImage.init(data: Data.init(contentsOf: file))!)
                    }
                    catch{}
                   
                }
                else{
                    SignInVM.askForSignReadFile(SourceFileName: photoModel.GFileName!) { (fileUrl) in
                        do {
                            let image = try UIImage.init(data: Data.init(contentsOf: fileUrl))
                            if (image != nil){
                                self.data.append(image!)
                            }
                        }
                        catch{
                            DPrint("获取本地图片失败")
                        }
                    }
                }
                
            }
            collection.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLB.textColor = DarkTitleColor
        countLB.textColor = BlueColor
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "SignImageCCell", bundle: nil), forCellWithReuseIdentifier: "SignImageCCellID")
        
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! SignImageCCell
        let originImage = cell.imgV.image
        var browserData: [SKPhoto] = [SKPhoto]()
        for image in data{
            let photo = SKPhoto.photoWithImage(image)
            browserData.append(photo)
        }
        let browser = SKPhotoBrowser(originImage: originImage!, photos: browserData, animatedFromView: cell)
        browser.initializePageIndex(indexPath.item)
        viewController?.navigationController?.present(browser, animated: true, completion: {})
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignImageCCellID", for: indexPath) as! SignImageCCell
        cell.imgV.image = data[indexPath.item]
        cell.delBtn.isHidden = true
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
        return 9 - 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
