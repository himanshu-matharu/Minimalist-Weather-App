//
//  OptionsViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIImageView!
    
    var weatherData : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupSearchButton()
        
        weatherData?.multicastDelegate.add(delegate: self)
//        weatherData?.delegate = self
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToMain))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupSearchButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToSearch))
        searchButton.isUserInteractionEnabled = true
        searchButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func goToMain(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToSearch(){
        self.performSegue(withIdentifier: K.searchSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.searchSegue{
            let destination = segue.destination as! SearchViewController
            let sender = sender as! OptionsViewController
            destination.weatherData = sender.weatherData
        }
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
            cell.isUserInteractionEnabled = false
        }else{
            cell.cityLabel.text = city?.name
        }
        cell.tempLabel.text = String(format: "%.0f", weather?.tempNow ?? "--")
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromIndex = (weatherData?.getCitiesCount())! - sourceIndexPath.row - 1
        let toIndex = (weatherData?.getCitiesCount())! - destinationIndexPath.row - 1
        weatherData?.rearrangeSavedCity(from: fromIndex, to: toIndex)
    }
    
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
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == tableView.numberOfRows(inSection: 0) - 1{
            return IndexPath(row: proposedDestinationIndexPath.row - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}

//MARK: - UITableViewDragDelegate

extension OptionsViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = weatherData?.cities[(weatherData?.getCitiesCount())! - indexPath.row - 1]
        guard let cell = tableView.cellForRow(at: indexPath) else {return [dragItem]}
        let cellInsetContents = cell.contentView.bounds.insetBy(dx: 2.0, dy: 2.0)
        dragItem.previewProvider = {
            let dragPreviewParams = UIDragPreviewParameters()
            dragPreviewParams.visiblePath = UIBezierPath(roundedRect: cellInsetContents, cornerRadius: 8.0)
            let contentView = cell.contentView
            contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            contentView.backgroundColor = UIColor(named: "BackgroundColor")
            return UIDragPreview(view: cell.contentView, parameters: dragPreviewParams)
        }
        return [dragItem]
    }
}

//MARK: - WeatherDataDelegate

extension OptionsViewController: WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData) {
        self.tableView.reloadData()
    }
    
    func didUpdateForecast(_ weatherDataInstance: WeatherData) {
        // do nothing
    }
    
    func didUpdateCities(_ weatherDataInstance: WeatherData, action: UpdateActions) {
        if action == .add{
            self.tableView.reloadData()
        }
    }
}
