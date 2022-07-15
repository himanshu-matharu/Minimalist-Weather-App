//
//  WeatherModel.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import Foundation

class WeatherModel{
    
    //MARK: - Variables and properties
    var cityName: String
    var tempNow: Double
    var tempLow: Double
    var tempHigh: Double
    var description: String
    
    //MARK: - Initialization
    init(cityName:String, tempNow: Double, tempLow: Double, tempHigh:Double, description:String){
        self.cityName = cityName
        self.tempNow = tempNow
        self.tempLow = tempLow
        self.tempHigh = tempHigh
        self.description = description
    }
}
