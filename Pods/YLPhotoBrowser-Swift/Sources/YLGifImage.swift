//
//  YLGifImage.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

public extension UIImage {

    // 获取本地gif name 带后缀 如  1.gif
    public class func yl_gifAnimated(_ name: String) -> UIImage? {
        
        let path = Bundle.main.path(forResource: name, ofType: nil)
        
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path ?? "")) {
            
            
            // Start of kf.animatedImageWithGIFData
            let options: NSDictionary = [kCGImageSourceShouldCache as String: true, kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
            guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
                return nil
            }
            
            //Calculates frame duration for a gif frame out of the kCGImagePropertyGIFDictionary dictionary
            func frameDuration(from gifInfo: NSDictionary?) -> Double {
                let gifDefaultFrameDuration = 0.100
                
                guard let gifInfo = gifInfo else {
                    return gifDefaultFrameDuration
                }
                
                let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
                let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
                let duration = unclampedDelayTime ?? delayTime
                
                guard let frameDuration = duration else { return gifDefaultFrameDuration }
                
                return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : gifDefaultFrameDuration
            }
            
            let frameCount = CGImageSourceGetCount(imageSource)
            var images = [UIImage]()
            var gifDuration = 0.0
            for i in 0 ..< frameCount {
                
                guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
                    return nil
                }
                
                if frameCount == 1 {
                    // Single frame
                    gifDuration = Double.infinity
                } else {
                    
                    // Animated GIF
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else {
                        return nil
                    }
                    
                    let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary
                    gifDuration += frameDuration(from: gifInfo)
                }
                
                images.append(UIImage.init(cgImage: imageRef))
            }
            
            let image = UIImage.animatedImage(with: images, duration: gifDuration)
            
            return image
            
        }
        
        return nil
    }
}
