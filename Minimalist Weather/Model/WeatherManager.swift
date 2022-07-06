//
//  WeatherManager.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel, index:Int)
    func didFailWithError(error:Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ab0cab1996187a8e5d0d6c54e05fc616&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String, index:Int){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString, index:index)
    }
    
    func performRequest(with urlString:String, index:Int){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather, index:index)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let description = decodedData.weather[0].description
            let tempNow = decodedData.main.temp
            let tempLow = decodedData.main.temp_min
            let tempHigh = decodedData.main.temp_max
            let name = decodedData.name
            
            let model = WeatherModel(cityName: name, tempNow: tempNow, tempLow: tempLow, tempHigh: tempHigh, description: description)
            
            return model
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
