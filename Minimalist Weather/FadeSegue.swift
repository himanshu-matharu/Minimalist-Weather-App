//
//  FadeSegue.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class FadeSegue: UIStoryboardSegue {
    override func perform() {
        fade()
    }
    
    func fade(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            toViewController.view.transform = CGAffineTransform.identity
        } completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }

        
    }
}
