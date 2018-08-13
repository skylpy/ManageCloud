//
//  PickerTool.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import AssetsLibrary
import TZImagePickerController
import PKHUD


@objc protocol PickerToolDelegate: class {
    /** 选择图片回调 **/
    @objc optional func didPickedPhotos()
    /** 选择视频回调 **/
    @objc optional func didPickedVedio(WithCoverImage coverImage: UIImage, asset:AnyObject)
}

class PickerTool: NSObject,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate {
    // 每行展示资源个数  默认是3
    var columnNum: Int = 3
    //设置是否可以选择视频/图片/原图
    // 默认不选择视频
    var allowPickingVideo: Bool = false
    // 默认选择图片
    var allowPickingImage: Bool = true
    // 默认支持原图
    var allowPickingOriginalPhoto: Bool = true
    // 默认不选择Gif
    var allowPickingGif: Bool = false
    //默认不裁剪
    var allowCrops:Bool = false
    //选择了的照片
    lazy var selectedPhotos: [UIImage]? = [UIImage]()
    //选择的资源
    lazy var selectedAssets: [AnyObject]? = [AnyObject]()
    /** 照片选择控制器 **/
    var imagePickerVcC: TZImagePickerController!
    {
        get{
            let imagePicker = TZImagePickerController.init(maxImagesCount: self.maxCount, columnNumber: self.columnNum, delegate: self)
            imagePicker?.isSelectOriginalPhoto = self.isSelectOriginalPhoto
            imagePicker?.allowTakePicture = true    // 在内部显示拍照按钮
            if (selectedAssets?.count)! > 0 {
                let select = NSMutableArray.init(array: selectedAssets!)
                imagePicker?.selectedAssets = select   // 目前已经选中的图片数组
            }
            else{
                imagePicker?.selectedAssets = nil
            }
            
            
            imagePicker?.allowPickingVideo = self.allowPickingVideo
            imagePicker?.allowPickingImage = self.self.allowPickingImage
            imagePicker?.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto
            imagePicker?.allowPickingGif  = self.allowPickingGif
            if self.allowCrops {
                imagePicker?.showSelectBtn = false
                imagePicker?.allowCrop = true
                imagePicker?.cropRect = CGRect.init(x: KWidth / 6 , y: (KHeight-(KWidth*2/3))/2, width: KWidth*2/3, height: KWidth*2/3)
            }
            // 4. 照片排列按修改时间升序
            imagePicker?.sortAscendingByModificationDate = true
            imagePicker?.alwaysEnableDoneBtn = true
            
            
            
            return imagePicker
        }
    }
    /** 照片预览控制器 **/
    var imagePreviewVC: TZImagePickerController!
    
    
    fileprivate var maxCount:Int = 3
    fileprivate var isSelectOriginalPhoto = false
    
    weak var delegate: PickerToolDelegate?
    
    init(MaxCount maxCount:Int, selectedAssets:[AnyObject]) {
        super.init()
        self.maxCount = maxCount
        self.selectedAssets = selectedAssets
    }
    
    func getPreViewVC(WithIndex index: Int) {
        let select = NSMutableArray.init(array: selectedAssets!)
        let photo = NSMutableArray.init(array: selectedPhotos!)
        imagePreviewVC = TZImagePickerController.init(selectedAssets: select, selectedPhotos: photo, index: index)
        imagePreviewVC.maxImagesCount = maxCount
        imagePreviewVC.allowPickingOriginalPhoto = true
        imagePreviewVC.isSelectOriginalPhoto = isSelectOriginalPhoto
        imagePreviewVC.didFinishPickingPhotosHandle = { [weak self] (photos,assets,isSelectOriginalPhoto) in
            self?.selectedPhotos = photos
            self?.selectedAssets = assets as [AnyObject]?
            self?.isSelectOriginalPhoto = isSelectOriginalPhoto
            self?.delegate?.didPickedPhotos!()
        }
    }
    
    
    // MARK: - TZImagePickerControllerDelegate
    
    /// 用户点击了取消
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        DPrint("camcel")
    }
    
    // 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    // 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        self.selectedPhotos?.removeAll()
        for photo in photos{
           let zipPhoto = photo.zip()
            self.selectedPhotos?.append(zipPhoto)
        }
        self.selectedAssets = assets as [AnyObject]?
        self.isSelectOriginalPhoto = isSelectOriginalPhoto
        delegate?.didPickedPhotos!()
        
        guard let assetss = assets  else {
            return
        }
        // 1.打印图片名字®
        printAssetsName(assetss as! [PHAsset])
        // 2.图片位置信息
        for phAsset  in assetss{
            if (phAsset as AnyObject).isKind(of: PHAsset.self){
                if let asset = phAsset as? PHAsset{
                    DPrint("location:\(asset.location)")
                }
                
            }
            
        }
    }
    //获取视频
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
        
        var assetNew = asset as! PHAsset
        //文件大小
        let videoPath:String = assetNew.value(forKey: "pathForOriginalFile") as! String
        
        let aSize = FileTools.getFileSizeNotKB(patch: videoPath)
        if aSize > 1024 * 1024 * 15 {
            HUD.flash(.label("单个文件不能大于15M"), delay: 1.0)
            return
        }
        self.delegate?.didPickedVedio!(WithCoverImage: coverImage!, asset: asset! as AnyObject)
    }
    
    
    func printAssetsName(_ assets:[PHAsset]){
        var fileName = ""
        for asset in assets{
            if asset.isKind(of: PHAsset.self){
                fileName = asset.value(forKey: "filename") as! String
            }
            DPrint("图片名字:\(fileName)")
        }
    }
    
    
    
    
    
    
    
    
    
    
}
