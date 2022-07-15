//
//  Network.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-14.
//

import Foundation

class Network {
    
    //MARK: - Class Methods
    
    func performWeatherRequest(with urlString:String, _ completion: @escaping (WeatherModel?,Bool)->()){
        guard let url = URL(string: urlString) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil,false)
            }else{
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        completion(weather,true)
                    }
                }
            }
        }
        dataTask.resume()
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
