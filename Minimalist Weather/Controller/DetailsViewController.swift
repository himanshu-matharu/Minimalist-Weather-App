//
//  DetailsViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-06.
//

import UIKit

class DetailsViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var temperature: String = "--"
    var descriptionValue: String = "--"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.dataSource = self
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

extension DetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.forecastCellIdentifier, for: indexPath) as! ForecastCell
        cell.timeLabel.text = "Now".uppercased()
        cell.tempValue.text = temperature
        cell.descriptionLabel.text = descriptionValue.uppercased()
        return cell
    }
    
    
}
