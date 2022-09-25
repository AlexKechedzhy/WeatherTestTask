//
//  GeocodingManager.swift
//  WeatherTestTask
//
//  Created by Alex173 on 24.09.2022.
//

import Foundation
import CoreLocation

class GeocodingManager {
    
    func convertCoordinatesToCityName(lat: Double, lon: Double, completion: @escaping (String?, Error?) -> ()) {
        let location = CLLocation(latitude: lat, longitude: lon)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemarks = placemarks else {
                completion(nil, error)
                return
            }
            guard let name = placemarks.first?.locality else {
                completion(nil, error)
                return
            }
            completion(name, nil)
        }
    }
    
}
