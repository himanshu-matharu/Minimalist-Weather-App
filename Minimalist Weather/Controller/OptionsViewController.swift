//
//  OptionsViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cities = UserDefaults.standard.array(forKey: K.savedCitiesKey) as! [String]
    var cityWeatherMap = [String:WeatherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.dataSource = self
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
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! TempCell
        let city = cities[cities.count - indexPath.row - 1]
        let weather = cityWeatherMap[city]
        cell.cityLabel.text = city
        cell.tempLabel.text = String(format: "%.0f", weather?.tempNow ?? "--")
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}
