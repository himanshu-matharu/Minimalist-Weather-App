//
//  LocationManager.swift
//  WidgetExtension
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    //MARK: - Variables and Properties
    var locationManager : CLLocationManager?
    var location: CLLocation?
    
    //MARK: - Class Methods
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.locationManager!.requestWhenInUseAuthorization()
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager!.requestLocation()
        }
    }
    
    func requestUpdate(_ completion: @escaping () -> Void) {
        self.locationManager!.requestWhenInUseAuthorization()
        self.locationManager!.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
