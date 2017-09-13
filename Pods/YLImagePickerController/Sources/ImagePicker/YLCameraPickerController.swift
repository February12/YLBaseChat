//
//  YLCameraPickerController.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/5.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import AVFoundation
import TOCropViewController

class YLCameraPickerController: UIViewController {
    
    var cameraView: UIView!
    var photoView: UIView!
    var displayImage: UIImageView!
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var imageOutput: AVCaptureStillImageOutput?
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    var cropType: CropType = CropType.none
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = self.navigationController as! YLImagePickerController
        cropType = imagePicker.cropType
        
        cameraView = UIView()
        cameraView.backgroundColor = UIColor.lightGray
        view.addSubview(cameraView)
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addLayoutConstraint(toItem: view, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        photoView = UIView()
        photoView.backgroundColor = UIColor.lightGray
        view.addSubview(photoView)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.addLayoutConstraint(toItem: view, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        photoView.isHidden = true
        
        cameraInit()
        initCameraBtns()
        
        if cropType == CropType.none {
            initDisplayImage()
        }
        
        view.layoutIfNeeded()
    }
    
    func cameraInit() {
        device = cameraOfPosition(AVCaptureDevicePosition.back)
        
        try! input = AVCaptureDeviceInput.init(device: device)
        
        imageOutput = AVCaptureStillImageOutput()
        
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        if session?.canAddInput(input) == true {
            session?.addInput(input)
        }
        if session?.canAddOutput(imageOutput) == true {
            session?.addOutput(imageOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = view.bounds
        cameraView.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
        
        if try! device?.lockForConfiguration() != nil {
            
            if device?.isFlashModeSupported(AVCaptureFlashMode.off) == true {
                device?.flashMode = AVCaptureFlashMode.off
            }
            
            if device?.isWhiteBalanceModeSupported(AVCaptureWhiteBalanceMode.autoWhiteBalance) == true {
                device?.whiteBalanceMode = AVCaptureWhiteBalanceMode.autoWhiteBalance
            }
            
            device?.unlockForConfiguration()
        }
        
    }
    
    func initCameraBtns() {
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setImage(UIImage.yl_imageName("cross"), for: UIControlState.normal)
        closeBtn.addTarget(self, action: #selector(YLCameraPickerController.closeCamera), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.top, toItem: cameraView, constant: 15)
        closeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.left, toItem: cameraView, constant: 10)
        closeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: 40)
        closeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 40)
        
        let takePhotoBtn = UIButton.init(type: UIButtonType.custom)
        takePhotoBtn.setImage(UIImage.yl_imageName("round"), for: UIControlState.normal)
        takePhotoBtn.addTarget(self, action: #selector(YLCameraPickerController.takePhoto), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(takePhotoBtn)
        takePhotoBtn.translatesAutoresizingMaskIntoConstraints = false
        takePhotoBtn.addLayoutConstraint(attribute: NSLayoutAttribute.bottom, toItem: cameraView, constant: -10)
        takePhotoBtn.addLayoutConstraint(attribute: NSLayoutAttribute.centerX, toItem: cameraView, constant: 0)
        takePhotoBtn.addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: 100)
        takePhotoBtn.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 100)
        
        let flashChangeBtn = UIButton.init(type: UIButtonType.custom)
        flashChangeBtn.setImage(UIImage.yl_imageName("flash-off"), for: UIControlState.normal)
        flashChangeBtn.addTarget(self, action: #selector(YLCameraPickerController.changeFlash(_:)), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(flashChangeBtn)
        flashChangeBtn.translatesAutoresizingMaskIntoConstraints = false
        flashChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.top, toItem: cameraView, constant: 15 )
        flashChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.right, toItem: cameraView, constant: -60)
        flashChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: 40)
        flashChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 40)
        
        let cameraChangeBtn = UIButton.init(type: UIButtonType.custom)
        cameraChangeBtn.setImage(UIImage.yl_imageName("camera-front-on"), for: UIControlState.normal)
        cameraChangeBtn.addTarget(self, action: #selector(YLCameraPickerController.changeCamera), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(cameraChangeBtn)
        cameraChangeBtn.translatesAutoresizingMaskIntoConstraints = false
        cameraChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.top, toItem: cameraView, constant: 15 )
        cameraChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.right, toItem: cameraView, constant: -10)
        cameraChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: 40)
        cameraChangeBtn.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 40)
        
        cameraView.layoutIfNeeded()
    }
    
    func initDisplayImage() {
        
        displayImage = UIImageView()
        photoView.addSubview(displayImage)
        displayImage.translatesAutoresizingMaskIntoConstraints = false
        displayImage.addLayoutConstraint(toItem: photoView, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        let toolbarTop = UIView()
        toolbarTop.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        photoView.addSubview(toolbarTop)
        toolbarTop.translatesAutoresizingMaskIntoConstraints = false
        toolbarTop.addLayoutConstraint(attributes: [NSLayoutAttribute.top,NSLayoutAttribute.left,NSLayoutAttribute.right], toItem: photoView, constants: [20,0,0])
        toolbarTop.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 30)
        
        let takePhotoAgainBtn = UIButton()
        takePhotoAgainBtn.setTitle("重拍", for: UIControlState.normal)
        takePhotoAgainBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        takePhotoAgainBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        takePhotoAgainBtn.addTarget(self, action: #selector(YLCameraPickerController.takePhotoAgain), for: UIControlEvents.touchUpInside)
        toolbarTop.addSubview(takePhotoAgainBtn)
        takePhotoAgainBtn.translatesAutoresizingMaskIntoConstraints = false
        takePhotoAgainBtn.addLayoutConstraint(attribute: NSLayoutAttribute.centerY, toItem: toolbarTop, constant: 0 )
        takePhotoAgainBtn.addLayoutConstraint(attribute: NSLayoutAttribute.left, toItem: toolbarTop, constant: 10)
        takePhotoAgainBtn.addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: 40)
        takePhotoAgainBtn.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 20)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确认", for: UIControlState.normal)
        sureBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        let backgroundImage = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).createImage(size: CGSize.init(width: 40, height: 40))
        sureBtn.setBackgroundImage(backgroundImage, for: UIControlState.normal)
        sureBtn.layer.cornerRadius = 50
        sureBtn.clipsToBounds = true
        
        sureBtn.addTarget(self, action: #selector(YLCameraPickerController.surePhoto), for: UIControlEvents.touchUpInside)
        photoView.addSubview(sureBtn)
        sureBtn.translatesAutoresizingMaskIntoConstraints = false
        sureBtn.addLayoutConstraint(attribute: NSLayoutAttribute.bottom, toItem: photoView, constant: -50)
        sureBtn.addLayoutConstraint(attribute: NSLayoutAttribute.centerX, toItem: photoView, constant: 0)
        sureBtn.addLayoutConstraint(widthConstant: 100, heightConstant: 100)
        
        photoView.layoutSubviews()
    }
    
    func closeCamera() {
        let imagePicker = self.navigationController as! YLImagePickerController
        imagePicker.goBack()
    }
    
    func changeCamera() {
        
        let cameraCount = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
        if cameraCount > 1 {
            
            let animation = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            
            var newDevice: AVCaptureDevice? = nil
            var newInput: AVCaptureDeviceInput? = nil
            
            let position = input?.device.position
            if position == AVCaptureDevicePosition.front {
                newDevice = cameraOfPosition(AVCaptureDevicePosition.back)
                animation.subtype = kCATransitionFromLeft
            }else {
                newDevice = cameraOfPosition(AVCaptureDevicePosition.front)
                animation.subtype = kCATransitionFromRight
            }
            
            newInput = try! AVCaptureDeviceInput.init(device: newDevice)
            previewLayer?.add(animation, forKey: "animation")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) { [weak self] in
             
                if newInput != nil {
                    self?.session?.beginConfiguration()
                    self?.session?.removeInput(self?.input)
                    if position == AVCaptureDevicePosition.front {
                        self?.session?.sessionPreset = AVCaptureSessionPreset1920x1080
                    }else {
                        self?.session?.sessionPreset = AVCaptureSessionPreset1280x720
                    }
                    if self?.session?.canAddInput(newInput) == true {
                        self?.session?.addInput(newInput)
                        self?.input = newInput
                    }else {
                        self?.session?.addInput(self?.input)
                    }
                    self?.session?.commitConfiguration()
                }
                
            }
        }
    }
    
    func changeFlash(_ btn: UIButton) {
        if device?.flashMode == AVCaptureFlashMode.on {
            btn.setImage(UIImage.yl_imageName("flash-off"), for: UIControlState.normal)
            
            if try! device?.lockForConfiguration() != nil {
                device?.flashMode = AVCaptureFlashMode.off
                device?.unlockForConfiguration()
            }
        }else {
            btn.setImage(UIImage.yl_imageName("flash"), for: UIControlState.normal)
            
            if try! device?.lockForConfiguration() != nil {
                device?.flashMode = AVCaptureFlashMode.on
                device?.unlockForConfiguration()
            }
        }
    }
    
    func takePhoto() {
        let connect = imageOutput?.connection(withMediaType: AVMediaTypeVideo)
        if connect != nil {
            imageOutput?.captureStillImageAsynchronously(from: connect, completionHandler: { [weak self] (imageBuffer:CMSampleBuffer?, _) in
                
                if let imageBuffer = imageBuffer,
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer),
                    let image = UIImage.init(data: imageData, scale: 1.0) {
                    
                    if self?.cropType == CropType.none {
                        
                        self?.image = image
                        self?.displayImage.image = image
                        self?.cameraView.isHidden = true
                        self?.photoView.isHidden = false
                        
                        self?.session?.stopRunning()
                    }else {
                        var style = TOCropViewCroppingStyle.default
                        if self?.cropType == CropType.circular {
                            style = TOCropViewCroppingStyle.circular
                        }
                        let cropViewController = TOCropViewController.init(croppingStyle: style, image: image)
                        cropViewController.delegate = self
                        self?.navigationController?.pushViewController(cropViewController, animated: false)
                    }
                    
                }else {
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self?.displayImage.image = nil
                        self?.cameraView.isHidden = false
                        self?.photoView.isHidden = true
                        self?.session?.startRunning()
                    }
                    
                }
                
            })
        }
    }
    
    func takePhotoAgain() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.image = nil
            self?.displayImage.image = nil
            self?.cameraView.isHidden = false
            self?.photoView.isHidden = true
            self?.session?.startRunning()
        }
    }
    
    func surePhoto() {
        let imagePicker = self.navigationController as! YLImagePickerController
        if let image = image {
            let photoModel = YLPhotoModel.init(image: image)
            imagePicker.didFinishPickingPhotosHandle?([photoModel])
        }
        imagePicker.goBack()
    }
    
    func cameraOfPosition(_ position:AVCaptureDevicePosition) -> AVCaptureDevice? {
        if let devices:[AVCaptureDevice] = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] {
            for device in devices {
                if device.position == position {
                    return device
                }
            }
        }
        return nil
    }
}

// MARK: - TOCropViewControllerDelegate
extension YLCameraPickerController: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        let imagePicker = self.navigationController as! YLImagePickerController
        let photoModel = YLPhotoModel.init(image: image)
        imagePicker.didFinishPickingPhotosHandle?([photoModel])
        imagePicker.goBack()
    }
}
