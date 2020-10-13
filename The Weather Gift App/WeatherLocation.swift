//  WeatherLocation.swift
//  The Weather Gift App WeatherLocation Structure

import Foundation

// QUESTION -- to include or not to include : Codable -- what does Codable do exactly??
//      struct we made in To Do List App has it listed, but in the challenge solution in 6.2 not included

// make this WeatherLocation struct in its own .swift file so that it has project wide scope


// change STRUCT to CLASS in 6.7

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

}
