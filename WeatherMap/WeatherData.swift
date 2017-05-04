//
//  WeatherData.swift
//  WeatherMap
//
//  Created by Gary Wagner on 5/4/17.
//  Copyright © 2017 Gary Wagner. All rights reserved.
//

import Foundation

struct WeatherData {
    
    fileprivate struct Keys {
        static let code = "cod"
        static let icon = "icon"
        static let main = "main"
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let temperature = "temp"
        static let name = "name"
        static let weather = "weather"
        static let description = "description"
        static let wind = "wind"
        static let degrees = "deg"
        static let gust = "gust"
        static let speed = "speed"
    }
    
    let code: Int64
    let name: String
    let icon: String
    let description: String
    let temperature: Double
    let humidity: Int64
    let pressure: Int64
    let degrees: Int64
    let gust: Double
    let speed: Double
    
    init?(dictionary: [String: Any]?) {
        
        guard let dictionary = dictionary else {
            return nil
        }
        
        self.code = dictionary[Keys.code] as? Int64 ?? 0
        self.name = dictionary[Keys.name] as? String ?? ""
       if let mainDict = dictionary[Keys.main] as? [String: Any] {
            self.humidity = mainDict[Keys.humidity] as? Int64 ?? 0
            self.pressure = mainDict[Keys.pressure] as? Int64 ?? 0
            self.temperature = mainDict[Keys.temperature] as? Double ?? 0
        }
        else {
            self.humidity = 0
            self.pressure = 0
            self.temperature = 0
        }
       if let weatherArray = dictionary[Keys.weather] as? [Any], let weatherDict = weatherArray.first as? [String: Any] {
            self.description = weatherDict[Keys.description] as? String ?? ""
            self.icon = weatherDict[Keys.icon] as? String ?? ""
       }
        else {
            self.description = ""
            self.icon = ""
        }
        if let windDict = dictionary[Keys.wind] as? [String: Any] {
            self.degrees = windDict[Keys.degrees] as? Int64 ?? 0
            self.gust = windDict[Keys.gust] as? Double ?? 0
            self.speed = windDict[Keys.speed] as? Double ?? 0
        }
        else {
            self.degrees = 0
            self.gust = 0
            self.speed = 0
        }
    }
    
}

