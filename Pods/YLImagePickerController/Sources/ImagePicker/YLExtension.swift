//
//  YLExtension.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/6.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func yl_imageName(_ name: String) -> UIImage? {
        
        let bundle = Bundle.yl_imagePickerFileBundle()
        
        if let image = UIImage.init(named: name, in: bundle, compatibleWith: nil) {
            
            return image
        }else {
            
            return UIImage.init(named: name)
        }
    }
}

extension Bundle {
    
    class func yl_imagePickerFileBundle() -> Bundle? {
        
        let bundle = Bundle.yl_imagePickerNibBundle()
        
        if  let url = bundle.url(forResource: "YLImagePickerController", withExtension: "bundle"),
            let b = Bundle.init(url: url) {
            return b
        }else {
            return bundle
        }
    }
    
    class func yl_imagePickerNibBundle() -> Bundle {
        let bundle = Bundle.init(for: YLImagePickerController.self)
        return bundle
    }
    
}

// MARK: - 颜色获取
extension UIColor {
    class func colorFromRGB(_ rgb:Int) -> UIColor {
        return UIColor(red: CGFloat(CGFloat((rgb & 0xFF0000) >> 16) / 255.0) ,
                       green: CGFloat(CGFloat((rgb & 0xFF00) >> 8) / 255.0) ,
                       blue: CGFloat(CGFloat(rgb & 0xFF) / 255.0) ,
                       alpha: 1.0)
        
    }
    
    func createImage(size: CGSize) -> UIImage? {
        
        var rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}


// MARK: - 约束拓展
extension UIView {
    
    /// 宽或高(一条约束)
    func addLayoutConstraint(attribute: NSLayoutAttribute,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 宽高(两个约束)
    func addLayoutConstraint(widthConstant: CGFloat,heightConstant: CGFloat) {
        addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: widthConstant)
        addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: heightConstant)
    }
    
    /// 与父视图相同的 NSLayoutAttribute(一条约束)
    func addLayoutConstraint(attribute: NSLayoutAttribute,
                             toItem: Any,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 与父视图相同的 NSLayoutAttribute(多条约束)
    func addLayoutConstraint(attributes: [NSLayoutAttribute],
                             toItem: Any,
                             constants: [CGFloat]) {
        
        for (i,attribute) in attributes.enumerated() {
            let constant = constants[i]
            addLayoutConstraint(attribute: attribute, toItem: toItem, constant: constant)
        }
        
    }
    
    /// 与父视图相同或不相同的 NSLayoutAttribute(一条约束)
    func addLayoutConstraint(attribute attr1: NSLayoutAttribute,
                             toItem: Any,
                             attribute attr2: NSLayoutAttribute,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 与父视图相同或不相同的 NSLayoutAttribute(多条约束)
    func addLayoutConstraint(attributes attr1s: [NSLayoutAttribute],
                             toItem: Any,
                             attributes attr2s: [NSLayoutAttribute],
                             constants: [CGFloat]) {
        for (i,attribute1) in attr1s.enumerated() {
            let attribute2 = attr2s[i]
            let constant = constants[i]
            addLayoutConstraint(attribute: attribute1, toItem: toItem, attribute: attribute2, constant: constant)
        }
        
    }
    
    /// 根据 UIEdgeInsets (四条约束)
    func addLayoutConstraint(toItem: Any,edgeInsets: UIEdgeInsets) {
        
        addLayoutConstraint(attribute: NSLayoutAttribute.top, toItem:toItem, constant: edgeInsets.top)
        addLayoutConstraint(attribute: NSLayoutAttribute.left,  toItem:toItem, constant: edgeInsets.left)
        addLayoutConstraint(attribute: NSLayoutAttribute.right,  toItem:toItem, constant: edgeInsets.right)
        addLayoutConstraint(attribute: NSLayoutAttribute.bottom,  toItem:toItem, constant: edgeInsets.bottom)
        
    }
}
