//
//  ScrollView+RemoveAllSubviews.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-30.
//

import Foundation
import UIKit

extension UIScrollView{
    func removeAllSubviews(){
        let subviews = self.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
