//
//  ViewController.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-06-01.
//

import UIKit

class MainViewController: UIViewController {
    
    var weatherData : WeatherData?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var goToDetailButton: UIImageView!
    @IBOutlet weak var swipeView: UIView!
    
    var dotsView: StickyDotsView?
    var contentViews : [TempContentView] = []
    
    var swipeInteractionController: SwipeInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherData?.delegate = self
        scrollView.delegate = self
        navigationController?.delegate = self
        
        setupNavBar()
        setupScrollView()
        setupDotsView()
        setupDetailButton()
        
        self.title = weatherData?.cities[0].name.uppercased()
        
        swipeInteractionController = SwipeInteractionController(fromViewController: self, toViewController: ForecastsViewController(), swipeView: swipeView)
    }
    
    private func setupScrollView(){
        let viewWidth = self.view.bounds.width
        let viewHeight = self.view.bounds.height
        let count = CGFloat(weatherData?.cities.count ?? 0)
        scrollView.contentSize = CGSize(width: viewWidth*count, height: 1.0)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        contentViews = createContentViews()
        for (index,view) in contentViews.enumerated(){
            view.frame = CGRect(x: viewWidth*CGFloat(index), y: 0, width: viewWidth, height: viewHeight)
            scrollView.addSubview(view)
        }
        scrollView.isPagingEnabled = true
        if weatherData?.isLoaded ?? false {
            updateContentViews()
        }
    }
    
    private func setupDotsView(){
        let viewWidth = self.view.bounds.width
        dotsView = StickyDotsView(frame: CGRect(x: 0, y: 0, width: 0, height: 10), attachedTo: scrollView, dotsWidth: 8, dotsColor: UIColor(named: "SecondaryTextColor")!, dotsAlpha: 1)
        dotsView!.center = CGPoint(x: viewWidth*0.5, y: 150)
        self.view.addSubview(dotsView!)
    }

    private func setupNavBar(){ 
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger_menu"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goToOptions))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.barStyle = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named:"BackgroundColor")
        appearance.titleTextAttributes = (navigationController?.navigationBar.titleTextAttributes)!
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    @objc func goToOptions(){
        self.performSegue(withIdentifier: K.optionsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.optionsSegue {
            let destination = segue.destination as! OptionsViewController
            let sender = sender as! MainViewController
            destination.weatherData = sender.weatherData
        }
        if segue.identifier == K.detailSegue {
            let destination = segue.destination as! ForecastsViewController
            let sender = sender as! MainViewController
            let pageIndex = sender.getCurrentPageIndex()
            destination.weatherData = sender.weatherData
            destination.city = sender.weatherData?.cities[pageIndex]
        }
    }
    
    private func setupDetailButton(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToDetail))
        goToDetailButton.isUserInteractionEnabled = true
        goToDetailButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func goToDetail(){
        if ((weatherData?.isLoaded) != nil){
            self.performSegue(withIdentifier: K.detailSegue, sender: self)
        }
    }
    
    private func createContentViews() -> [TempContentView] {
        var views: [TempContentView] = []
        if let cities = weatherData?.cities {
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
        return []
    }
    
    private func getCurrentPageIndex() -> Int{
        let offset = scrollView.contentOffset.x
        let pageWidth = scrollView.frame.size.width
        return Int(round(offset/pageWidth))
    }
    
    private func updateContentViews(){
        guard let cities = weatherData?.cities else {return}
        for (index, view) in contentViews.enumerated(){
            let city = cities[index]
            guard let weather = weatherData?.getCityWeather(city: city) else {return}
            view.highValue.text = String(format: "%.0f", weather.tempHigh)
            view.nowValue.text = String(format: "%.0f", weather.tempNow)
            view.lowValue.text = String(format: "%.0f", weather.tempLow)
            view.descriptionValue.text = weather.description.uppercased()
            if (getCurrentPageIndex() == index){
                self.title = city.name.uppercased()
            }
        }
    }

}


//MARK: - WeatherDataDelegate

extension MainViewController: WeatherDataDelegate{
    func didUpdateWeather(_ weatherDataInstance: WeatherData) {
        updateContentViews()
    }
    
    func didUpdateForecast(_ weatherDataInstance: WeatherData) {
        // do nothing
    }
    
    func didUpdateCities(_ weatherDataInstance: WeatherData, action: UpdateActions) {
        if action == .delete || action == .add{
            dotsView?.removeFromSuperview()
            dotsView = nil
            scrollView.removeAllSubviews()
            contentViews.removeAll()
            setupScrollView()
            setupDotsView()
        }
        
        if action == .update{
            updateContentViews()
        }
    }
}

//MARK: - ScrollViewDelegate

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        self.title = weatherData?.cities[pageIndex].name.uppercased()
    }
}

//MARK: - UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is OptionsViewController || toVC is OptionsViewController{
            if operation == .push{
                return PushSlideInLeftAnimator()
            }
            
            if operation == .pop {
                return PopSlideOutLeftAnimator()
            }
        }else{
            if operation == .push{
                return PushSlideUpAnimator(interactionController:self.swipeInteractionController)
            }
            if operation == .pop{
                return PopSlideDownAnimator()
            }
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animationController as? PushSlideUpAnimator,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress
        else{
            return nil
        }
        return interactionController
    }
}
