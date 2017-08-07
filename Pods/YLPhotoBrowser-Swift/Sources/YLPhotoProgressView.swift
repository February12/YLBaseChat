//
//  YLPhotoProgressView.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit


/// 图像下载进度视图
public class YLPhotoProgressView: UIView {
    
    /// 进度
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    /// 进度颜色
    var progressTintColor: UIColor = UIColor(white: 0.8, alpha: 0.8)
    
    /// 底色
    var trackTintColor: UIColor = UIColor.clear
    
    /// 边框颜色
    var borderTintColor: UIColor = UIColor(white: 0.8, alpha: 0.8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 绘制
    override public func draw(_ rect: CGRect) {
        
        if rect.width == 0 || rect.height == 0 { return }
        
        if progress >= 1 { return }
        
        var radius = min(rect.width, rect.height) * 0.5
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        
        let lineWidth: CGFloat = 2
        
        // 绘制外圈
        borderTintColor.setStroke()
        
        let borderPath = UIBezierPath.init(arcCenter: center, radius: radius - lineWidth * 0.5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        borderPath.lineWidth = lineWidth
        borderPath.stroke()
        
        // 绘制内圆
        trackTintColor.setStroke()
        
        radius -= lineWidth * 2
        let trackPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        trackPath.fill()
        
        //绘制进度
        progressTintColor.set()
        
        let start: CGFloat = -1.0 * .pi * 0.5;
        let end = start + progress * .pi * 2;
        let progressPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        progressPath.addLine(to: center)
        progressPath.close()
        progressPath.fill()
        
    }
}
