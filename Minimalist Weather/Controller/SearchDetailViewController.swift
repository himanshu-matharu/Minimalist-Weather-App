//
//  SearchDetailViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-08-02.
//

import UIKit

class SearchDetailViewController: UIViewController{
    
    @IBOutlet weak var contentView: TempContentView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dismiss: UIImageView!
    @IBOutlet weak var saveCity: UIImageView!
    
    var city : City?
    var weather: WeatherModel?
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initContentView()
        setupDismissButton()
        setupSaveCityButton()
        initWeatherData()
    }
    
    func initContentView(){
        contentView.lowValue.text = "--"
        contentView.highValue.text = "--"
        contentView.nowValue.text = "--"
        contentView.descriptionValue.text = "--"
        cityName.text = city?.name.uppercased()
    }
    
    func initWeatherData(){
        guard let city = city else {return}
        var retrievedCity : City?
        if weatherData?.cities.contains(where: { savedCity in
            if savedCity.name == city.name && savedCity.latitude == city.latitude && savedCity.longitude == city.longitude{
                retrievedCity = savedCity
                return true
            }
            return false
        }) == true{
            self.weather = weatherData?.getCityWeather(city: retrievedCity!)
            self.saveCity.isHidden = true
            self.updateContent()
        }else{
            WeatherManager.shared.loadCityWeatherData(city: city) { weather, success in
                if success{
                    DispatchQueue.main.async {
                        self.weather = weather
                        self.saveCity.isHidden = false
                        self.updateContent()
                    }
                }
            }
        }
    }
    
    func updateContent(){
        guard let weather = self.weather else {return}
        contentView.lowValue.text = String(format: "%.0f", weather.tempLow)
        contentView.highValue.text = String(format: "%.0f", weather.tempHigh)
        contentView.nowValue.text = String(format: "%.0f", weather.tempNow)
        contentView.descriptionValue.text = weather.description.uppercased()
    }
    
    func setupDismissButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        dismiss.isUserInteractionEnabled = true
        dismiss.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    func setupSaveCityButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveCityToData))
        saveCity.isUserInteractionEnabled = true
        saveCity.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func saveCityToData(){
        guard let data = weatherData else {return}
        if data.cities.count >= 8{
            showAlert()
        }else{
            guard let city = self.city else {return}
            guard let weather = self.weather else {return}
            weatherData?.addSavedCity(city: city, weather: weather)
            self.saveCity.isHidden = true
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "You already have 4 cities saved.", message: "Please delete a city to save a new one.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        self.present(alert, animated: true, completion: nil)
    }
}
