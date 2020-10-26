//
//  LocationDetailViewController.swift
//  The Weather Gift App
//
//  Created by Jennifer Joseph on 10/12/20.
//

import UIKit

// don't forget to add () at the end to configure this enclosure
private let dateFormatter : DateFormatter = {
    print (" 📅 CREATED DATE FORMATTER")
    let dateFormatter = DateFormatter()     // creates blank date formatter
    dateFormatter.dateFormat = "EEEE, MMM d, y, h:mm aaa"
    return dateFormatter
} ()

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // this is an implicitly unwrapped optional
    var weatherDetail : WeatherDetail!
    
    var locationIndex = 0 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check to see if we have any values in weatherLocation
        // if nil -- set to empty value
//        if weatherLocation == nil {
//            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
//            weatherLocations.append(weatherLocation)
//        }
        updateUserInterface()
    }
    
    
    func updateUserInterface() {
        
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        
        weatherDetail.getData {
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
                let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                self.dateLabel.text = dateFormatter.string(from: usableDate)
                self.placeLabel.text = self.weatherDetail.name
                self.temperatureLabel.text = "\(self.weatherDetail.temperature)°"
                self.summaryLabel.text = self.weatherDetail.summary
                self.imageView.image = UIImage(named: self.weatherDetail.dailyIcon)
            }
        }
    }
    
    
    
    // to pass weatherLocations to LocationListViewController
    // --> pass back selectedLocationIndex
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        destination.weatherLocations = pageViewController.weatherLocations
        
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        locationIndex = source.selectedLocationIndex
        
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        

        var direction: UIPageViewController.NavigationDirection = .forward
        
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
        
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
        
    }
    
}

