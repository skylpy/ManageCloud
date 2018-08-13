//
//  MsgPeopleView.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MsgPeopleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var conainer: UIView!
    var lastChoiceIndex: Int = -1
    var seletedBlock:(([personModel], Int)->())?
    var data: [personModel] = [personModel](){
        didSet{
            self.collect.reloadData()
        }
    }

    @IBOutlet weak var myPeopleLB: UILabel!
    @IBOutlet weak var collect: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myPeopleLB.textColor = DarkTitleColor
        collect.delegate = self
        collect.dataSource = self
        collect.register(UINib.init(nibName: "MsgPeopleCCell", bundle: nil), forCellWithReuseIdentifier: "MsgPeopleCCellID")
        
    }
    @IBAction func Close(_ sender: UIButton) {
        dismiss()
    }
    
    
    // MARK: - Collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MsgPeopleCCellID", for: indexPath) as! MsgPeopleCCell
        let model = data[indexPath.item]
        cell.button.setTitle(model.EINAME, for: .normal)
        cell.isChoose = model.isSelete
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = data[indexPath.item]
        let frame: CGRect = model.EINAME!.boundingRect(with: CGSize(width: 400, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(fontName: kRegFont, size: 16)], context: nil)
        let width = frame.size.width + 20
        return CGSize.init(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = data[indexPath.item]
        
        if lastChoiceIndex >= 0 {
            //选中
            if lastChoiceIndex != indexPath.item{
                model.isSelete = true
            }
            //取消
            else{
                model.isSelete = false
            }
            let lastModel = data[lastChoiceIndex]
            lastModel.isSelete = false
            
        }
        //msgVC选了我的然后进来或者首次进来
        else{
            model.isSelete = true
        }
        
        lastChoiceIndex = indexPath.item
//        collectionView.reloadItems(at: [indexPath])
        seletedBlock!(data,indexPath.item)
        dismiss()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    func show(){
        MainWindow.addSubview(self)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }) { (finish) in
        }
        
    }
    
    
}

