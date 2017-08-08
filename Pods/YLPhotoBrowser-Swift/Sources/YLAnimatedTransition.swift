//
//  YLAnimatedTransition.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLAnimatedTransition: NSObject,UIViewControllerTransitioningDelegate {
    
    var transitionOriginalImgFrame: CGRect? {
        didSet {
            percentIntractive.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        }
    }
    var transitionBrowserImgFrame: CGRect? {
        didSet {
            percentIntractive.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        }
    }
    var transitionImage: UIImage? {
        didSet {
            percentIntractive.transitionImage = transitionImage
        }
    }
    var transitionImageView: UIView? {
        didSet {
            percentIntractive.transitionImageView = transitionImageView
        }
    }
    var gestureRecognizer: UIPanGestureRecognizer! {
        didSet {
            percentIntractive.gestureRecognizer = gestureRecognizer
        }
    }
    
    private var customPush:YLPushAnimator = YLPushAnimator()
    private var customPop:YLPopAnimator = YLPopAnimator()
    private var percentIntractive:YLDrivenInteractive = YLDrivenInteractive()
    
    deinit {
        
    }
    
    convenience init(_ transitionImage: UIImage?,transitionImageView: UIView?,transitionOriginalImgFrame: CGRect? ,transitionBrowserImgFrame: CGRect?) {
        self.init()
        
        customPush.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        customPop.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        customPush.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        customPop.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        customPush.transitionImage = transitionImage
        customPop.transitionImage = transitionImage
        customPush.transitionImageView = transitionImageView
        customPop.transitionImageView = transitionImageView

    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPush
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPop
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if gestureRecognizer != nil {
            return percentIntractive
        }else {
            return nil
        }
    }
    
    
}
