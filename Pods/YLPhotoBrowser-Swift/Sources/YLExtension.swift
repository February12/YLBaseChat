//
//  YLExtension.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/6.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import ImageIO

public extension UIImage {
    /// 获取 YLImagePickerController.bundle 图片
    class func yl_imageName(_ name: String) -> UIImage? {
        
        let bundle = Bundle.yl_imagePickerFileBundle()
        
        if let image = UIImage.init(named: name, in: bundle, compatibleWith: nil) {
            
            return image
        }else {
            
            return UIImage.init(named: name)
        }
    }
    
    /// 获取gif
    public class func yl_gifWithData(_ data: Data) -> UIImage? {
        
        if let source: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) {
            
            let count = CGImageSourceGetCount(source)
            
            if count <= 1 {
                return UIImage.init(data: data)
            }else {
                var images = [UIImage]()
                
                var duration: TimeInterval = 0.0
                
                for i in 0...count-1 {
                    if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        images.append(UIImage.init(cgImage: image, scale: UIScreen.main.scale, orientation: UIImageOrientation.up))
                        if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? Dictionary<String, Any>,
                            let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as?
                            Dictionary<String, Any> {
                            
                            var frameDuration: TimeInterval = 0.1
                            
                            if let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval {
                                frameDuration = delayTime
                            }else if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                                frameDuration = delayTime
                            }
        
                            if frameDuration < 0.011 {
                                frameDuration = 0.100
                            }
                            
                            duration += frameDuration
                        }
                        
                    }
                    
                }
                return  UIImage.animatedImage(with: images, duration: duration)
            }
        }
        return nil
    }
}

extension Bundle {
    /// 获取文件 Bundle
    class func yl_imagePickerFileBundle() -> Bundle? {
        
        let bundle = Bundle.yl_imagePickerNibBundle()
        
        if let url = bundle.url(forResource: "YLImagePickerController", withExtension: "bundle"),
            let b = Bundle.init(url: url) {
            return b
        }else {
            return bundle
        }
    }
    /// 获取xib Bundle
    class func yl_imagePickerNibBundle() -> Bundle {
        let bundle = Bundle.init(for: YLPhotoBrowser.self)
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
    /// 创建图片
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
    
    /*----------------------------添加约束----------------------------*/
    
    /// 添加约束
    func addConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        addConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 添加约束 attr2s为nil时表示和attr1s 相同
    func addConstraints(attributes attr1s: [NSLayoutAttribute],
                        toItem: Any?,
                        attributes attr2s: [NSLayoutAttribute]?,
                        constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            addConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 添加约束 attr2s为nil时表示和attr1s 相同
    func addConstraints(attributes attr1s: [NSLayoutAttribute],
                        toItem: Any?,
                        attributes attr2s: [NSLayoutAttribute]?,
                        constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            let constant = constants[i]
            addConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 添加约束
    func addConstraint(attribute attr1: NSLayoutAttribute,
                       toItem: Any?,
                       attribute attr2: NSLayoutAttribute,
                       constant: CGFloat) {
        addConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 添加约束
    func addConstraint(attribute attr1: NSLayoutAttribute,
                       relatedBy relation: NSLayoutRelation,
                       toItem: Any?,
                       attribute attr2: NSLayoutAttribute,
                       multiplier: CGFloat,
                       constant: CGFloat) {
        
        var toItem = toItem
        var attr2 = attr2
        
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        if attr1 == .width || attr1 == .height {
            toItem = nil
            attr2 = .notAnAttribute
        }
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /*----------------------------修改约束----------------------------*/
    
    /// 修改约束
    func updateConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        updateConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 修改约束 attr2s为nil时表示和attr1s 相同
    func updateConstraints(attributes attr1s: [NSLayoutAttribute],
                           toItem: Any?,
                           attributes attr2s: [NSLayoutAttribute]?,
                           constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            updateConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 修改约束 attr2s为nil时表示和attr1s 相同
    func updateConstraints(attributes attr1s: [NSLayoutAttribute],
                           toItem: Any?,
                           attributes attr2s: [NSLayoutAttribute]?,
                           constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            let constant = constants[i]
            updateConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 修改约束
    func updateConstraint(attribute attr1: NSLayoutAttribute,
                          toItem: Any?,
                          attribute attr2: NSLayoutAttribute,
                          constant: CGFloat) {
        updateConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 修改约束
    func updateConstraint(attribute attr1: NSLayoutAttribute,
                          relatedBy relation: NSLayoutRelation,
                          toItem: Any?,
                          attribute attr2: NSLayoutAttribute,
                          multiplier: CGFloat,
                          constant: CGFloat) {
        
        removeConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        
        addConstraint(attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
    }
    
    /*----------------------------删除约束----------------------------*/
    
    /// 删除约束 attr2s为nil时表示和attr1s 相同
    func removeConstraints(attributes attr1s: [NSLayoutAttribute],
                           toItem: Any?,
                           attributes attr2s: [NSLayoutAttribute]?) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            removeConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        }
    }
    /// 删除约束
    func removeConstraint(attribute attr1: NSLayoutAttribute,
                          toItem: Any?,
                          attribute attr2: NSLayoutAttribute) {
        
        if attr1 == .width  || attr1 == .height {
            for constraint in constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
            
        }else if let superview = self.superview {
            for constraint in superview.constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 &&
                    constraint.secondItem?.isEqual(toItem) == true &&
                    constraint.secondAttribute == attr2 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
        }
    }
}
