//
//  PopFadeAnimator.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-04.
//

import UIKit

class PopFadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
        
        containerView.addSubview(toVC.view)
        toVC.view.transform = .init(translationX: 2*window.size.width, y: 1)
        toVC.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            toVC.view.transform = .init(translationX: window.size.width, y: 1)
            toVC.view.alpha = 1.0
            fromVC.view.transform = .init(translationX: -window.size.width, y: 1)
            fromVC.view.alpha = 0.0
        } completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    

}
