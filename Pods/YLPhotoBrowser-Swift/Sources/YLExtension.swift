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
public extension UIView {
    
    /// 宽或高(一条约束)
    public func addLayoutConstraint(attribute: NSLayoutAttribute,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 宽高(两个约束)
    public func addLayoutConstraint(widthConstant: CGFloat,heightConstant: CGFloat) {
        addLayoutConstraint(attribute: NSLayoutAttribute.width, constant: widthConstant)
        addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: heightConstant)
    }
    
    /// 与父视图相同的 NSLayoutAttribute(一条约束)
    public func addLayoutConstraint(attribute: NSLayoutAttribute,
                             toItem: Any,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 与父视图相同的 NSLayoutAttribute(多条约束)
    public func addLayoutConstraint(attributes: [NSLayoutAttribute],
                             toItem: Any,
                             constants: [CGFloat]) {
        
        for (i,attribute) in attributes.enumerated() {
            let constant = constants[i]
            addLayoutConstraint(attribute: attribute, toItem: toItem, constant: constant)
        }
        
    }
    
    /// 与父视图相同或不相同的 NSLayoutAttribute(一条约束)
    public func addLayoutConstraint(attribute attr1: NSLayoutAttribute,
                             toItem: Any,
                             attribute attr2: NSLayoutAttribute,
                             constant: CGFloat) {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /// 与父视图相同或不相同的 NSLayoutAttribute(多条约束)
    public func addLayoutConstraint(attributes attr1s: [NSLayoutAttribute],
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
    public func addLayoutConstraint(toItem: Any,edgeInsets: UIEdgeInsets) {
        
        addLayoutConstraint(attribute: NSLayoutAttribute.top, toItem:toItem, constant: edgeInsets.top)
        addLayoutConstraint(attribute: NSLayoutAttribute.left,  toItem:toItem, constant: edgeInsets.left)
        addLayoutConstraint(attribute: NSLayoutAttribute.right,  toItem:toItem, constant: edgeInsets.right)
        addLayoutConstraint(attribute: NSLayoutAttribute.bottom,  toItem:toItem, constant: edgeInsets.bottom)
        
    }
}
