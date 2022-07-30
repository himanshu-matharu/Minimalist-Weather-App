//
//  OptionsViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var weatherData : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToMain))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func goToMain(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDataSource

extension OptionsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cities = weatherData?.cities {
            return cities.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! TempCell
        let city = weatherData?.cities[(weatherData?.getCitiesCount())! - indexPath.row - 1]
        let weather = weatherData?.getCityWeather(city: city!)
        if indexPath.row == (weatherData?.getCitiesCount())! - 1{
            cell.cityLabel.text = "My Location"
        }else{
            cell.cityLabel.text = city?.name
        }
        cell.tempLabel.text = String(format: "%.0f", weather?.tempNow ?? "--")
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete{
////            weatherData?.cities.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
////        }
////        return nil
//    }
}

//MARK: - UITableViewDelegate

extension OptionsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let totalRows = tableView.numberOfRows(inSection: 0)
        
        let trash = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            completionHandler(true)
            self.weatherData?.removeSavedCity(index: totalRows - indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        trash.backgroundColor = UIColor(named: "BackgroundColor")
        trash.image = UIImage(named: "deleteSwipeAction")
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        if indexPath.row == totalRows - 1 {
            return nil
        }else{
            return configuration
        }
    }
}
