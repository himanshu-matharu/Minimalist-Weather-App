//
//  Date+DayOfWeek.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-15.
//

import Foundation

extension Date{
    func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).capitalized
            // or use capitalized(with: locale) if you want
        }
}
