//
//  ViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class MainViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    let cities = [
    "Frankfurt",
    "Paris",
    "Budapest",
    "London"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        highTempLabel.text = "--"
        nowTempLabel.text = "--"
        lowTempLabel.text = "--"
        descriptionLabel.text = "--"
        
        highLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        nowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        navigationController?.navigationBar.barStyle = .black
        
        weatherManager.delegate = self
        
        self.title = cities[0].uppercased()
        weatherManager.fetchWeather(cityName: cities[0])
    }

    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToOptions))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func goToOptions(){
        self.performSegue(withIdentifier: K.optionsSegue, sender: self)
    }

}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.highTempLabel.text = String(format: "%.0f", weather.tempHigh)
            self.nowTempLabel.text = String(format: "%.0f", weather.tempNow)
            self.lowTempLabel.text = String(format: "%.0f", weather.tempNow)
            self.descriptionLabel.text = weather.description.uppercased()
//            self.title = weather.cityName.uppercased()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
