//
//  WeatherData.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation

enum UpdateActions: String{
    case delete
    case update
}

protocol WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData)
    func didUpdateForecast(_ weatherDataInstance: WeatherData)
    func didUpdateCities(_ weatherDataInstance: WeatherData, action:UpdateActions)
}

class WeatherData {
    
    //MARK: - Variables and Properties
    var cities : [City] = []
    private var cityWeatherMap : [Int:WeatherModel] = [:]
    private var cityForecastMap : [Int:[Forecast]] = [:]
    var delegate : WeatherDataDelegate?
    var isLoaded : Bool = false
    
    //MARK: - Initialization
    init(){
//        cities = UserDefaults.standard.array(forKey: K.savedCitiesKey) as! [String]
//        for city in cities {
//            cityWeatherMap[city] = nil
//            cityForecastMap[city] = nil
//        }
        initCities()
    }
    
    //MARK: - Class Methods
    func initCities(){
        if let data = UserDefaults.standard.data(forKey: K.savedCitiesKey){
            do {
                let decoder = JSONDecoder()
                cities = try decoder.decode([City].self, from: data)
                for city in cities{
                    cityWeatherMap[city.id] = nil
                    cityForecastMap[city.id] = nil
                }
            }catch{
                print("Unable to decode saved cities (\(error)")
            }
        }
    }
    
    func updateCityWeather(city:City, weather: WeatherModel){
        cityWeatherMap[city.id] = weather
    }
    
    func getCityWeather(city:City) -> WeatherModel?{
        return cityWeatherMap[city.id]
    }
    
    func getCityForecast(city:City) -> [Forecast]?{
        return cityForecastMap[city.id]
    }
    
    func getCitiesCount()-> Int{
        return cities.count
    }
    
    func updateForecastDate(city:City, forecastModel: ForecastModel){
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
        cityForecastMap[city.id] = final
        delegate?.didUpdateForecast(self)
    }
    
    func updateMyLocation(city:String,latitude:Double,longitude:Double){
        cities[0] = City(id: 0, name: city, latitude: latitude, longitude: longitude)
    }
    
    func removeSavedCity(index:Int){
        let cityToRemove = cities[index]
        cities.remove(at: index)
        cityWeatherMap.removeValue(forKey: cityToRemove.id)
        cityForecastMap.removeValue(forKey: cityToRemove.id)
        updateSavedCities()
        delegate?.didUpdateCities(self, action: .delete)
    }
    
    func updateSavedCities(){
        let defaults = UserDefaults.standard
        do{
            let encoder = JSONEncoder()
            let cities = try encoder.encode(cities)
            defaults.set(cities,forKey: K.savedCitiesKey)
        }catch{
            print("Unable to encode and update saved cities array")
        }
    }
}
