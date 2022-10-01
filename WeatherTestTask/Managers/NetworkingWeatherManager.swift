//
//  NetworkingWeatherManager.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation
import Alamofire

class NetworkingWeatherManager {
    
    private let appID = "144ae1233d3463be4dc6dd11edb813c8"
    private let weatherbaseURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=alerts,minutely&units=metric"
    private let andLat = "&lat="
    private let andLon = "&lon="
    private let andAppID = "&appid="
    private let doubleFormat = "%.3f"
    private let geocoderAPIKey = "32514940-c245-11ec-ad6a-3fa3ee009ece"
    private let geocoderBaseURL = "https://app.geocodeapi.io/api/v1/autocomplete?"
    private let andApiKey = "apikey="
    private let andText = "&text="
    private let andSize = "&size=10#"
    
    private func getWeatherStringURL(latitude: Double, longitude: Double) -> String {
        return weatherbaseURL + andLat + String(format: doubleFormat, latitude) + andLon + String(format: doubleFormat, longitude) + andAppID + appID
    }
    
    private func getGeocoderStringURL(searchedText: String) -> String {
        return geocoderBaseURL + andApiKey + geocoderAPIKey + andText + searchedText + andSize
    }
    
    public func getWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherDataModel?, Error?) -> ()) {
        let url = getWeatherStringURL(latitude: latitude, longitude: longitude) 
        print(url)
        AF.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        let result = try jsonDecoder.decode(WeatherDataModel.self, from: data)
                        completion(result, nil)
                    }
                    catch let error{
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    
    
}
