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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
