//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit
import NVActivityIndicatorView

class MainViewController: UIViewController {
    
    private let loadingIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero)
        view.type = .ballRotateChase
        view.color = R.color.white() ?? UIColor.white
        view.isHidden = true
        return view
    }()
    
    private let loadingTitle: UILabel = {
        let label = UILabel()
        label.text = "Loading weather..."
        label.textAlignment = .center
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    private let viewForMainInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let viewForDailyInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let orientationStackView: UIStackView = {
        let stackView = UIStackView()
        let isLandscape = UIDevice.current.orientation.isLandscape
        stackView.axis = isLandscape ? .horizontal : .vertical
        stackView.alignment = .fill
        stackView.distribution =  isLandscape ? .fillEqually : .fill
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var weatherTopView = WeatherTopView(delegate: self)
    
    private lazy var weatherMainInfoView = WeatherMainInfoView()
    
    private lazy var hourlyWeatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.register(HourlyWeatherCollectionViewCell.self)
        collectionView.backgroundColor = R.color.lightBlue()
        return collectionView
    }()
    
    private lazy var dailyWeatherTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(DailyWeatherTableViewCell.self)
        tableView.backgroundColor = R.color.white()
        tableView.separatorStyle = .none
        return tableView
    }()

    private var viewModel: MainViewModelInterface
    
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        viewModel.requestCurrentLocation()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let isLandscape = UIDevice.current.orientation.isLandscape
        orientationStackView.axis = isLandscape ? .horizontal : .vertical
        orientationStackView.distribution =  isLandscape ? .fillEqually : .fill
    }
    
    private func configureViewModel() {
        viewModel.reloadHourlyCollectionViewBlock = { [weak self] in
            self?.hourlyWeatherCollectionView.reloadData()
        }
        viewModel.reloadDailyTableViewBlock = { [weak self] in
            self?.dailyWeatherTableView.reloadData()
        }
        viewModel.hideMainUIBlock = { [weak self] in
            self?.showLoading()
        }
        viewModel.showMainUIBlock = { [weak self] in
            self?.hideLoading()
        }
        viewModel.updateCityNameBlock = { [weak self] locationName in
            self?.weatherTopView.setTitleLabelText(locationName)
        }
        viewModel.updateDateLabelBlock = { [weak self] date in
            self?.weatherTopView.setDateLabelText(date)
        }
        viewModel.updateMainWeatherImageBlock = { [weak self] weatherImage in
            self?.weatherMainInfoView.setMainImage(weatherImage)
        }
        viewModel.updateTemperatureDetailViewBlock = { [weak self] labelText in
            self?.weatherMainInfoView.setTemperatureInfo(text: labelText)
        }
        viewModel.updateHumidityDetailViewBlock = { [weak self] labelText in
            self?.weatherMainInfoView.setHumidityInfo(text: labelText)
        }
        viewModel.updateWindDetailViewBlock = { [weak self] labelText, directionImage in
            self?.weatherMainInfoView.setWindInfo(text: labelText, secondaryImage: directionImage)
        }
        viewModel.dailyDataAlertBlock = { [weak self]  in
            let title = "Failed to get data"
            let message = "Failed to get weather data for this day."
            self?.showAlert(title: title, message: message, buttonTitle: "OK")
        }
        viewModel.locationAccessAlertBlock = { [weak self] in
            let title = "Location access denied"
            let message = "In order for app to get weather for your location, go to Settings -> Privacy -> Location Services -> WeatherTestTask and select 'While Using the App'"
            self?.showAlert(title: title, message: message, buttonTitle: "Go to Settings", actionHandler: { _ in
                self?.viewModel.openSettings()
            })
        }
        viewModel.locationErrorAlertBlock = { [weak self] in
            let title = "Failed to get your location"
            let message = "You can still use the app, but withour your location"
            let buttonTitle = "Use without location"
            self?.showAlert(title: title, message: message, buttonTitle: buttonTitle, actionHandler: { _ in
                self?.hideLoading()
            })
        }
        viewModel.failedToGetCityNameBlock = { [weak self] in
            let title = "Failed to get city name"
            let message = "Unable to get city name of chosen location."
            let buttonTitle = "OK"
            self?.showAlert(title: title, message: message, buttonTitle: buttonTitle)
        }
        viewModel.failedToGetWeatherBlock = { [weak self] in
            let title = "Failed to get weather"
            let message = "Unable to get weather for this location. You can try getting weather for your location or select another one via Search or Map."
            let retryAction = UIAlertAction(title: "My location", style: .default) { _ in
                self?.viewModel.requestCurrentLocation()
            }
            let okAction = UIAlertAction(title: "Select location", style: .default)
            self?.showMultipleOptionsAlert(with: title, and: message, alertActions: [retryAction, okAction])
        }
    }
    
    private func showLoading() {
        orientationStackView.isHidden = true
        loadingIndicator.isHidden = false
        loadingTitle.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        orientationStackView.isHidden = false
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        loadingTitle.isHidden = true
    }
    
    private func configureView() {
        view.backgroundColor = R.color.darkBlue()
        configureWeatherTopView()
        configureWeatherMainInfoView()
        configureHourlyWeatherCollectionView()
        configureDailyWeatherTableView()
        configureOrientationStackView()
        configureLoadingIndicator()
        configureLoadingLabel()
    }

    private func configureWeatherTopView() {
        viewForMainInfo.addSubview(weatherTopView)
        weatherTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    private func configureWeatherMainInfoView() {
        viewForMainInfo.addSubview(weatherMainInfoView)
        weatherMainInfoView.snp.makeConstraints {
            $0.top.equalTo(weatherTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureHourlyWeatherCollectionView() {
        viewForMainInfo.addSubview(hourlyWeatherCollectionView)
        hourlyWeatherCollectionView.snp.makeConstraints {
            $0.top.equalTo(weatherMainInfoView.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(156)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureDailyWeatherTableView() {
        viewForDailyInfo.addSubview(dailyWeatherTableView)
        dailyWeatherTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureOrientationStackView() {
        orientationStackView.addArrangedSubview(viewForMainInfo)
        orientationStackView.addArrangedSubview(viewForDailyInfo)
        view.addSubview(orientationStackView)
        orientationStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(-32)
            $0.height.width.equalTo(100)
        }
    }
    
    private func configureLoadingLabel() {
        view.addSubview(loadingTitle)
        loadingTitle.snp.makeConstraints {
            $0.top.equalTo(loadingIndicator.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

}

extension MainViewController: WeatherTopViewDelegate {
    func mapButtonPressed() {
        viewModel.showMapScreen(delegate: self)
    }
    
    func searchButtonPressed() {
        viewModel.showSearchScreen(delegate: self)
    }
}

extension MainViewController: MapViewControllerDelegate {
    func userDidChooseCoordinates(latitude: Double, longitude: Double) {
        viewModel.getWeatherDataForCoordinates(latitude: latitude, longitude: longitude)
        viewModel.getCityNameByCoordinates(latitude: latitude, longitude: longitude)
    }
}

extension MainViewController: SearchViewControllerDelegate {
    func userDidSelectLocation(coordinates: [Double]?, locationName: String?) {
        guard let coordinates = coordinates else {
            showAlert(title: "Failed to get location coordinates",
                      message: "Please try again one more time or select another location.",
                      buttonTitle: "OK")
            return
        }
        let longitude = coordinates[0]
        let latitude = coordinates[1]
        viewModel.getWeatherDataForCoordinates(latitude: latitude, longitude: longitude)
        locationName != nil ? weatherTopView.setTitleLabelText(locationName) : viewModel.getCityNameByCoordinates(latitude: latitude, longitude: longitude)
    }
}


