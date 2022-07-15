//
//  DetailsViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-06.
//

import UIKit

class ForecastsViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherData: WeatherData?
    var city: String?
    var forecast : [Forecast]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()

        weatherData?.delegate = self
        initForecast()
    }
    
    private func initForecast(){
        if let loadedForecast = weatherData?.getCityForecast(city: city!){
            forecast = loadedForecast
        }else{
            WeatherManager.shared.loadForecastData(for: city!)
        }
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: K.forecastCellNibName, bundle: nil), forCellReuseIdentifier: K.forecastCellIdentifier)
    }
    
    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToMain))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.title = "FORECAST"
    }
    
    @objc func goToMain(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDataSource

extension ForecastsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecasts = forecast {
            return forecasts.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.forecastCellIdentifier, for: indexPath) as! ForecastCell
        let weather = forecast![indexPath.row]
        if indexPath.row == 0 {
            if weather.dayOfWeek == Date().dayOfWeek(){
                cell.timeLabel.text = "TODAY"
                let currentWeather = weatherData!.getCityWeather(city: city!)!
                cell.tempValue.text = String(format: "%.0f", currentWeather.tempHigh)
                cell.descriptionLabel.text = currentWeather.description.uppercased()
                return cell
            }else{
                cell.timeLabel.text = weather.dayOfWeek!.uppercased()
            }
        }else{
            cell.timeLabel.text = weather.dayOfWeek!.uppercased()
        }
        
        cell.tempValue.text = String(format: "%.0f", weather.tempHigh)
        cell.descriptionLabel.text = weather.description.uppercased()
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ForecastsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.width, height: 40))
        return vw
    }
}

//MARK: - WeatherDataDelegate

extension ForecastsViewController: WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData) {
        // do nothing
    }
    
    func didUpdateForecast(_ weatherDataInstance: WeatherData) {
        forecast = weatherData!.getCityForecast(city: city!)
        tableView.reloadData()
    }
}
