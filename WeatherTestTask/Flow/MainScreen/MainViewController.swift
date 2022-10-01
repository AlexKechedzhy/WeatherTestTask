//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var mapButton: IconButton = {
        let button = IconButton(icon: R.image.icon_my_location(), size: 32)
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: IconButton = {
        let button = IconButton(icon: R.image.icon_search(), size: 32)
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let image = R.image.icon_place()?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = R.color.white()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var currentWeatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.white()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private let temperatureDetailView = WeatherDetailView(primaryImage: R.image.icon_temp())
    private let humidityDetailView = WeatherDetailView(primaryImage: R.image.icon_humidity())
    private let windDetailView = WeatherDetailView(primaryImage: R.image.icon_wind())
    
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
    
    private func configureViewModel() {
        viewModel.reloadHourlyCollectionViewBlock = { [weak self] in
            self?.hourlyWeatherCollectionView.reloadData()
        }
        viewModel.reloadDailyTableViewBlock = { [weak self] in
            self?.dailyWeatherTableView.reloadData()
        }
        viewModel.updateCityNameBlock = { [weak self] locationName in
            self?.setLocationTitleLabelText(text: locationName)
        }
        viewModel.updateDateLabelBlock = { [weak self] date in
            self?.dateLabel.text = date
        }
        viewModel.updateCurrentWeatherImageBlock = { [weak self] weatherImage in
            self?.currentWeatherImageView.image = weatherImage
        }
        viewModel.updateTemperatureDetailViewBlock = { [weak self] labelText in
            self?.temperatureDetailView.setInfo(labelText: labelText)
        }
        viewModel.updateHumidityDetailViewBlock = { [weak self] labelText in
            self?.humidityDetailView.setInfo(labelText: labelText)
        }
        viewModel.updateWindDetailViewBlock = { [weak self] labelText, directionImage in
            self?.windDetailView.setInfo(labelText: labelText, secondaryImage: directionImage)
        }
    }
    
    private func configureView() {
        view.backgroundColor = R.color.darkBlue()
        configureMapButton()
        configureSearchButton()
        configureLocationIconImageView()
        configureLocationTitleLabel()
        configureDateLabel()
        configureCurrentWeatherImageView()
        configureHourlyWeatherCollectionView()
        configureDetailStackView()
        configureDailyWeatherTableView()
    }

    private func configureMapButton() {
        view.addSubview(mapButton)
        mapButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.top)
            $0.trailing.equalTo(mapButton.snp.leading).inset(-16)
        }
    }
    
    private func configureLocationIconImageView() {
        view.addSubview(locationIconImageView)
        locationIconImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.width.height.equalTo(24)
        }
    }
    
    private func configureLocationTitleLabel() {
        view.addSubview(locationTitleLabel)
        locationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIconImageView)
            $0.leading.equalTo(locationIconImageView.snp.trailing).inset(-8)
            $0.trailing.equalTo(searchButton.snp.leading).inset(-8)
        }
    }
    
    private func configureDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(locationIconImageView.snp.bottom).inset(-16)
            $0.leading.equalTo(locationIconImageView)
        }
    }
    
    private func configureCurrentWeatherImageView() {
        view.addSubview(currentWeatherImageView)
        currentWeatherImageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-8)
            $0.width.height.equalTo(164)
            $0.leading.equalToSuperview().inset(32)
        }
    }
    
    private func configureDetailStackView() {
        view.addSubview(detailStackView)
        detailStackView.addArrangedSubview(temperatureDetailView)
        detailStackView.addArrangedSubview(humidityDetailView)
        detailStackView.addArrangedSubview(windDetailView)
        detailStackView.snp.makeConstraints {
            $0.leading.equalTo(currentWeatherImageView.snp.trailing).inset(-32)
            $0.trailing.equalToSuperview().inset(32)
            $0.centerY.equalTo(currentWeatherImageView)
            $0.height.equalTo(100)
        }
    }

    
    private func configureHourlyWeatherCollectionView() {
        view.addSubview(hourlyWeatherCollectionView)
        hourlyWeatherCollectionView.snp.makeConstraints {
            $0.top.equalTo(currentWeatherImageView.snp.bottom).inset(-40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.height.equalTo(156)
        }
    }
    
    private func configureDailyWeatherTableView() {
        view.addSubview(dailyWeatherTableView)
        dailyWeatherTableView.snp.makeConstraints {
            $0.top.equalTo(hourlyWeatherCollectionView.snp.bottom)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }


    @objc private func mapButtonPressed() {
        viewModel.showMapScreen(delegate: self)
    }
    
    @objc private func searchButtonPressed() {
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
        locationName != nil ? setLocationTitleLabelText(text: locationName) : viewModel.getCityNameByCoordinates(latitude: latitude, longitude: longitude)
    }
    
    private func setLocationTitleLabelText(text: String?) {
        locationTitleLabel.text = text
    }
}


