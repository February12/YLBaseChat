//
//  YLPhoto.swift
//  YLPhotoBrowser
//
//  Created by 朱云龙 on 17/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

public class YLPhoto {
    
    var image: UIImage? // 图片
    var frame: CGRect?  // 在屏幕上的位置
    var imageUrl: String = ""    // 图片url
    
    // 为了让动画效果最佳,最好有 image(原图/缩略图) 和 frame(图片初始位置)
    public class func addImage(_ image: UIImage?,imageUrl: String?,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.imageUrl = imageUrl ?? ""
        photo.frame = frame
        return photo
    }
}
