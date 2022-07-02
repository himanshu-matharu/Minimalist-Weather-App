//
//  TempContentView.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-01.
//

import UIKit

class TempContentView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var highValue: UILabel!
    @IBOutlet weak var nowValue: UILabel!
    @IBOutlet weak var lowValue: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TempContentView", owner: self, options: nil)
        highLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        nowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

}
