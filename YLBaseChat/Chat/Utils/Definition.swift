//
//  Definition.swift
//  YLBaseChat
//
//  Created by yl on 17/5/15.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

/// 获取Screen的Size
let YLScreenWith   = UIScreen.main.bounds.width
let YLScreenHeight = UIScreen.main.bounds.height

public class Definition{
    
    class func colorFromRGB(rgb:Int) -> UIColor {
        
        return UIColor(red: CGFloat(CGFloat((rgb & 0xFF0000) >> 16) / 255.0) ,
                       green: CGFloat(CGFloat((rgb & 0xFF00) >> 8) / 255.0) ,
                       blue: CGFloat(CGFloat(rgb & 0xFF) / 255.0) ,
                       alpha: 1.0)
        
    }
}
