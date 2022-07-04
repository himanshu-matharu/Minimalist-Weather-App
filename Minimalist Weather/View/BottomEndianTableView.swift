//
//  BottomEndianTableView.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-04.
//

import UIKit

class BottomEndianTableView: UITableView {

    private var observer: Any?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        observer = observe(\.contentSize, changeHandler: { _, _ in
            DispatchQueue.main.async {
                [weak self] in
                self?.scrollToEnd(animated:false)
            }
        })
    }
    
    func scrollToEnd(animated:Bool){
        let scrollDistance = contentSize.height - frame.height
        setContentOffset(CGPoint(x: 0, y: scrollDistance), animated: animated)
    }

}
