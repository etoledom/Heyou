//
//  HYPresentationAnimator.swift
//  HeyouDemo
//
//  Created by E. Toledo on 9/7/16.
//  Copyright © 2016 eToledoM. All rights reserved.
//

import UIKit

protocol HYPresentationAnimatable {
    var topView: UIView { get }
    var backgroundView: UIView { get }
    var animator: HYModalAlertAnimator { get set }
}

class HYModalAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.8
    var presenting  = true
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController?.view
        
        let _modalVC = presenting ?
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) :
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        guard let modalVC = _modalVC as? HYPresentationAnimatable else { fatalError("Wrong VC to present") }
        
        let backgroundView = modalVC.backgroundView
        
        let alertView = modalVC.topView
        alertView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        originFrame = alertView.frame
        
        if #available(iOS 8.0, *) {
            if let toView = toView where presenting == true {
                containerView.addSubview(toView)
            }
        } else {
            if let toView = toView {
                containerView.insertSubview(toView, atIndex: 0)
            }
        }
        
        
        if presenting {
            presentAnimation(backgroundView: backgroundView, alertView: alertView, containerView: containerView, context: transitionContext)
        }
        else {
            dismissAnimation(backgroundView: backgroundView, alertView: alertView, containerView: containerView, context: transitionContext)
        }
        
    }
    
    private func presentAnimation(backgroundView backgroundView: UIView, alertView: UIView, containerView: UIView, context: UIViewControllerContextTransitioning) {
        
        alertView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        alertView.center = CGPoint(x: CGRectGetMidX(originFrame),
                                   y: CGRectGetMidY(originFrame))
        alertView.clipsToBounds = true
        
        backgroundView.alpha = 0
        containerView.bringSubviewToFront(backgroundView)
        
        UIView.animateWithDuration(0.2, animations:
            {
                backgroundView.alpha = CGFloat(1)
            },
                                   completion: nil)
        
        UIView.animateWithDuration(duration - 0.3, delay:0.2,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0.0,
                                   options: [],
                                   animations:
            {
                alertView.transform = CGAffineTransformIdentity
        }) { //Completion
            _ in context.completeTransition(true)
        }
    }
    
    private func dismissAnimation(backgroundView backgroundView: UIView, alertView: UIView, containerView: UIView, context: UIViewControllerContextTransitioning)
    {
        //        let scaleAnimation = POP
        UIView.animateWithDuration(0.5, delay:0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0.0,
                                   options: [],
                                   animations:
            {
                //            alertView.transform = CGAffineTransformMakeTranslation(0, -alertView.frame.size.height)
                alertView.alpha = 0
                alertView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            },completion: nil)
        
        UIView.animateWithDuration(duration - 0.3, delay: 0.3, options: [], animations:
            {
                backgroundView.alpha = CGFloat(0)
            })
        { //Completion
            _ in context.completeTransition(true)
        }
    }
}
