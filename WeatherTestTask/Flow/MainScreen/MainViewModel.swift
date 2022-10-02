//
//  MainViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import Foundation
import UIKit
import CoreLocation

typealias TableViewAdapter = UITableViewDelegate & UITableViewDataSource
typealias CollectionViewAdapter = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

protocol MainViewModelInterface: TableViewAdapter, CollectionViewAdapter {
    var reloadHourlyCollectionViewBlock: (() -> Void)? { get set }
    var reloadDailyTableViewBlock: (() -> Void)? { get set }
    var updateCityNameBlock: ((String?) -> Void)? { get set }
    var updateDateLabelBlock: ((String?) -> Void)? { get set }
    var updateCurrentWeatherImageBlock: ((UIImage?) -> Void)? { get set }
    var updateTemperatureDetailViewBlock: ((String?) -> Void)? { get set }
    var updateHumidityDetailViewBlock: ((String?) -> Void)? { get set }
    var updateWindDetailViewBlock: ((String?, UIImage?) -> Void)? { get set }
    func getWeatherDataForCoordinates(latitude: Double, longitude: Double)
    func getCityNameByCoordinates(latitude: Double, longitude: Double)
    func showMapScreen(delegate: MapViewControllerDelegate)
    func showSearchScreen(delegate: SearchViewControllerDelegate)
    func requestCurrentLocation()
}

class MainViewModel: NSObject, MainViewModelInterface {
    
    var reloadHourlyCollectionViewBlock: (() -> Void)?
    var reloadDailyTableViewBlock: (() -> Void)?
    var updateCityNameBlock: ((String?) -> Void)?
    var updateDateLabelBlock: ((String?) -> Void)?
    var updateCurrentWeatherImageBlock: ((UIImage?) -> Void)?
    var updateTemperatureDetailViewBlock: ((String?) -> Void)?
    var updateHumidityDetailViewBlock: ((String?) -> Void)?
    var updateWindDetailViewBlock: ((String?, UIImage?) -> Void)?
    
    private let locationManager = CLLocationManager()
    
    weak var coordinator: MainCoordinatorInteface?
    
