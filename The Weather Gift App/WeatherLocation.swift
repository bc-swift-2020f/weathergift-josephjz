//  WeatherLocation.swift
//  The Weather Gift App WeatherLocation Structure

import Foundation

// QUESTION -- to include or not to include : Codable -- what does Codable do exactly??
//      struct we made in To Do List App has it listed, but in the challenge solution in 6.2 not included

// make this WeatherLocation struct in its own .swift file so that it has project wide scope
struct WeatherLocation {
    var name: String
    var latitude: Double
    var longitude: Double
}
