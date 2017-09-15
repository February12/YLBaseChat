//
//  YLAssetModel.swift
//  YLImagePickerController
//
//  Created by yl on 2017/8/30.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos

class YLAssetModel {
    /// 资源
    var asset: PHAsset!
    /// 类型 默认是常规图片类型
    var type: YLAssetType = YLAssetType.photo
    /// 缩略图
    var thumbnailImage: UIImage?
    /// 是否选择
    var isSelected: Bool = false
    /// 第几个被选择的
    var selectedSerialNumber: Int = 0
    
}
