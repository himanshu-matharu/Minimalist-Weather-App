//
//  IntentHandler.swift
//  Widget Intent
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: SelectCityIntentHandling{
    func provideCityOptionsCollection(for intent: SelectCityIntent, with completion: @escaping (INObjectCollection<CityINO>?, Error?) -> Void) {
        var cities = [CityINO]()
        if let data = UserDefaults(suiteName: K.appGroupBundleId)!.data(forKey: K.savedCitiesKey){
            do {
                let decoder = JSONDecoder()
                try decoder.decode([City].self, from: data).forEach({ city in
                    let cityIntentObject = CityINO(identifier: "\(city.id)", display: city.name)
                    cities.append(cityIntentObject)
                })
                completion(INObjectCollection(items: cities),nil)
            }catch{
                print("Unable to decode saved cities (\(error)")
                completion(nil,error)
            }
        }else{
            completion(nil,nil)
        }
    }
}
