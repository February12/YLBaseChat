//
//  YLPhotoCell.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos

protocol YLPhotoCellDelegate :NSObjectProtocol {
    func epPhotoPanGestureRecognizerBegin(_ pan: UIPanGestureRecognizer,photo: YLPhoto)
    func epPhotoPanGestureRecognizerEnd(_ currentImageViewFrame: CGRect,photo: YLPhoto)
    func epPhotoSingleTap()
    func epPhotoDoubleTap()
}

class YLPhotoCell: UICollectionViewCell {
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var transitionImageViewFrame = CGRect.zero
    var panBeginScaleX:CGFloat = 0
    var panBeginScaleY:CGFloat = 0
    
    weak var delegate: YLPhotoCellDelegate?
    
    var photo: YLPhoto!
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect.zero)
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.bounces = false
        sv.maximumZoomScale = 4.0
        sv.minimumZoomScale = 1.0
        
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = .never
        }
        
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
    
    deinit {
        delegate = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        
        backgroundColor = UIColor.clear
        
        panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoCell.pan(_:)))
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)
        
        
        scrollView.delegate = self
        addSubview(scrollView)
        
        // scrollView 约束
        scrollView.addConstraints(toItem: self, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(imageView)
        
        // 手势
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoCell.singleTap))
        self.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoCell.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        // 优先识别 双击
        singleTap.require(toFail: doubleTap)
        
    }
    
    /// 单击手势
    @objc func singleTap() {
        delegate?.epPhotoSingleTap()
    }
    
    /// 双击手势
    @objc func doubleTap() {
        delegate?.epPhotoDoubleTap()
    }

    
    // 慢移手势
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in:  pan.view?.superview)
        
        var scale = 1 - translation.y / frame.height
        
        scale = scale > 1 ? 1:scale
        scale = scale < 0 ? 0:scale
        
        switch pan.state {
        case .possible:
            break
        case .began:
            
            transitionImageViewFrame = imageView.frame
            panBeginScaleX = pan.location(in: pan.view).x / transitionImageViewFrame.width
            panBeginScaleY = pan.location(in: imageView).y / imageView.frame.height
            scrollView.delegate = nil
            
            if panBeginScaleX < 0 {
                panBeginScaleX = 0
            }else if panBeginScaleX > 1 {
                panBeginScaleX = 1
            }
            
            if panBeginScaleY < 0 {
                panBeginScaleY = 0
            }else if panBeginScaleY > 1 {
                panBeginScaleY = 1
            }
            
            delegate?.epPhotoPanGestureRecognizerBegin(pan,photo: self.photo)
            
            break
        case .changed:
            
            imageView.frame.size = CGSize.init(width: transitionImageViewFrame.size.width * scale, height: transitionImageViewFrame.size.height * scale)
            
            var frame = imageView.frame
            
            frame.origin.x = transitionImageViewFrame.origin.x + (transitionImageViewFrame.size.width -
                imageView.frame.size.width ) * panBeginScaleX  + translation.x
            
            frame.origin.y = transitionImageViewFrame.origin.y + (transitionImageViewFrame.size.height -
                imageView.frame.size.height ) * panBeginScaleY  + translation.y
            
            imageView.frame = frame
            
            
            break
        case .failed,.cancelled,.ended:
            
            if translation.y <= 80 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.frame = self.transitionImageViewFrame
                })
                
                scrollView.delegate = self
                
            }else {
                
                imageView.isHidden = true
            }
            
            delegate?.epPhotoPanGestureRecognizerEnd(imageView.frame,photo: self.photo)
            
            break
        }
    }
    
    
    func updatePhoto(_ photo: YLPhoto) {
        
        self.photo = photo
        
        scrollView.setZoomScale(1, animated: false)
        scrollView.contentOffset.y = 0
        
        imageView.image = nil
        
        if let image = photo.image {
            imageView.frame = YLPhotoBrowser.getImageViewFrame(image.size)
            imageView.image = image
        }
        
        if photo.assetModel?.type == .gif {
            if let asset = photo.assetModel?.asset {
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.fast
                options.isSynchronous = true
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { [weak self] (data:Data?, dataUTI:String?, _, _) in
                    
                    if let data = data {
                        self?.imageView.image =  UIImage.yl_gifWithData(data)
                    }
                    
                })
            }
        }
        
        scrollView.contentSize = imageView.frame.size
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

// MARK: - UIGestureRecognizerDelegate
extension YLPhotoCell: UIGestureRecognizerDelegate {
    
    func isScrollViewOnTopOrBottom(_ pan:UIPanGestureRecognizer) -> Bool {
        
        let translation = pan.translation(in:  pan.view?.superview)
        
        if translation.y > 0 && scrollView.contentOffset.y <= 0 {
            return true
        }
        
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIPanGestureRecognizer &&
            gestureRecognizer.state == UIGestureRecognizerState.possible {
            if isScrollViewOnTopOrBottom(gestureRecognizer as! UIPanGestureRecognizer) {
                return true
            }
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIPanGestureRecognizer &&
            otherGestureRecognizer is UIPanGestureRecognizer &&
            otherGestureRecognizer.view == scrollView {
            return true
        }
        
        return false
    }
}
