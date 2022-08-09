//
//  SceneDelegate.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // TODO: Remove the redundant cities, and just change to default saved cities
    let DUMMY_CITIES : [City] = [
        City(id: 0, name: "My Location", latitude: 0, longitude: 0),
        City(id: 1,name: "Frankfurt", latitude: 50.11630522359943, longitude: 8.683179487766711),
        City(id: 2,name: "Paris", latitude: 48.85345575326961, longitude: 2.3500839018335804),
        City(id: 3,name: "Budapest", latitude: 47.51777591723693, longitude: 19.046526389932264),
        City(id: 4,name: "London", latitude: 51.496936024546535, longitude: -0.12289001864225133)
    ]
    
    var window: UIWindow?
    let locationManager = CLLocationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // TODO: temporary initialization. remove it later
        UserDefaults(suiteName: K.appGroupBundleId)?.set(false, forKey: K.launchedBeforeKey)
//        UserDefaults.standard.set(false, forKey: K.launchedBeforeKey)
    
        setupCityDefaults()
        
        // Initialize weather data instance
        let weatherData = WeatherData()
        WeatherManager.shared.weatherData = weatherData
        
        if let widgetUrl = connectionOptions.urlContexts.first?.url{
            WeatherManager.shared.weatherData?.cityIdInUrl = widgetUrl
        }
        
        if let navigationController = window?.rootViewController as? UINavigationController,
           let mainVC = navigationController.viewControllers.first as? MainViewController
        {
            mainVC.weatherData = weatherData
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {return}
        WeatherManager.shared.weatherData?.cityIdInUrl = firstUrl
    }

    //MARK: - Custom Methods
    private func setupCityDefaults(){
//        let defaults = UserDefaults.standard
        let defaults = UserDefaults(suiteName: K.appGroupBundleId)!
        
        let launchedBefore = defaults.bool(forKey: K.launchedBeforeKey)
        if !launchedBefore{
            do{
                let encoder = JSONEncoder()
                let cities = try encoder.encode(DUMMY_CITIES)
                defaults.set(true, forKey: K.launchedBeforeKey)
                defaults.set(cities,forKey: K.savedCitiesKey)
            }catch{
                print("Unable to encode dummy cities array")
            }
        }
    }

}

//MARK: - CLLocationManagerDelegate

extension SceneDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if error == nil{
                    let firstLocation = placemarks?[0]
                    let cityName = firstLocation?.locality ?? "My Location"
                    WeatherManager.shared.weatherData?.updateMyLocation(city: cityName, latitude: latitude, longitude: longitude)
                    WeatherManager.shared.loadAllData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

