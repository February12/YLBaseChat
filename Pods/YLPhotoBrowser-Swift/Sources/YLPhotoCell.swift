//
//  YLPhotoCell.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Kingfisher

class YLPhotoCell: UICollectionViewCell {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect.zero)
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.maximumZoomScale = 4.0
        sv.minimumZoomScale = 1.0
        return sv
    }()
    
    // 图片容器
    let imageView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.clear
        imgView.tag = ImageViewTag
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        return imgView
        
    }()
    
    // 进度条
    let progressView: YLPhotoProgressView = {
        let p = YLPhotoProgressView(frame: CGRect.zero)
        p.progress = 0
        p.isHidden = true
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        
        backgroundColor = UIColor.clear
        
        scrollView.delegate = self
        addSubview(scrollView)
        
        // scrollView 约束
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let sConstraintsTop = NSLayoutConstraint.init(item: scrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let sConstraintsLeft = NSLayoutConstraint.init(item: scrollView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let sConstraintsRight = NSLayoutConstraint.init(item: scrollView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let sConstraintsBottom = NSLayoutConstraint.init(item: scrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([sConstraintsTop,sConstraintsLeft,sConstraintsRight,sConstraintsBottom])
        
        
        scrollView.addSubview(imageView)
        
        addSubview(progressView)
        
        // progressView 约束
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let pConstraintsW = NSLayoutConstraint.init(item: progressView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let pConstraintsH = NSLayoutConstraint.init(item: progressView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let pConstraintsCX = NSLayoutConstraint.init(item: progressView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let pConstraintsCY = NSLayoutConstraint.init(item: progressView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([pConstraintsW,pConstraintsH,pConstraintsCX,pConstraintsCY])
    }
    
    func updatePhoto(_ photo: YLPhoto) {
    
        scrollView.setZoomScale(1, animated: false)
        imageView.image = nil
        progressView.isHidden = true
        
        if photo.imageUrl != "" {
            
            imageView.frame.size = CGSize.init(width: YLScreenW, height: YLScreenW)
            imageView.center = ImageViewCenter
            
            imageView.image = photo.image
            
            progressView.isHidden = false
            
            KingfisherManager.shared.retrieveImage(with: URL(string: photo.imageUrl)!, options: [.transition(.fade(1))], progressBlock: { [weak self] (receivedSize:Int64, totalSize:Int64) in
                
                self?.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                
            }, completionHandler: { [weak self] (image:Image?, _, _, _) in
                
                self?.progressView.isHidden = true
                
                guard let img = image else {
                    
                    return
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.imageView.frame = YLPhotoBrowser.getImageViewFrame(img.size)
                })
                self?.imageView.image = img
                photo.image = image
                
                self?.scrollView.contentSize = self?.imageView.frame.size ?? CGSize.zero
                
            })
            
        }else if let image = photo.image {
            
            imageView.frame = YLPhotoBrowser.getImageViewFrame(image.size)
            imageView.image = image
            scrollView.contentSize = imageView.frame.size
            
        }
    }
    
}

extension YLPhotoCell: UIScrollViewDelegate {
    
    // 设置UIScrollView中要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 让UIImageView在UIScrollView缩放后居中显示
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let size = scrollView.bounds.size
        
        let offsetX = (size.width > scrollView.contentSize.width) ?
            (size.width - scrollView.contentSize.width) * 0.5 : 0.0
        
        let offsetY = (size.height > scrollView.contentSize.height) ?
            (size.height - scrollView.contentSize.height) * 0.5 : 0.0
        
        imageView.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
}
