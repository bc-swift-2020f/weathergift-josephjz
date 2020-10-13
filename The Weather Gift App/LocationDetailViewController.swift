//
//  LocationDetailViewController.swift
//  The Weather Gift App
//
//  Created by Jennifer Joseph on 10/12/20.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    
    // this is an implicitly unwrapped optional
    var weatherLocation : WeatherLocation!
    
    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check to see if we have any values in weatherLocation
        // if nil -- set to empty value
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            weatherLocations.append(weatherLocation)
        }
        
        updateUserInterface()
    }
    
    func updateUserInterface() {
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        temperatureLabel.text = "--°"
        summaryLabel.text = ""
    
        
    }
    
    
    
    // to pass weatherLocations to LocationListViewController
    // --> pass back selectedLocationIndex
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.weatherLocations = weatherLocations
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        weatherLocations = source.weatherLocations
        weatherLocation = weatherLocations[source.selectedLocationIndex]
        updateUserInterface()
    }
}
