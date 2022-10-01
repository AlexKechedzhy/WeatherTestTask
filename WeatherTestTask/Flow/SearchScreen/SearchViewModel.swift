//
//  SearchViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit

protocol SearchViewModelInterface: TableViewAdapter {
    var reloadSearchTableViewBlock: (() -> Void)? { get set }
    var userDidSelectLocationBlock: (([Double]?, String?) -> Void)? { get set }
    func goBack()
    func getCitySearchData(searchText: String)
    func userDidPressSearchButton()
    
}

class SearchViewModel: NSObject, SearchViewModelInterface {
    
    var reloadSearchTableViewBlock: (() -> Void)?
    
    var userDidSelectLocationBlock: (([Double]?, String?) -> Void)?
    
    private var citySearchData: CitySearchModel? {
        didSet {
            reloadSearchTableViewBlock?()
        }
    }
    
    weak var coordinator: MainCoordinatorInteface?
    
    private let citySearchManager = NetworkingCitySearchManager()
    
    func goBack() {
        coordinator?.goBack()
    }
    
    func getCitySearchData(searchText: String) {
        citySearchManager.getCitySearchData(searchText: searchText) { [weak self] citySearchData, error in
            guard let error = error else {
                self?.citySearchData = citySearchData
                return
            }
            self?.citySearchData = nil
            print(error)
        }
    }
    
    func userDidPressSearchButton() {
        
    }
    
}

extension SearchViewModel {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = citySearchData?.features.count ?? 0
        return dataCount > 15 ? 15 : dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CitySearchTableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = citySearchData?.features[indexPath.row].properties.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinates = citySearchData?.features[indexPath.row].geometry.coordinates
        let locationName = citySearchData?.features[indexPath.row].properties.label
        userDidSelectLocationBlock?(coordinates, locationName)
        goBack()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.superview?.endEditing(true)
    }
    
}

