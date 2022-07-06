//
//  ViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class MainViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let cities = UserDefaults.standard.array(forKey: K.savedCitiesKey) as! [String]
    var cityWeatherMap = [String:WeatherModel]()
    
    var contentViews : [TempContentView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        scrollView.delegate = self
        navigationController?.delegate = self
        
        setupNavBar()
        setupScrollView()
        setupDotsView()
        
        self.title = cities[0].uppercased()
    }
    
    func setupScrollView(){
        let viewWidth = self.view.bounds.width
        let viewHeight = self.view.bounds.height
        scrollView.contentSize = CGSize(width: viewWidth*4, height: 1.0)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        contentViews = createContentViews()
        for (index,view) in contentViews.enumerated(){
            view.frame = CGRect(x: viewWidth*CGFloat(index), y: 0, width: viewWidth, height: viewHeight)
            scrollView.addSubview(view)
            weatherManager.fetchWeather(cityName: cities[index], index:index)
        }
        scrollView.isPagingEnabled = true
    }
    
    func setupDotsView(){
        let viewWidth = self.view.bounds.width
        let dotsView = StickyDotsView(frame: CGRect(x: 0, y: 0, width: 0, height: 10), attachedTo: scrollView, dotsWidth: 8, dotsColor: UIColor(named: "SecondaryTextColor")!, dotsAlpha: 1)
        dotsView.center = CGPoint(x: viewWidth*0.5, y: 150)
        self.view.addSubview(dotsView)
    }

    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToOptions))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func goToOptions(){
        self.performSegue(withIdentifier: K.optionsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.optionsSegue {
            let destination = segue.destination as! OptionsViewController
            let sender = sender as! MainViewController
            destination.cityWeatherMap = sender.cityWeatherMap
        }
    }
    
    func createContentViews() -> [TempContentView] {
        var views: [TempContentView] = []
        for _ in cities{
            let contentView = TempContentView()
            contentView.highValue.text = "--"
            contentView.nowValue.text = "--"
            contentView.lowValue.text = "--"
            contentView.descriptionValue.text = "--"
            views.append(contentView)
        }
        return views
    }

}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, index:Int) {
        let view = contentViews[index]
        let city = cities[index]
        cityWeatherMap[city] = weather
        DispatchQueue.main.async {
            view.highValue.text = String(format: "%.0f", weather.tempHigh)
            view.nowValue.text = String(format: "%.0f", weather.tempNow)
            view.lowValue.text = String(format: "%.0f", weather.tempNow)
            view.descriptionValue.text = weather.description.uppercased()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - ScrollViewDelegate

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        self.title = cities[pageIndex].uppercased()
    }
}

//MARK: - UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push{
            return FadePushAnimator()
        }
        
        if operation == .pop {
            return PopFadeAnimator()
        }
        
        return nil
    }
}
