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
    //    @IBOutlet weak var highTempLabel: UILabel!
//    @IBOutlet weak var nowTempLabel: UILabel!
//    @IBOutlet weak var lowTempLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
//
//    @IBOutlet weak var highLabel: UILabel!
//    @IBOutlet weak var nowLabel: UILabel!
//    @IBOutlet weak var lowLabel: UILabel!
    
    let cities = [
    "Frankfurt",
    "Paris",
    "Budapest",
    "London"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        weatherManager.delegate = self
        scrollView.delegate = self
        navigationController?.delegate = self
                
        let viewWidth = self.view.bounds.width
        let viewHeight = self.view.bounds.height
        scrollView.contentSize = CGSize(width: viewWidth*4, height: 1.0)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        for (index,city) in cities.enumerated(){
            let contentView = TempContentView(frame: CGRect(x: viewWidth*CGFloat(index), y: 0, width: viewWidth, height: viewHeight))
//            let contentView = TempContentView()
            contentView.highValue.text = "--"
            contentView.nowValue.text = "--"
            contentView.lowValue.text = "--"
            contentView.descriptionValue.text = "--"
            scrollView.addSubview(contentView)
            weatherManager.fetchWeather(cityName: city, view: contentView)
        }
        
        scrollView.isPagingEnabled = true
        let dotsView = StickyDotsView(frame: CGRect(x: 0, y: 0, width: 0, height: 10), attachedTo: scrollView, dotsWidth: 8, dotsColor: UIColor(named: "SecondaryTextColor")!, dotsAlpha: 1)
        dotsView.center = CGPoint(x: viewWidth*0.5, y: 150)
        self.view.addSubview(dotsView)
        
//        highLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        lowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        nowLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        navigationController?.navigationBar.barStyle = .black
         
        self.title = cities[0].uppercased()
//        weatherManager.fetchWeather(cityName: cities[0])
    }

    func setupNavBar(){
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToOptions))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func goToOptions(){
        self.performSegue(withIdentifier: K.optionsSegue, sender: self)
//        let nav = self.navigationController
//        DispatchQueue.main.async {
//            nav?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)
//            nav?.pushViewController(OptionsViewController(), animated: false)
//        }
    }

}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, view: TempContentView) {
        DispatchQueue.main.async {
            view.highValue.text = String(format: "%.0f", weather.tempHigh)
            view.nowValue.text = String(format: "%.0f", weather.tempNow)
            view.lowValue.text = String(format: "%.0f", weather.tempNow)
            view.descriptionValue.text = weather.description.uppercased()
//            self.title = weather.cityName.uppercased()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - ScrollViewDelegate

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.title = cities[position].uppercased()
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
