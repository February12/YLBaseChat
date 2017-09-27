//
//  YLDrivenInteractive.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLDrivenInteractive: UIPercentDrivenInteractiveTransition {
    
    var transitionOriginalImgFrame: CGRect = CGRect.zero
    var transitionBrowserImgFrame: CGRect = CGRect.zero
    var transitionImage: UIImage?
    var transitionImageView: UIView?
    var originalCoverViewBG: UIColor?
    
    var gestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            gestureRecognizer?.addTarget(self, action: #selector(YLDrivenInteractive.gestureRecognizeDidUpdate(_:)))
        }
    }
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var blackBgView: UIView?
    private var fromView: UIView?
    private var toView: UIView?
    private var originalCoverView: UIView?
    
    private var isFirst = true
    
    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if transitionContext == nil {
            return
        }
        
        let translation = gestureRecognizer.translation(in:  gestureRecognizer.view?.superview)
        
        let window = UIApplication.shared.keyWindow
        
        var scale = 1 - translation.y / (window?.frame.height ?? UIScreen.main.bounds.height)
        
        scale = scale > 1 ? 1:scale
        scale = scale < 0 ? 0:scale
        
        if isFirst {
            beginInterPercent()
            isFirst = false
        }
        
        switch gestureRecognizer.state {
        case .began:
            // 进不来
            break
        case .changed:
            update(scale)
            updateInterPercent(scale)
            break
        case .ended:
            
            if translation.y <= 80 {
                cancel()
                interPercentCancel()
            }else {
                finish()
                interPercentFinish()
            }
            
            break
        default:
            cancel()
            interPercentCancel()
            break
        }
        
    }
    
    func beginInterPercent() {
        
        // 转场过渡的容器view
        if let containerView = self.transitionContext?.containerView {
            
            // ToVC
            let toViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)
            toView = toViewController?.view
            toView?.isHidden = false
            containerView.addSubview(toView!)
            
            originalCoverView = UIView.init(frame: transitionOriginalImgFrame)
            originalCoverView?.backgroundColor = originalCoverViewBG
            containerView.addSubview(originalCoverView!)
            
            // 有渐变的黑色背景
            blackBgView = UIView.init(frame: containerView.bounds)
            blackBgView?.backgroundColor = PhotoBrowserBG
            blackBgView?.isHidden = false
            containerView.addSubview(blackBgView!)
            
            
            // fromVC
            let fromViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
            fromView = fromViewController?.view
            fromView?.backgroundColor = UIColor.clear
            fromView?.isHidden = false
            containerView.addSubview(fromView!)
        }
    }
    
    func updateInterPercent(_ scale: CGFloat) {
        blackBgView?.alpha = scale * scale * scale
    }
    
    func interPercentCancel() {
        
        gestureRecognizer?.removeTarget(self, action: #selector(YLDrivenInteractive.gestureRecognizeDidUpdate(_:)))
        gestureRecognizer = nil
        
        isFirst = true
        
        let transitionContext = self.transitionContext
        
        fromView?.backgroundColor = PhotoBrowserBG
        blackBgView?.removeFromSuperview()
        originalCoverView?.removeFromSuperview()
        
        transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled)!)
        
    }
    
    func interPercentFinish() {
        
        gestureRecognizer?.removeTarget(self, action: #selector(YLDrivenInteractive.gestureRecognizeDidUpdate(_:)))
        gestureRecognizer = nil
        
        fromView?.isHidden = true
        
        // 转场过渡的容器view
        if let containerView = self.transitionContext?.containerView {
            
            // 过度的图片
            let transitionImgView = transitionImageView ?? UIImageView.init(image: transitionImage)
            transitionImgView.frame = transitionBrowserImgFrame
            transitionImageView?.layoutIfNeeded()
            containerView.addSubview(transitionImgView)
            
            if transitionOriginalImgFrame == CGRect.zero ||
                (transitionImage == nil && transitionImageView == nil) {
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    
                    transitionImgView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    transitionImgView.alpha = 0
                    self?.blackBgView?.alpha = 0
                    
                    }, completion: { [weak self] (finished:Bool) in
                        
                        self?.blackBgView?.removeFromSuperview()
                        self?.originalCoverView?.removeFromSuperview()
                        transitionImgView.removeFromSuperview()
                        
                        self?.transitionContext?.completeTransition(!(self?.transitionContext?.transitionWasCancelled)!)
                        
                })
                
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                
                transitionImgView.frame = (self?.transitionOriginalImgFrame)!
                self?.transitionImageView?.layoutIfNeeded()
                self?.blackBgView?.alpha = 0
                
            }) { [weak self] (finished: Bool) in
                
                self?.blackBgView?.removeFromSuperview()
                self?.originalCoverView?.removeFromSuperview()
                transitionImgView.removeFromSuperview()
                
                self?.transitionContext?.completeTransition(!(self?.transitionContext?.transitionWasCancelled)!)
                
            }
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
}
