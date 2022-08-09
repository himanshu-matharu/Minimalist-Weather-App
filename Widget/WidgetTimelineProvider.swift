//
//  WidgetTimelineProvider.swift
//  WidgetExtension
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import WidgetKit

struct WidgetTimelineProvider: IntentTimelineProvider{
    let weatherManager = WeatherManager()
    let locationManager = LocationManager()
    
    typealias Entry = WidgetEntry
    typealias Intent = SelectCityIntent
    
    func placeholder(in context: Context) -> WidgetEntry {
        createPlaceHolder()
    }
    
    func getSnapshot(for configuration: SelectCityIntent, in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        if context.isPreview{
            completion(createPlaceHolder())
            return
        }
        let selectedCity = lookupCityDetails(for: configuration)
        if selectedCity.id == -1 {
            let entry = WidgetEntry(date: Date(), weather: WeatherModel(cityName: "Error", tempNow: 0, tempLow: 0, tempHigh: 0, description: "Error"), widgetUrl: nil)
            completion(entry)
        }else{
            weatherManager.loadCityWeatherData(city: selectedCity) { success in
                if success{
                    let entry = WidgetEntry(date: Date(), weather: weatherManager.weatherData!,widgetUrl: selectedCity.url)
                    completion(entry)
                }else{
                    let entry = WidgetEntry(date: Date(), weather: WeatherModel(cityName: "Error", tempNow: 0, tempLow: 0, tempHigh: 0, description: "Error"), widgetUrl: nil)
                    completion(entry)
                }
            }
        }
    }
    
    func getTimeline(for configuration: SelectCityIntent, in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour,value: 1 , to: currentDate)!
        
        let selectedCity = lookupCityDetails(for: configuration)
        
        if selectedCity.id == -1{
            completion(Timeline(entries: [WidgetEntry(date: Date(), weather: WeatherModel(cityName: "Error", tempNow: 0, tempLow: 0, tempHigh: 0, description: "Error"), widgetUrl: nil)], policy: .never))
        }else{
            weatherManager.loadCityWeatherData(city: selectedCity) { success in
                var entries = [WidgetEntry]()
                if success{
                    let entry = WidgetEntry(date: currentDate, weather: weatherManager.weatherData!, widgetUrl: selectedCity.url)
                    entries.append(entry)
                }else{
                    entries.append(WidgetEntry(date: currentDate, weather: WeatherModel(cityName: "Error", tempNow: 0, tempLow: 0, tempHigh: 0, description: "Error"), widgetUrl: nil))
                }
                let timeline = Timeline(entries: entries, policy: .after(refreshDate))
                completion(timeline)
            }
        }
    }
    
    private func createPlaceHolder() -> WidgetEntry {
        let weather = WeatherModel(cityName: "London", tempNow: 26, tempLow: 26, tempHigh: 26, description: "Clear and Sunny")
        return WidgetEntry(date: Date(), weather: weather, widgetUrl: nil)
    }
    
    private func lookupCityDetails(for configuration: SelectCityIntent) -> City{
        
        let cityId = configuration.city?.identifier ?? "0"
        guard let cityForConfig = weatherManager.cities?.first(where: { city in
                  city.id == Int(cityId)
              })
        else{
            return City(id: -1, name: "Error", latitude: 0, longitude: 0)
        }
        
        if Int(cityId) == 0{
            guard let location = locationManager.location else { return City(id: 0, name: "Error", latitude: 0, longitude: 0)}
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return City(id: 0, name: "My Location", latitude: latitude, longitude: longitude)
        }else{
            return cityForConfig
        }
    }
}
