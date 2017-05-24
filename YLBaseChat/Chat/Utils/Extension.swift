//
//  Extension.swift
//  YLBaseChat
//
//  Created by yl on 17/5/24.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UIImage
extension UIImage {

    func yl_scaleToSize(_ size:CGSize) -> UIImage {
    
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        // 从当前context中创建一个改变大小后的图片
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img;

        
    }
    
}