    private var weatherDataModel: WeatherDataModel? {
        didSet {
            refreshUI()
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func showMapScreen(delegate: MapViewControllerDelegate) {
        coordinator?.showMapScreen(delegate: delegate)
    }
    
    func showSearchScreen(delegate: SearchViewControllerDelegate) {
        coordinator?.showSearchScreen(delegate: delegate)
    }
    
    func requestCurrentLocation() {
        locationManager.requestLocation()
    }
    
    private func refreshUI() {
        updateSelectedWeatherView(data: weatherDataModel?.daily.first)
        reloadHourlyCollectionViewBlock?()
        reloadDailyTableViewBlock?()
    }
    
    #warning("consider renaming this View")
    private func updateSelectedWeatherView(data: WeatherDataModel.Daily?) {
        guard let dailyData = data else {
            return
        }
        updateDateLabel(data: dailyData)
        updateCurrentWeatherImageView(data: dailyData)
        updateTemperatureDetailView(data: dailyData)
        updateHumidityDetailView(data: dailyData)
        updateWindDetailView(data: dailyData)
    }
    
    private func updateDateLabel(data: WeatherDataModel.Daily?) {
        let currentDate = convertToDateString(dateInt: data?.dt, dateFormat: "E, dd MMMM")
        updateDateLabelBlock?(currentDate)
    }
    
    private func updateCurrentWeatherImageView(data: WeatherDataModel.Daily?) {
        let conditionId = data?.weather.first?.id ?? 0
        let weatherImage = WeatherImageManager.instance.getWeatherImage(conditionId: conditionId)?.withRenderingMode(.alwaysTemplate)
        updateCurrentWeatherImageBlock?(weatherImage)
    }
    
    private func updateTemperatureDetailView(data: WeatherDataModel.Daily?) {
        let maxTemperature = convertDoubleToTemperatureString(temperature: data?.temp.max ?? 0)
        let minTemperature = convertDoubleToTemperatureString(temperature: data?.temp.min ?? 0)
        updateTemperatureDetailViewBlock?(maxTemperature + " / " + minTemperature)
    }
    
    private func updateHumidityDetailView(data: WeatherDataModel.Daily?) {
        let humidity = data?.humidity ?? 0
        let humidityString = String(humidity) + "%"
        updateHumidityDetailViewBlock?(humidityString)
    }
    
    private func updateWindDetailView(data: WeatherDataModel.Daily?) {
        let windSpeed = data?.wind_speed ?? 0
        let windDirection = data?.wind_deg ?? 0
        let windSpeedString = String(Int(windSpeed)) + "m/s"
        let windDirectionImage = WeatherImageManager.instance.getWindDirectionImage(windDirection: windDirection)?.withRenderingMode(.alwaysTemplate)
        updateWindDetailViewBlock?(windSpeedString, windDirectionImage)
    }
    
    private func convertToDateString(dateInt: Int?, dateFormat: String) -> String? {
        guard let dateInt = dateInt else {
            return nil
        }
        let date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    private func convertDoubleToTemperatureString(temperature: Double) -> String {
        String(Int(temperature)) + "°"
    }
    
    func getWeatherDataForCoordinates(latitude: Double, longitude: Double) {
        #warning("rework using instance")
        NetworkingWeatherManager().getWeatherData(latitude: latitude, longitude: longitude) {
            weatherData, error in
            guard let error = error else {
                self.weatherDataModel = weatherData
                return
            }
            print(error)
        }
    }
    
    func getCityNameByCoordinates(latitude: Double, longitude: Double) {
        #warning("rework using instance")
        GeocodingManager().convertCoordinatesToCityName(lat: latitude, lon: longitude) { [weak self] cityName, error in
            guard let error = error else {
                self?.updateCityNameBlock?(cityName)
                return
            }
            print(error)
        }
    }
    
}

extension MainViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        locationManager.stopUpdatingLocation()
        let currentLatitude = location.coordinate.latitude as Double
        let currentLongitude = location.coordinate.longitude as Double
        getWeatherDataForCoordinates(latitude: currentLatitude, longitude: currentLongitude)
        getCityNameByCoordinates(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .denied, .restricted:
            print("denied, restricted \(error)")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorizedAlways, authorizedWhenInUse \(error)")
        @unknown default:
            break
        }
    }
    
 
}

//MARK: - UICollectionView Delegate & DataSource methods
extension MainViewModel {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        #warning("move to constant")
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(HourlyWeatherCollectionViewCell.self, indexPath: indexPath)
        let hourlyModelCount = weatherDataModel?.hourly.count ?? 0
        guard hourlyModelCount >= 24 else {
            return cell
        }
        guard let cellModel = weatherDataModel?.hourly[indexPath.row] else {
            return cell
        }
        let hours = convertToDateString(dateInt: cellModel.dt, dateFormat: "HH")
        let weatherImage = WeatherImageManager.instance.getWeatherImage(conditionId: cellModel.weather.first?.id ?? 0)?.withRenderingMode(.alwaysTemplate)
        let temperature = convertDoubleToTemperatureString(temperature: cellModel.temp)
        cell.set(hours: hours,
                 weatherImage: weatherImage,
                 temperature: temperature)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: 80, height: height)
    }
    
}

//MARK: - UITableView Delegate & DataSource methods
extension MainViewModel {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DailyWeatherTableViewCell.self, indexPath: indexPath)
        let dailyModelCount = weatherDataModel?.daily.count ?? 0
        guard dailyModelCount >= 7 else {
            return cell
        }
        guard let cellModel = weatherDataModel?.daily[indexPath.row] else {
            return cell
        }
        let dayLabelText = convertToDateString(dateInt: cellModel.dt, dateFormat: "E")?.uppercased()
        let temperatureText = convertDoubleToTemperatureString(temperature: cellModel.temp.max) + " / " + convertDoubleToTemperatureString(temperature: cellModel.temp.min)
        
        let weatherImage = WeatherImageManager.instance.getWeatherImage(conditionId: cellModel.weather.first?.id ?? 0)?.withRenderingMode(.alwaysTemplate)
        cell.set(dayLabelText: dayLabelText,
                 temperatureLabelText: temperatureText,
                 weatherImage: weatherImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellModel = weatherDataModel?.daily[indexPath.row] else {
            #warning("error handling?")
            return
        }
        updateSelectedWeatherView(data: cellModel)
    }
    
}


