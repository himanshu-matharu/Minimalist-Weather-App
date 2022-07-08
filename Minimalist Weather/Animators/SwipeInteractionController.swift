//
//  SwipeInteractionController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-07.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var fromViewController : UIViewController!
    private weak var toViewController : UIViewController!
    
    private let threshold: CGFloat = 0.7
    private let dragAmount = UIScreen.main.bounds.height - 150

    
    init(fromViewController:UIViewController,toViewController:UIViewController,swipeView:UIView){
        super.init()
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        prepareGestureRecognizer(in:swipeView)
    }
    
    private func prepareGestureRecognizer(in view:UIView){
        let gesture = UIPanGestureRecognizer(target: self, action:#selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
        completionSpeed = 0.5
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer){
        //1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        var progress = (-translation.y / dragAmount)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state{
            //2
        case .began:
            interactionInProgress = true
            fromViewController.performSegue(withIdentifier: K.detailSegue, sender: fromViewController)
            //3
        case .changed:
            shouldCompleteTransition = progress > threshold
            update(progress)
            //4
        case .cancelled:
            interactionInProgress = false
            cancel()
            
            //5
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            }else{
                cancel()
            }
            
        default:
            break
        }
    }

}
