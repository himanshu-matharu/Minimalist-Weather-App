//
//  CityModel.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-29.
//

import Foundation

struct City:Codable{
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let url: URL?
    
    init(id:Int, name:String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.url = URL(string: "cityId://\(id)")
    }
}
