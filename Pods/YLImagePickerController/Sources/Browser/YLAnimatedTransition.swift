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
            customPush.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
            customPop.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        }
    }
    var transitionBrowserImgFrame: CGRect? {
        didSet {
            percentIntractive.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
            customPush.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
            customPop.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        }
    }
    var transitionImage: UIImage? {
        didSet {
            percentIntractive.transitionImage = transitionImage
            customPush.transitionImage = transitionImage
            customPop.transitionImage = transitionImage
        }
    }
    var gestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            if let gestureRecognizer = gestureRecognizer {
                percentIntractive.gestureRecognizer = gestureRecognizer
            }

        }
    }
    
    private var customPush:YLPushAnimator = YLPushAnimator()
    private var customPop:YLPopAnimator = YLPopAnimator()
    private var percentIntractive:YLDrivenInteractive = YLDrivenInteractive()
    
    func update(_ transitionImage: UIImage?,transitionOriginalImgFrame: CGRect? ,transitionBrowserImgFrame: CGRect?) {
        
        self.transitionOriginalImgFrame = transitionOriginalImgFrame ?? CGRect.zero
        self.transitionBrowserImgFrame = transitionBrowserImgFrame ?? CGRect.zero
        self.transitionImage = transitionImage
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
