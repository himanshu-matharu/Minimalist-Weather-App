//
//  ForecastCell.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-06.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var tempValue: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLeadingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeLeadingConstraint.constant = 10 - timeLabel.frame.width/2
        timeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
    func translateRotate() -> CGAffineTransform {
        let transform = CGAffineTransform.identity
        transform.translatedBy(x: (self.bounds.width/2) - (self.bounds.height/2), y: (self.bounds.height/2) - (self.bounds.width/2))
        transform.rotated(by: -CGFloat.pi/2)
        return transform
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
