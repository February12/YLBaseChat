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
        
        cameraView.addConstraints(toItem: view, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        photoView = UIView()
        photoView.backgroundColor = UIColor.lightGray
        view.addSubview(photoView)
        
        photoView.addConstraints(toItem: view, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        photoView.isHidden = true
        
        cameraInit()
        initCameraBtns()
        
        if cropType == CropType.none {
            initDisplayImage()
        }
        
        view.layoutIfNeeded()
    }
    
    func cameraInit() {
        
        guard let device: AVCaptureDevice = cameraOfPosition(AVCaptureDevice.Position.back) else {return}
        self.device = device
        
        guard let input = try? AVCaptureDeviceInput.init(device: device) else {return}
        self.input = input
        
        imageOutput = AVCaptureStillImageOutput()
        
        session = AVCaptureSession()
        
        session?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        if session?.canAddInput(input) == true {
            session?.addInput(input)
        }
        if session?.canAddOutput(imageOutput!) == true {
            session?.addOutput(imageOutput!)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = view.bounds
        cameraView.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
        
        if (try? device.lockForConfiguration()) != nil  {
            
            if device.isFlashModeSupported(AVCaptureDevice.FlashMode.off) == true {
                device.flashMode = AVCaptureDevice.FlashMode.off
            }
            
            if device.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.autoWhiteBalance) == true {
                device.whiteBalanceMode = AVCaptureDevice.WhiteBalanceMode.autoWhiteBalance
            }
            
            device.unlockForConfiguration()
        }
        
    }
    
    func initCameraBtns() {
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setImage(UIImage.yl_imageName("cross"), for: UIControlState.normal)
        closeBtn.addTarget(self, action: #selector(YLCameraPickerController.closeCamera), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(closeBtn)
        
        closeBtn.addConstraints(attributes: [.top,.left,.width,.height], toItem: cameraView, attributes: nil, constants: [15,10,40,40])
        
        let takePhotoBtn = UIButton.init(type: UIButtonType.custom)
        takePhotoBtn.setImage(UIImage.yl_imageName("round"), for: UIControlState.normal)
        takePhotoBtn.addTarget(self, action: #selector(YLCameraPickerController.takePhoto), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(takePhotoBtn)
        
        takePhotoBtn.addConstraints(attributes: [.bottom,.centerX,.width,.height], toItem: cameraView, attributes: nil, constants: [-10,0,100,100])
        
        let flashChangeBtn = UIButton.init(type: UIButtonType.custom)
        flashChangeBtn.setImage(UIImage.yl_imageName("flash-off"), for: UIControlState.normal)
        flashChangeBtn.addTarget(self, action: #selector(YLCameraPickerController.changeFlash(_:)), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(flashChangeBtn)
        
        flashChangeBtn.addConstraints(attributes: [.top,.right,.width,.height], toItem: cameraView, attributes: nil, constants: [15,-60,40,40])
        
        let cameraChangeBtn = UIButton.init(type: UIButtonType.custom)
        cameraChangeBtn.setImage(UIImage.yl_imageName("camera-front-on"), for: UIControlState.normal)
        cameraChangeBtn.addTarget(self, action: #selector(YLCameraPickerController.changeCamera), for: UIControlEvents.touchUpInside)
        cameraView.addSubview(cameraChangeBtn)
        
        cameraChangeBtn.addConstraints(attributes: [.top,.right,.width,.height], toItem: cameraView, attributes: nil, constants: [15,-10,40,40])
        
        cameraView.layoutIfNeeded()
    }
    
    func initDisplayImage() {
        
        displayImage = UIImageView()
        photoView.addSubview(displayImage)
        
        displayImage.addConstraints(toItem: photoView, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        let toolbarTop = UIView()
        toolbarTop.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        photoView.addSubview(toolbarTop)
        
        toolbarTop.addConstraints(attributes: [.top,.left,.right,.height], toItem: photoView, attributes: nil, constants: [20,0,0,30])
        
        let takePhotoAgainBtn = UIButton()
        takePhotoAgainBtn.setTitle("重拍", for: UIControlState.normal)
        takePhotoAgainBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        takePhotoAgainBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        takePhotoAgainBtn.addTarget(self, action: #selector(YLCameraPickerController.takePhotoAgain), for: UIControlEvents.touchUpInside)
        toolbarTop.addSubview(takePhotoAgainBtn)
        
        takePhotoAgainBtn.addConstraints(attributes: [.centerY,.left,.width,.height], toItem: toolbarTop, attributes: nil, constants: [0,10,40,20])
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确认", for: UIControlState.normal)
        sureBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        let backgroundImage = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).createImage(size: CGSize.init(width: 40, height: 40))
        sureBtn.setBackgroundImage(backgroundImage, for: UIControlState.normal)
        sureBtn.layer.cornerRadius = 50
        sureBtn.clipsToBounds = true
        
        sureBtn.addTarget(self, action: #selector(YLCameraPickerController.surePhoto), for: UIControlEvents.touchUpInside)
        photoView.addSubview(sureBtn)
        
        sureBtn.addConstraints(attributes: [.bottom,.centerX,.width,.height], toItem: photoView, attributes: nil, constants: [-50,0,100,100])
        
        photoView.layoutSubviews()
    }
    
    @objc func closeCamera() {
        let imagePicker = self.navigationController as! YLImagePickerController
        imagePicker.goBack()
    }
    
    @objc func changeCamera() {
        
        let cameraCount = AVCaptureDevice.devices(for: AVMediaType.video).count
        if cameraCount > 1 {
            
            let animation = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            
            var newDevice: AVCaptureDevice? = nil
            var newInput: AVCaptureDeviceInput? = nil
            
            let position = input?.device.position
            if position == AVCaptureDevice.Position.front {
                newDevice = cameraOfPosition(AVCaptureDevice.Position.back)
                animation.subtype = kCATransitionFromLeft
            }else {
                newDevice = cameraOfPosition(AVCaptureDevice.Position.front)
                animation.subtype = kCATransitionFromRight
            }
            
            newInput = try! AVCaptureDeviceInput.init(device: newDevice!)
            previewLayer?.add(animation, forKey: "animation")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) { [weak self] in
                
                if newInput != nil {
                    self?.session?.beginConfiguration()
                    self?.session?.removeInput((self?.input)!)
                    if position == AVCaptureDevice.Position.front {
                        self?.session?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                    }else {
                        self?.session?.sessionPreset = AVCaptureSession.Preset.hd1280x720
                    }
                    if self?.session?.canAddInput(newInput!) == true {
                        self?.session?.addInput(newInput!)
                        self?.input = newInput
                    }else {
                        self?.session?.addInput((self?.input)!)
                    }
                    self?.session?.commitConfiguration()
                }
                
            }
        }
    }
    
    @objc func changeFlash(_ btn: UIButton) {
        if device?.flashMode == AVCaptureDevice.FlashMode.on {
            btn.setImage(UIImage.yl_imageName("flash-off"), for: UIControlState.normal)
            
            if (try? device?.lockForConfiguration()) != nil {
                device?.flashMode = AVCaptureDevice.FlashMode.off
                device?.unlockForConfiguration()
            }
        }else {
            btn.setImage(UIImage.yl_imageName("flash"), for: UIControlState.normal)
            
            if (try? device?.lockForConfiguration()) != nil {
                device?.flashMode = AVCaptureDevice.FlashMode.on
                device?.unlockForConfiguration()
            }
        }
    }
    
    @objc func takePhoto() {
        guard let connect = imageOutput?.connection(with: AVMediaType.video) else {return}
        
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
    
    @objc func takePhotoAgain() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.image = nil
            self?.displayImage.image = nil
            self?.cameraView.isHidden = false
            self?.photoView.isHidden = true
            self?.session?.startRunning()
        }
    }
    
    @objc func surePhoto() {
        let imagePicker = self.navigationController as! YLImagePickerController
        if let image = image {
            let photoModel = YLPhotoModel.init(image: image)
            imagePicker.didFinishPickingPhotosHandle?([photoModel])
        }
        imagePicker.goBack()
    }
    
    func cameraOfPosition(_ position:AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let devices:[AVCaptureDevice] = AVCaptureDevice.devices(for: AVMediaType.video)
        
        for device in devices {
            if device.position == position {
                return device
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
