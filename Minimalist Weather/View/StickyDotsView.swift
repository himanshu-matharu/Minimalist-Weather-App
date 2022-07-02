//
//  StickyDotsView.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-02.
//

import UIKit

public class StickyDotsView: UIView {
    
    private var indicatorView = UIView(frame: CGRect(x: 10,y: 10,width: 10,height: 10))
    
    private var scrollViewObserver: NSKeyValueObservation?
    
    /// The scrollView to attach to
    @IBOutlet @objc public weak var attachedView: UIScrollView?
    
    private var scrollIndicatorSize: CGFloat = 0
    
    /// Width of your scroll view (not its content)
    ///
    /// Automatically managed if you set the attached view. Can be manually set or overridden.
    ///
    /// If -1, use the attachedView width. if -2, use superview's width. Otherwise use number.
    @IBInspectable public var viewWidth: CGFloat = -1
    private var _viewWidth: CGFloat {
        switch viewWidth {
        case -1:
            return attachedView?.frame.width ?? 0
        case -2:
            if self.superview != nil {
                return self.superview!.bounds.width
            }
            else {
                fallthrough
            }
        default:
            return viewWidth
        }
    }
    
    /// Number of pages in your scrollView
    ///
    /// Automatically managed if you set the attached view. Can be manually set or overridden.
    @IBInspectable public var numOfPages: Int = -1
    private var _numOfPages: Int {
        let scrollViewPages:Int? = attachedView != nil ? Int(round(attachedView!.contentSize.width / _viewWidth)) : nil
        return numOfPages != -1 ? numOfPages : scrollViewPages ?? 0
    }
    
    /// The width of each of your circles in the page indicator
    ///
    /// Default is 10px. Can be changed.
    @IBInspectable public var circleWidth: CGFloat = 10
    

    public convenience init(frame: CGRect, attachedTo: UIScrollView? = nil, indicatorColor:UIColor = .white, dotsWidth:CGFloat = 10, dotsColor:UIColor = .black, dotsAlpha:CGFloat = 0.5) {
        self.init(frame: frame)
        self.attachedView = attachedTo
        self.circleWidth = dotsWidth
        
        let indicatorsWidth = CGFloat(2 * _numOfPages - 1) * circleWidth
        indicatorView.frame.size.width = circleWidth
        indicatorView.frame.size.height = circleWidth
        indicatorView.center.x = circleWidth
        indicatorView.center.y = circleWidth
        indicatorView.layer.cornerRadius = circleWidth * 0.5
        indicatorView.backgroundColor = indicatorColor
        
        self.frame.size = CGSize(width: indicatorsWidth, height: circleWidth)
        
        let dotsView = UIView(frame: CGRect(x: 0, y: 0, width: indicatorsWidth, height: circleWidth))
        for i in 0...(_numOfPages - 1) {
            let dotView = UIView(frame: CGRect(
                x: (circleWidth * 0.5) + (2 * circleWidth * CGFloat(i)),
                y: circleWidth * 0.5,
                width: circleWidth,
                height: circleWidth))
            
            dotView.backgroundColor = dotsColor
            dotView.alpha = dotsAlpha
            dotView.layer.cornerRadius = circleWidth * 0.5
            dotsView.addSubview(dotView)
        }
        
        self.addSubview(dotsView)
        self.addSubview(indicatorView)
        print("laid out subviews")
    }
    
    override public func layoutSubviews() {
        if self.attachedView != nil && self.scrollViewObserver == nil {
            self.scrollViewObserver = observe(
                \.attachedView!.contentOffset,
                options: .new
            ) { object, change in
                self.updatePageIndicator(offset: change.newValue!.x)
            }
        }
    }
    
    /// Update the page indicator to a specified offset.
    ///
    /// The offset should be either the contentOffset relative to the contentSize or a percentage
    /// - Parameter offset: The offset
    /// - Parameter percent: Whether the value being passed in is a percentage, or contentOffset.x
    public func updatePageIndicator(offset: CGFloat, percent: Bool = false) {
        let xccord = percent ? offset * _viewWidth * CGFloat(_numOfPages) : offset
        let number = xccord / _viewWidth
        let page = Int(floor(number))
        let diff = number - CGFloat(page)
        let distance = 0.5 - diff
        let absolute = abs(distance) * 2
        scrollIndicatorSize = page >= 0 && page < _numOfPages - 1  ? circleWidth + ((1 - absolute) * 2 * circleWidth) : circleWidth
        indicatorView.frame.size.width = scrollIndicatorSize
        if xccord >= 0 {
            indicatorView.center.x = circleWidth + number * 2 * circleWidth
        }
        else if xccord < _viewWidth * CGFloat(_numOfPages - 1) {
            indicatorView.center.x = circleWidth
        }
        else {
            indicatorView.center.x = circleWidth + CGFloat(_numOfPages - 1) * circleWidth
        }
        indicatorView.layer.cornerRadius = circleWidth * 0.5
//        print(indicatorView.frame)
    }
}
