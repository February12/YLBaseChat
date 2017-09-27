//
//  YLAuthErrorViewController.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/5.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLAuthErrorViewController: UIViewController {
    
    var imagePickerType: ImagePickerType = ImagePickerType.album
    
    convenience init(imagePickerType: ImagePickerType) {
        self.init()
        self.imagePickerType = imagePickerType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.done, target: self.navigationController, action: #selector(YLImagePickerController.goBack))
        
        view.backgroundColor = UIColor.white
        
        let imageView = UIImageView.init(image: UIImage.yl_imageName("photo_lock"))
        view.addSubview(imageView)
        
        // 约束
        imageView.addConstraints(attributes: [.top,.centerX,.width,.height], toItem: view, attributes: nil, constants: [114,0,200,200])
        
        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(messageLabel)
        
        // 约束
        messageLabel.addConstraints(attributes: [.centerX,.height], toItem: view, attributes: nil, constants: [0,30])
        messageLabel.addConstraint(attribute: .top, toItem: imageView, attribute: .bottom, constant: 30)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        view.addSubview(label)
        
        // 约束
        label.addConstraints(attributes: [.centerX,.height], toItem: view, attributes: nil, constants: [0,25])
        label.addConstraint(attribute: .top, toItem: messageLabel, attribute: .bottom, constant: 0)
        
        switch (imagePickerType) {
        case .camera:
            navigationItem.title = "相机"
            messageLabel.text = "此应用程序没有权限访问您的相机"
            label.text = "在“设置-隐私-相机”中开启即可使用"
        case .album:
            navigationItem.title = "照片"
            messageLabel.text = "此应用程序没有权限访问您的照片"
            label.text = "在“设置-隐私-照片”中开启即可查看"
        }
        
        view.layoutIfNeeded()
    }
    
}
