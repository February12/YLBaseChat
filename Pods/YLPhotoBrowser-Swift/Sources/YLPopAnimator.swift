//
//  YLPopAnimator.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPopAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    var transitionImage: UIImage?
    var transitionImageView: UIView?
    var originalCoverViewBG: UIColor?
    var transitionOriginalImgFrame: CGRect = CGRect.zero
    var transitionBrowserImgFrame: CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 转场过渡的容器view
        let containerView = transitionContext.containerView
        
        // FromVC
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController?.view
        fromView?.isHidden = true
        
        // ToVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController?.view
        containerView.addSubview(toView!)
        toView?.isHidden = false
        
        let originalCoverView = UIView.init(frame: transitionOriginalImgFrame)
        originalCoverView.backgroundColor = originalCoverViewBG
        containerView.addSubview(originalCoverView)
        
        // 有渐变的黑色背景
        let bgView = UIView.init(frame: containerView.bounds)
        bgView.backgroundColor = PhotoBrowserBG
        bgView.alpha = 1
        containerView.addSubview(bgView)
        
        // 过渡的图片
        let transitionImgView = transitionImageView ?? UIImageView.init(image: self.transitionImage)
        transitionImgView.frame = self.transitionBrowserImgFrame
        transitionImageView?.layoutIfNeeded()
        containerView.addSubview(transitionImgView)
        
        if transitionOriginalImgFrame == CGRect.zero ||
            (transitionImage == nil && transitionImageView == nil) {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                transitionImgView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                transitionImgView.alpha = 0
                bgView.alpha = 0
                
            }, completion: { (finished:Bool) in
                
                bgView.removeFromSuperview()
                originalCoverView.removeFromSuperview()
                transitionImgView.removeFromSuperview()
                
                // 设置transitionContext通知系统动画执行完毕
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            return
        }
        
       UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            transitionImgView.frame = (self?.transitionOriginalImgFrame)!
            self?.transitionImageView?.layoutIfNeeded()
            bgView.alpha = 0
            
        }) { (finished:Bool) in
            
            bgView.removeFromSuperview()
            originalCoverView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
}
