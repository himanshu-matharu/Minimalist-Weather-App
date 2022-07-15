//
//  Constants.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

struct K {
    static let optionsSegue = "MainToOptions"
    static let detailSegue = "MainToDetails"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "TempCell"
    static let forecastCellIdentifier = "ReusableForecastCell"
    static let forecastCellNibName = "ForecastCell"
    
    static let launchedBeforeKey = "LaunchedBefore"
    static let savedCitiesKey = "SavedCities"
    
    static let apiBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "ab0cab1996187a8e5d0d6c54e05fc616"
    static let apiUnits = "metric"
}
