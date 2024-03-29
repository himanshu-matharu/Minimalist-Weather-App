//
//  WeatherData.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation
import WidgetKit

enum UpdateActions: String{
    case delete
    case update
    case add
}

protocol WeatherDataDelegate: AnyObject{
    func didUpdateWeather(_ weatherDataInstance: WeatherData)
    func didUpdateForecast(_ weatherDataInstance: WeatherData)
    func didUpdateCities(_ weatherDataInstance: WeatherData, action:UpdateActions)
}

class WeatherData {
    
    //MARK: - Variables and Properties
    var cities : [City] = []
    private var cityWeatherMap : [Int:WeatherModel] = [:]
    private var cityForecastMap : [Int:[Forecast]] = [:]
    let multicastDelegate = MulticastDelegate<WeatherDataDelegate>()
    var isLoaded : Bool = false
    var cityIdInUrl: URL?
    
    //MARK: - Initialization
    init(){
        initCities()
    }
    
    //MARK: - Class Methods
    func initCities(){
        if let data = UserDefaults(suiteName: K.appGroupBundleId)!.data(forKey: K.savedCitiesKey){
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
    
    func getCityIndex(with url:URL) -> Int?{
        return cities.firstIndex { city in
            city.url == url
        }
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
        multicastDelegate.invokeForEachDelegate { delegate in
            delegate.didUpdateForecast(self)
        }
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
        multicastDelegate.invokeForEachDelegate { delegate in
            delegate.didUpdateCities(self, action: .delete)
        }
    }
    
    func addSavedCity(city:City, weather:WeatherModel){
        let key = getAvailableCityId()
        let newCity = City(id: key, name: city.name, latitude: city.latitude, longitude: city.longitude)
        cities.append(newCity)
        cityWeatherMap[newCity.id] = weather
        cityForecastMap[newCity.id] = nil
        updateSavedCities()
        multicastDelegate.invokeForEachDelegate { delegate in
            delegate.didUpdateCities(self, action: .add)
        }
    }
    
    func updateSavedCities(){
        let defaults = UserDefaults(suiteName: K.appGroupBundleId)!
        do{
            let encoder = JSONEncoder()
            let cities = try encoder.encode(cities)
            defaults.set(cities,forKey: K.savedCitiesKey)
            WidgetCenter.shared.reloadAllTimelines()
        }catch{
            print("Unable to encode and update saved cities array")
        }
    }
    
    func rearrangeSavedCity(from sourceIndex:Int,to destinationIndex:Int){
        let cityToRearrange = cities.remove(at: sourceIndex)
        cities.insert(cityToRearrange, at: destinationIndex)
        updateSavedCities()
        multicastDelegate.invokeForEachDelegate { delegate in
            delegate.didUpdateCities(self, action: .update)
        }
    }
    
    func getAvailableCityId() -> Int{
        var maxId = 0
        for city in cities{
            maxId = max(maxId, city.id)
        }
        return maxId + 1
    }
}
