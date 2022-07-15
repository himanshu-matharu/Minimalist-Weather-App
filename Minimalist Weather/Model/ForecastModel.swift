//
//  ForecastModel.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-15.
//

import Foundation

class ForecastModel {
    //MARK: - Variables and Properties
    var forecasts: [Forecast]
    
    //MARK: - Initialization
    init(forecasts:[Forecast]){
        self.forecasts = forecasts
    }
}

class Forecast {
    //MARK: - Variables and Properties
    var date:Date
    var temp:Double
    var tempLow:Double
    var tempHigh:Double
    var description:String
    
    var dateWoTime: Date?{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month,.day], from: date)) ?? nil
    }
    
    var dayOfWeek: String?{
        return date.dayOfWeek() ?? nil
    }
    
    //MARK: - Initialization
    init(date:Date,temp:Double,tempLow:Double,tempHigh:Double,description:String){
        self.date = date
        self.temp = temp
        self.tempLow = tempLow
        self.tempHigh = tempHigh
        self.description = description
    }
}
