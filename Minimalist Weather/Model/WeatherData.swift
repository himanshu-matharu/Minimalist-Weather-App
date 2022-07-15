//
//  WeatherData.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation

protocol WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData)
    func didUpdateForecast(_ weatherDataInstance: WeatherData)
}

class WeatherData {
    
    //MARK: - Variables and Properties
    var cities : [String] = []
    private var cityWeatherMap : [String:WeatherModel] = [:]
    private var cityForecastMap : [String:[Forecast]] = [:]
    var delegate : WeatherDataDelegate?
    var isLoaded : Bool = false
    
    //MARK: - Initialization
    init(){
        cities = UserDefaults.standard.array(forKey: K.savedCitiesKey) as! [String]
        for city in cities {
            cityWeatherMap[city] = nil
            cityForecastMap[city] = nil
        }
    }
    
    //MARK: - Class Methods
    func updateCityWeather(city:String, weather: WeatherModel){
        cityWeatherMap[city] = weather
    }
    
    func getCityWeather(city:String) -> WeatherModel?{
        return cityWeatherMap[city]
    }
    
    func getCityForecast(city:String) -> [Forecast]?{
        return cityForecastMap[city]
    }
    
    func getCitiesCount()-> Int{
        return cities.count
    }
    
    func updateForecastDate(city:String, forecastModel: ForecastModel){
        var final: [Forecast] = []
        let forecastsByDate = Dictionary(grouping: forecastModel.forecasts, by: {$0.dateWoTime})
        for (date, forecast) in forecastsByDate{
            let avgTemp = forecast.map { each in return each.temp }.average
            let avgTempLow = forecast.map { each in return each.tempLow }.average
            let avgTempHigh = forecast.map { each in return each.tempHigh }.average
            let description = forecast.map {each in return each.description }.mostFrequent()
            final.append(Forecast(date: date!, temp: avgTemp, tempLow: avgTempLow, tempHigh: avgTempHigh, description: description!))
        }
        final = final.sorted(by: {$0.date.compare($1.date) == .orderedAscending})
        cityForecastMap[city] = final
        delegate?.didUpdateForecast(self)
    }
}
