//
//  SearchViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-08-02.
//

import UIKit
import MapKit

class SearchViewController : UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var dismiss: UIImageView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var selectedCity: City?
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchBar.delegate = self
        searchResultsTable.dataSource = self
        searchResultsTable.delegate = self
        
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        
        setupSearchBar()
        setupDismissButton()
    }
    
    private func setupSearchBar(){
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in searchBar.subviews {
            for subview in view.subviews{
                if subview.isKind(of: UISearchBarBackground){
                    subview.alpha = 0
                }
            }
        }
        
        guard let UISearchBarTextFieldLabel: AnyClass = NSClassFromString("UISearchBarTextFieldLabel") else {return}
        for subview in searchBar.searchTextField.subviews{
            if subview.isKind(of: UISearchBarTextFieldLabel){
                (subview as! UILabel).textColor = UIColor(named: "SearchBarLeftViewTint")
            }
        }
        
        searchBar.searchTextField.backgroundColor = UIColor(named: "SearchBarTextFieldBackground")
        searchBar.searchTextField.leftView?.tintColor = UIColor(named: "SearchBarLeftViewTint")
    }
    
    private func goToDetail(){
        self.performSegue(withIdentifier: K.searchDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.searchDetailSegue{
            let destination = segue.destination as! SearchDetailViewController
            let sender = sender as! SearchViewController
            destination.city = sender.selectedCity
            destination.weatherData = sender.weatherData
        }
    }
    
    private func setupDismissButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        dismiss.isUserInteractionEnabled = true
        dismiss.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(named: "SearchBarTextFieldBackground")
        cell.selectedBackgroundView = selectedBg
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {return}
            guard let name = response?.mapItems[0].name else {return}
            DispatchQueue.main.async {
                self.selectedCity = City(id: 0, name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.goToDetail()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultsTable.reloadData()
        }else{
            searchCompleter.queryFragment = searchText
        }
    }
}

//MARK: - MKLocalSearchCompleterDelegate

extension SearchViewController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
