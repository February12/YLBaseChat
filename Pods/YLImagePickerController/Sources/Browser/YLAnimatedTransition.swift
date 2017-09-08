//
//  YLAnimatedTransition.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLAnimatedTransition: NSObject,UINavigationControllerDelegate {
    
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
        customPush.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        customPush.transitionImage = transitionImage
        customPush.transitionImageView = transitionImageView
        
        customPop.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        customPop.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        customPop.transitionImage = transitionImage
        customPop.transitionImageView = transitionImageView
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            return customPush
        }else if operation == UINavigationControllerOperation.pop {
            return customPop
        }else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if gestureRecognizer != nil {
            return percentIntractive
        }else {
            return nil
        }
    }
}
