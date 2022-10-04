//
//  WeatherMainInfoView.swift
//  WeatherTestTask
//
//  Created by Alex173 on 03.10.2022.
//

import UIKit

class WeatherMainInfoView: UIView {
    
    private lazy var mainWeatherImageView: UIImageView = {
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
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        configureMainWeatherImageView()
        configureDetailStackView()
    }
    
    private func configureMainWeatherImageView() {
        addSubview(mainWeatherImageView)
        mainWeatherImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.width.height.equalTo(164)
            $0.leading.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configureDetailStackView() {
        addSubview(detailStackView)
        detailStackView.addArrangedSubview(temperatureDetailView)
        detailStackView.addArrangedSubview(humidityDetailView)
        detailStackView.addArrangedSubview(windDetailView)
        detailStackView.snp.makeConstraints {
            $0.leading.equalTo(mainWeatherImageView.snp.trailing).inset(-32)
            $0.trailing.equalToSuperview().inset(32)
            $0.centerY.equalTo(mainWeatherImageView)
            $0.height.equalTo(100)
        }
    }
    
    public func setMainImage(_ image: UIImage?) {
        mainWeatherImageView.image = image
    }
    
    public func setTemperatureInfo(text: String?) {
        temperatureDetailView.setInfo(labelText: text)
    }
    
    public func setHumidityInfo(text: String?) {
        humidityDetailView.setInfo(labelText: text)
    }
    
    public func setWindInfo(text: String? , secondaryImage: UIImage?) {
        windDetailView.setInfo(labelText: text, secondaryImage: secondaryImage)
    }
}
