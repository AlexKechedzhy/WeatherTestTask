//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
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
    }
    
    private func configureView() {
        view.backgroundColor = R.color.darkBlue()
        configureOrientationStackView()

        configureWeatherTopView()
        configureWeatherMainInfoView()
        configureHourlyWeatherCollectionView()
        configureDailyWeatherTableView()
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
            #warning("handle error")
            return
        }
        let longitude = coordinates[0]
        let latitude = coordinates[1]
        viewModel.getWeatherDataForCoordinates(latitude: latitude, longitude: longitude)
        locationName != nil ? weatherTopView.setTitleLabelText(locationName) : viewModel.getCityNameByCoordinates(latitude: latitude, longitude: longitude)
    }
}


