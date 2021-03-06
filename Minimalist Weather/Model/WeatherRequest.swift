//
//  WeatherData.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import Foundation

struct ForecastRequest: Decodable {
    let list: [ForecastRequestSub]
}

struct ForecastRequestSub: Decodable {
    let dt: Double
    let main: Main
    let weather: [Weather]
}

struct WeatherRequest: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather:Decodable{
    let description: String
}
