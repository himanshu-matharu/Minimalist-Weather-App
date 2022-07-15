//
//  Network.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation

class Network {
    
    //MARK: - Class Methods
    
    func performForecastRequest(with urlString:String, _ completion: @escaping (ForecastModel?,Bool)->()){
        guard let url = URL(string: urlString) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil,false)
            }else{
                if let safeData = data{
                    if let forecast: ForecastModel = self.parseJSON(safeData){
                        completion(forecast,true)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func performWeatherRequest(with urlString:String, _ completion: @escaping (WeatherModel?,Bool)->()){
        guard let url = URL(string: urlString) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil,false)
            }else{
                if let safeData = data{
                    if let weather: WeatherModel = self.parseJSON(safeData){
                        completion(weather,true)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func parseJSON(_ forecastData:Data)->ForecastModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ForecastRequest.self, from: forecastData)
            var model: [Forecast] = []
            decodedData.list.forEach { forecast in
                let date = NSDate(timeIntervalSince1970: forecast.dt) as Date
                let temp = forecast.main.temp
                let tempHigh = forecast.main.temp_max
                let tempLow = forecast.main.temp_min
                let description = forecast.weather[0].description
                model.append(Forecast(date: date, temp: temp, tempLow: tempLow, tempHigh: tempHigh, description: description))
            }
            return ForecastModel(forecasts: model)
        }catch{
            return nil
        }
    }
    
    private func parseJSON(_ weatherData:Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherRequest.self, from: weatherData)
            let description = decodedData.weather[0].description
            let tempNow = decodedData.main.temp
            let tempLow = decodedData.main.temp_min
            let tempHigh = decodedData.main.temp_max
            let name = decodedData.name
            
            let model = WeatherModel(cityName: name, tempNow: tempNow, tempLow: tempLow, tempHigh: tempHigh, description: description)
            
            return model
        }catch{
            return nil
        }
    }
    
    
}
