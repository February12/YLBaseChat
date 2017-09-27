//
//  YLPhotoCell.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Kingfisher

protocol YLPhotoCellDelegate :NSObjectProtocol {
    func epPanGestureRecognizerBegin(_ pan: UIPanGestureRecognizer,photo: YLPhoto)
    func epPanGestureRecognizerEnd(_ currentImageViewFrame: CGRect,photo: YLPhoto)
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
        
        panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoCell.pan(_:)))
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)
        
        
        scrollView.delegate = self
        addSubview(scrollView)
        
        // scrollView 约束
        scrollView.addConstraints(toItem: self, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        scrollView.addSubview(imageView)
        
        addSubview(progressView)
        
        // progressView 约束
        progressView.addConstraints(attributes: [.centerX,.centerY,.width,.height], toItem: self, attributes: nil, constants: [0,0,40,40])
        
    }
    
    // 慢移手势
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in:  pan.view?.superview)
        
        var scale = 1 - translation.y / self.frame.height
        
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
            
            delegate?.epPanGestureRecognizerBegin(pan,photo: self.photo)
            
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
            
            delegate?.epPanGestureRecognizerEnd(imageView.frame,photo: self.photo)
            
            break
        }
    }
    
    
    func updatePhoto(_ photo: YLPhoto) {
        
        self.photo = photo
        
        scrollView.setZoomScale(1, animated: false)
        scrollView.contentOffset.y = 0
        
        imageView.image = nil
        progressView.isHidden = true
        
        if photo.imageUrl != "" {
            
            imageView.frame.size = CGSize.init(width: frame.width, height: frame.width)
            imageView.center = center
            
            imageView.image = photo.image
            
            progressView.isHidden = false
            
            KingfisherManager.shared
                .retrieveImage(with: URL(string: photo.imageUrl)!,
                               options: [.preloadAllAnimationData,.transition(.fade(1))],
                               progressBlock: { [weak self] (receivedSize:Int64, totalSize:Int64) in
                                
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
                        photo.image = img
                        
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

// MARK: - UIGestureRecognizerDelegate
extension YLPhotoCell: UIGestureRecognizerDelegate {
    
    func isScrollViewOnTopOrBottom(_ pan:UIPanGestureRecognizer) -> Bool {
        
        let translation = pan.translation(in:  pan.view?.superview)
        
        if translation.y > 0 && scrollView.contentOffset.y <= 0 {
            return true
        }
        
        //        let maxOffsetY = floor(scrollView.contentSize.height - scrollView.bounds.size.height)
        //        if translation.y < 0 && scrollView.contentOffset.y >= maxOffsetY {
        //            return true
        //        }
        return false
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 系统找到的最合适的view
        let view = super.hitTest(point, with: event)
        // 如果最合适的view 是 用于用户自定义的View 则传递给 scrollView
        if view?.tag == CoverViewTag {
            return scrollView
        }
        return view
    }
}
