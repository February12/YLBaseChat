//
//  UIImage+Extension.swift
//  YLBaseChat
//
//  Created by yl on 17/5/24.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImage 拓展
extension UIImage {

    // yl_tag
    var yl_tag : String? {
        
        get {
            return accessibilityIdentifier
        }
        
        set(newVal) {
            accessibilityIdentifier = newVal
        }
    }
    
}
