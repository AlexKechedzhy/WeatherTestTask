//
//  CitySearchModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 30.09.2022.
//

import Foundation

struct CitySearchModel: Decodable {
    let features: [Features]
    
    struct Features: Decodable {
        let properties: Properties
        let geometry: Geometry
    }

    struct Properties: Decodable {
        let name: String?
        let country: String?
        let label: String?
    }

    struct Geometry: Decodable {
        let coordinates: [Double]
    }


}

