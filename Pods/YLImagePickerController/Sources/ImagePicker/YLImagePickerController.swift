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

public enum ImagePickerType {
    case camera   // 拍照
    case album // 相册
}

public enum CropType {
    case none     // 不裁剪
    case square   // 方形
    case circular // 圆形
}

public typealias DidFinishPickingPhotosHandle = (_ images: [UIImage]) -> Void

typealias CheckPhotoAuthBlock = (_ result: Bool) -> Void

public class YLImagePickerController: UINavigationController {
    
    /// 获取选择的图片
    public var didFinishPickingPhotosHandle: DidFinishPickingPhotosHandle?
    
    var maxImagesCount:Int = 0                  // 最大可选数量
    var isOneChoose: Bool = false               // 是否单选
    var cropType: CropType = CropType.none      // 裁剪类型
    
    deinit {
        print("释放\(self)")
    }
    
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
            
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted:Bool) in
                    
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
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
