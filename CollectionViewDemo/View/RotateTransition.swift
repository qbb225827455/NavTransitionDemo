//
//  RotateTransition.swift
//  CollectionViewDemo
//
//  Created by 陳鈺翔 on 2022/8/17.
//

import UIKit

class RotateTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var isPresent = false
    
    let duration = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 取得 fromView, toView, containView 的參照
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        let container = transitionContext.containerView
        
        let rotateOut = CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180)
        
        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        toView.layer.position = CGPoint(x: 0, y: 0)
        fromView.layer.position = CGPoint(x: 0, y: 0)
        
        toView.transform = rotateOut
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresent {
                fromView.transform = rotateOut
                fromView.alpha = 0
                toView.transform = .identity
                toView.alpha = 1.0
            } else {
                fromView.transform = rotateOut
                fromView.alpha = 0
                toView.transform = .identity
                toView.alpha = 1.0
            }
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
        })
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        isPresent = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        
        return self
    }
}
