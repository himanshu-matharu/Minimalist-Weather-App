//
//  WeatherManager.swift
//  WidgetExtension
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    //MARK: - Variables and Properties
    let network = Network()
    var weatherData : WeatherModel?
    var cities: [City]?
    var selectedCity: City?
    
    //MARK: - Class Methods
    init(){
        initCities()
    }
    
    func initCities(){
        if let data = UserDefaults(suiteName: K.appGroupBundleId)!.data(forKey: K.savedCitiesKey){
            do {
                let decoder = JSONDecoder()
                cities = try decoder.decode([City].self, from: data)
            }catch{
                print("Unable to decode saved cities (\(error)")
            }
        }
    }
    
    func loadCityWeatherData(city:City, completion: @escaping (Bool)->()){
        let urlString = "\(K.apiBaseUrl)?appid=\(K.apiKey)&units=\(K.apiUnits)&lat=\(city.latitude)&lon=\(city.longitude)"
        network.performWeatherRequest(with: urlString) { weatherModel, success in
            self.weatherData = weatherModel
            if city.id != 0{
                self.weatherData?.cityName = city.name
            }
            self.selectedCity = city
            completion(success)
        }
    }
}
