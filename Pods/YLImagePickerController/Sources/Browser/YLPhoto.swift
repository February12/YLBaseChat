//
//  YLPhoto.swift
//  YLPhotoBrowser
//
//  Created by 朱云龙 on 17/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPhoto {
    
    // 图片
    var image: UIImage?
    
    var frame: CGRect?  // 在屏幕上的位置
    
    var assetModel: YLAssetModel?
    
    // 为了让动画效果最佳,最好有 image(原图/缩略图) 和 frame(图片初始位置)
    class func addImage(_ image: UIImage?,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.frame = frame
        return photo
    }
}
