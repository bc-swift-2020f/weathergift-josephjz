//
//  WeatherDetail.swift
//  The Weather Gift App
//
//  Created by Jennifer Joseph on 10/13/20.
//

import Foundation

private let dateFormatter : DateFormatter = {
    print (" 📅 CREATED DATE FORMATTER in WeatherDetail.swift")
    let dateFormatter = DateFormatter()     // creates blank date formatter
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
} ()

struct DailyWeather {
    var dailyIcon : String
    var dailyWeekday : String
    var dailySummary : String
    var dailyHigh : Int
    var dailyLow : Int
}

class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var timezone: String
        var current: Current
        var daily : [Daily]
    }
    
    private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    
    var dailyWeatherData : [DailyWeather] = []
    
    func getData(completed: @escaping () -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        
        //let urlString = "https://pokeapi.co/api/v2/pokemon/"
        
        print("we are accessing \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Could not create this url!")
            completed()
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            do {
                //let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let result = try JSONDecoder().decode(Result.self, from: data!)
                //print("printing json: \(result)")
                //print("timezone for \(self.name) is: \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = self.fileNameForIcon(openWeatherIconValue: result.current.weather[0].icon)  // parameter is icon values and returns back file names we are going to use for weather images instead
                //print("***DAILY WEATHER ARRAY*** \(result.daily)")
                for index in 0 ..< result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(openWeatherIconValue: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("Day: \(dailyWeekday), High: \(dailyHigh), Low: \(dailyLow)")
                }
            } catch {
                print("json error: \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
        
    }
    

    // adding "private" in front of this function defintion restricts access to the fileNameForIcon() function to the WeatherDetail class only! Will not be avaiable in other files, classes, or structs
    
    private func fileNameForIcon(openWeatherIconValue : String) -> String {
        var image = ""
        
        // GET BETTER PIC CHOICES BASED ON WEATHER / TEMPERATURE
        // images that will be more accurate 
        
        switch openWeatherIconValue {
        case "01d", "01n":
            image = "sunny"
        case "02d", "02n", "03d", "03n", "04d", "04n":
            image = "cloudy"
        case "09d", "09n":
            image = "rainy"
        case "10n", "10d":
            image = "rainy"
        case "11d", "11n":
            image = "thunderstorm"
        case "13d", "13n":
            image = "snowy"
        case "50d", "50n":  // these should be pics for foggy, but I only have windy right now
            image = "windy"
        default:
            image = ""
        }
       return image
    }
    
}
