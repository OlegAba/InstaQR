//
//  NotificationAnimationController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//


import UIKit

class NotificationAnimationController: NSObject {
    
    // MARK: - Internal Properties
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    // MARK: - Private Properties
    
    fileprivate let animationDuration: Double
    fileprivate let animationType: AnimationType
    
    // MARK: - Init
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension NotificationAnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                
                transitionContext.completeTransition(false)
                return
        }
        
        switch animationType {
            
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        
        viewToAnimate.clipsToBounds = true
        viewToAnimate.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.alpha = 1
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.alpha = 0
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
