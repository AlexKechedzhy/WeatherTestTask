//
//  NetworkingCitySearchManager.swift
//  WeatherTestTask
//
//  Created by Alex173 on 30.09.2022.
//

import Foundation
import Alamofire

class NetworkingCitySearchManager {
    
    private let apiKey = "32514940-c245-11ec-ad6a-3fa3ee009ece"
    private let baseURL = "https://app.geocodeapi.io/api/v1/autocomplete?"
    private let andApiKey = "apikey="
    private let andText = "&text="
    private let andSize = "&size=10#"
    
   
    private func getCitySearchURL(searchText: String) -> URL? {
        guard let urlSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        return URL(string: baseURL + andApiKey + apiKey + andText + urlSearchText + andSize)
    }
    
    public func getCitySearchData(searchText: String, completion: @escaping (CitySearchModel?, Error?) -> ()) {
        guard let url = getCitySearchURL(searchText: searchText) else {
            let error = NSError(domain: "Failed to get url", code: 404)
            completion(nil, error)
            return
        }
        print(url)
        AF.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        let result = try jsonDecoder.decode(CitySearchModel.self, from: data)
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
