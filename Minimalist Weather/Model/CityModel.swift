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
}
