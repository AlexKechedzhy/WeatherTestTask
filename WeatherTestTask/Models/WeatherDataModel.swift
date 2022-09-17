//
//  WeatherDataModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation

struct WeatherDataModel: Codable {
    let current: Current
    let hourly: [Hourly]
    var daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    var isSelected: Bool? = false
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
