//
//  WeatherData.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation

protocol WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData)
}

class WeatherData {
    
    //MARK: - Variables and Properties
    var cities : [String] = []
    private var cityWeatherMap : [String:WeatherModel] = [:]
    var delegate : WeatherDataDelegate?
    var isLoaded : Bool = false
    
    //MARK: - Initialization
    init(){
        cities = UserDefaults.standard.array(forKey: K.savedCitiesKey) as! [String]
        for city in cities {
            cityWeatherMap[city] = nil
        }
    }
    
    //MARK: - Class Methods
    func updateCityWeather(city:String, weather: WeatherModel){
        cityWeatherMap[city] = weather
    }
    
    func getCityWeather(city:String) -> WeatherModel?{
        return cityWeatherMap[city]
    }
    
    func getCitiesCount()-> Int{
        return cities.count
    }
}
