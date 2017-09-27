//
//  YLImagePickerController.swift
//  YLImagePickerController
//
//  Created by yl on 2017/8/30.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos

/// 默认缩略图大小
let thumbnailSize = CGSize.init(width: 150, height: 150)
/// ImagePicker类型
///
/// - camera: 拍照
/// - album: 相
public enum ImagePickerType {
    case camera
    case album
}
/// 裁剪类型
///
/// - none: 不裁剪
/// - square: 方形
/// - circular: 圆形
public enum CropType {
    case none
    case square
    case circular
}
/// 图片类型
///
/// - photo: jpg、png
/// - gif: gif动画
/// - video: 视频
public enum YLAssetType {
    case photo
    case gif
    case video
}

/// 导出Model
public struct YLPhotoModel {
    
    public var asset: PHAsset?
    public var image: UIImage?
    public var data: Data?
    public var type: YLAssetType?
    
    // 导出图片(截图)
    init(image: UIImage?) {
        self.image = image
        self.type = YLAssetType.photo
    }
    // 导出图片(没有截图)
    init(image: UIImage?,asset: PHAsset?) {
        self.image = image
        self.asset = asset
        self.type = YLAssetType.photo
    }
    // 导出gif
    init(gifData: Data,asset: PHAsset?) {
        self.data = gifData
        self.asset = asset
        self.type = YLAssetType.gif
    }
    // 导出视频
    init(asset: PHAsset?) {
        self.asset = asset
        self.type = YLAssetType.video
    }
}

/// 导出资源
public typealias DidFinishPickingPhotosHandle = (_ photos: [YLPhotoModel]) -> Void

/// 权限判断
typealias CheckPhotoAuthBlock = (_ result: Bool) -> Void

public class YLImagePickerController: UINavigationController {
    
    /// 获取选择的图片
    public var didFinishPickingPhotosHandle: DidFinishPickingPhotosHandle?
    /// 导出图片的宽度 默认828像素宽
    public var photoWidth: CGFloat = 828
    /** 是否选择原图 默认 false
     *  单选 true 返回原图 false 返回缩略图
     *  多选 true 默认用户点击了一次原图按钮
     */
    public var isSelectedOriginalImage = false
    /// 是否需要选择gif 动图  默认不需要
    public var isNeedSelectGifImage = false
    /// 是否需要选择视频      默认不需要
    public var isNeedSelectVideo = false
    
    var maxImagesCount:Int = 0                  // 最大可选数量
    var isOneChoose: Bool = false               // 是否单选
    var cropType: CropType = CropType.none      // 裁剪类型
    
