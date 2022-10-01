//
//  WeatherDataModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation

struct WeatherDataModel: Decodable {
    let current: Current
    let hourly: [Hourly]
    var daily: [Daily]
    
    struct Current: Decodable {
        let dt: Int
        let temp: Double
        let wind_speed: Double
        let wind_deg: Int
        let weather: [Weather]
    }

    struct Hourly: Decodable {
        let dt: Int
        let temp: Double
        let humidity: Int
        let weather: [Weather]
    }

    struct Daily: Decodable {
        let dt: Int
        let temp: Temp
        let humidity: Int
        let weather: [Weather]
        var isSelected: Bool? = false
    }

    struct Temp: Decodable {
        let min: Double
        let max: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

}
