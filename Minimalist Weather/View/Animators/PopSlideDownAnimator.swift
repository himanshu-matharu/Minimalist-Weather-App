//
//  PopSlideDownAnimator.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-06.
//

import UIKit

class PopSlideDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from)
        else{
            return
        }
        
        let window = UIScreen.main.bounds
        let containerView = transitionContext.containerView
        
        let tempView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: window.size.width, height: window.size.height)))
        tempView.backgroundColor = UIColor(named: "BackgroundColor")
        containerView.insertSubview(tempView, belowSubview: containerView.subviews.first!)
        
        containerView.addSubview(toVC.view)
        toVC.view.transform = .init(translationX: 1, y: -window.size.height)
        toVC.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            toVC.view.transform = .identity
            toVC.view.alpha = 1.0
            fromVC.view.transform = .init(translationX: 1, y: window.size.height)
            fromVC.view.alpha = 0.0
        } completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.transform = .identity
            tempView.removeFromSuperview()
        }

    }
    

}
