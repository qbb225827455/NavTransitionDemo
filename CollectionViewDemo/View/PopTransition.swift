//
//  PopTransition.swift
//  CollectionViewDemo
//
//  Created by 陳鈺翔 on 2022/8/17.
//

import UIKit

class PopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
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
        
        let minSize = CGAffineTransform(scaleX: 0, y: 0)
        let offScreenDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        let shiftDown = CGAffineTransform(translationX: 0, y: 15)
        let scaleDown = shiftDown.scaledBy(x: 0.95, y: 0.95)
        
        toView.transform = minSize
        
        if isPresent {
            container.addSubview(fromView)
            container.addSubview(toView)
        } else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresent {
                fromView.transform = scaleDown
                fromView.alpha = 0.5
                toView.transform = .identity
            } else {
                fromView.transform = offScreenDown
                toView.alpha = 1.0
                toView.transform = .identity
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