    // 是否支持屏幕旋转
    override public var shouldAutorotate: Bool {
        return false
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    /// 拍照 或者 相册单选
    ///
    /// - Parameters:
    ///   - imagePickerType: 拍照 相册
    ///   - cropType: 不裁剪 方形 圆形
    convenience public init(imagePickerType: ImagePickerType,cropType: CropType) {
        
        if imagePickerType == ImagePickerType.camera {
            
            self.init()
            
            self.cropType = cropType
            
            let result = YLImagePickerController.checkPhotoAuth(imagePickerType, checkPhotoAuthBlock: { [weak self] (result:Bool) in
                
                DispatchQueue.main.async {
                    if result {
                        self?.viewControllers.removeAll()
                        let cameraPicker = YLCameraPickerController()
                        self?.pushViewController(cameraPicker, animated: false)
                    }
                }
                
            })
            
            if result {
                let cameraPicker = YLCameraPickerController()
                self.pushViewController(cameraPicker, animated: false)
            } else {
                let authErrorVC = YLAuthErrorViewController.init(imagePickerType: imagePickerType)
                self.pushViewController(authErrorVC, animated: false)
            }
            
        }else if imagePickerType == ImagePickerType.album {
            
            self.init(cropType: cropType, isPushPhotoPicker: true)
        }else {
            self.init()
        }
    }
    
    /// 相册-多选
    ///
    /// - Parameter maxImagesCount: 本次可选相片的最大数量
    convenience public init(maxImagesCount: Int) {
        self.init(maxImagesCount: maxImagesCount, isPushPhotoPicker: true)
    }
    
    /// 相册-单选
    ///
    /// - Parameters:
    ///   - cropType: 不裁剪 方形 圆形
    ///   - isPushPhotoPicker: 是否跳转到所有相册界面
    convenience public init(cropType: CropType, isPushPhotoPicker: Bool) {
        
        self.init()
        
        // 设置单选
        self.isOneChoose = true
        self.cropType = cropType
        
        let result = YLImagePickerController.checkPhotoAuth(ImagePickerType.album, checkPhotoAuthBlock: { [weak self] (result:Bool) in
            
            DispatchQueue.main.async {
                if result {
                    
                    self?.viewControllers.removeAll()
                    
                    let albumPicker = YLAlbumPickerController()
                    self?.pushViewController(albumPicker, animated: false)
                    
                    if isPushPhotoPicker == true {
                        
                        let photoPicker = YLPhotoPickerController()
                        self?.pushViewController(photoPicker, animated: false)
                    }
                }
            }
            
        })
        
        if result {
            
            let albumPicker = YLAlbumPickerController()
            self.pushViewController(albumPicker, animated: false)
            
            if isPushPhotoPicker == true {
                
                let photoPicker = YLPhotoPickerController()
                self.pushViewController(photoPicker, animated: false)
            }
            
        } else {
            let authErrorVC = YLAuthErrorViewController.init(imagePickerType: ImagePickerType.album)
            self.pushViewController(authErrorVC, animated: false)
        }
    }
    
    /// 相册-多选
    ///
    /// - Parameters:
    ///   - maxImagesCount: 本次可选相片的最大数量
    ///   - isPushPhotoPicker: 是否跳转到所有相册界面
    convenience public init(maxImagesCount: Int, isPushPhotoPicker: Bool) {
        
        self.init()
        
        // 设置多选
        self.isOneChoose = false
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9 // 默认最大可选9张
        
        let result = YLImagePickerController.checkPhotoAuth(ImagePickerType.album, checkPhotoAuthBlock: { [weak self] (result:Bool) in
            
            DispatchQueue.main.async {
                if result {
                    
                    self?.viewControllers.removeAll()
                    
                    let albumPicker = YLAlbumPickerController()
                    self?.pushViewController(albumPicker, animated: false)
                    
                    if isPushPhotoPicker == true {
                        
                        let photoPicker = YLPhotoPickerController()
                        self?.pushViewController(photoPicker, animated: false)
                    }
                }
            }
            
        })
        
        if result {
            
            let albumPicker = YLAlbumPickerController()
            self.pushViewController(albumPicker, animated: false)
            
            if isPushPhotoPicker == true {
                
                let photoPicker = YLPhotoPickerController()
                pushViewController(photoPicker, animated: false)
            }
            
        } else {
            let authErrorVC = YLAuthErrorViewController.init(imagePickerType: ImagePickerType.album)
            self.pushViewController(authErrorVC, animated: false)
        }
    }
    
    
    /// 获取权限
    class func checkPhotoAuth(_ imagePickerType:ImagePickerType,checkPhotoAuthBlock: @escaping CheckPhotoAuthBlock) -> Bool {
        
        if imagePickerType == ImagePickerType.camera {
            
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                    
                    checkPhotoAuthBlock(granted)
                })
                
            }else if authStatus == AVAuthorizationStatus.authorized {
                return true
            }
            
        }else if imagePickerType == ImagePickerType.album {
            
            let authStatus = PHPhotoLibrary.authorizationStatus()
            if authStatus == PHAuthorizationStatus.notDetermined {
                
                PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                    
                    if(status == PHAuthorizationStatus.authorized) {
                        checkPhotoAuthBlock(true)
                    }else {
                        checkPhotoAuthBlock(false)
                    }
                    
                })
            }else if(authStatus == PHAuthorizationStatus.authorized) {
                return true
            }
        }
        
        return false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationBar.barStyle = UIBarStyle.black
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = true
        
    }
    
    // 退出相册
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
