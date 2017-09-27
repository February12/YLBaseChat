//
//  YLPushAnimator.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPushAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    var transitionImage: UIImage?
    var transitionImageView: UIView?
    var transitionOriginalImgFrame: CGRect = CGRect.zero
    var transitionBrowserImgFrame: CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 转场过渡的容器view
        let containerView = transitionContext.containerView
        
        // FromVC
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        let fromView = fromViewController?.view
//        fromView?.isHidden = true
        
        // ToVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController?.view
        containerView.addSubview(toView!)
        toView?.isHidden = true
        
        if transitionOriginalImgFrame == CGRect.zero ||
            (transitionImage == nil && transitionImageView == nil) {
            
            toView?.isHidden = false
            toView?.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                toView?.alpha = 1
                
            }, completion: { (finished:Bool) in
                
                // 设置transitionContext通知系统动画执行完毕
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            return
        }
        
        // 有渐变的黑色背景
        let bgView = UIView.init(frame: containerView.bounds)
        bgView.backgroundColor = PhotoBrowserBG
        bgView.alpha = 0
        containerView.addSubview(bgView)
        
        // 过渡的图片
        let transitionImgView = transitionImageView ?? UIImageView.init(image: self.transitionImage)
        transitionImgView.frame = self.transitionOriginalImgFrame
        transitionImageView?.layoutIfNeeded()
        containerView.addSubview(transitionImgView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            transitionImgView.frame = (self?.transitionBrowserImgFrame)!
            self?.transitionImageView?.layoutIfNeeded()
            bgView.alpha = 1
            
        }) { (finished:Bool) in
            
            toView?.isHidden = false
            
            bgView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
}
