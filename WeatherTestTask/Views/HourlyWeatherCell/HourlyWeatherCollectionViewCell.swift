//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherTestTask
//
//  Created by Alex173 on 20.09.2022.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 22)
//        label.text = "01"
        return label
    }()
    
    private let minuteLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 14)
//        label.text = "00"
        return label
    }()
    
    private let weatherImageView: UIImageView = {
//        let image = R.image.icon_white_day_cloudy()?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView()
        imageView.tintColor = R.color.white()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
        label.font = UIFont.systemFont(ofSize: 22)
//        label.text = "27°"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .clear
        configureHourLabel()
        configureMinuteLabel()
        configureWeatherImageView()
        configureTemperatureLabel()
    }
    
    private func configureHourLabel() {
        addSubview(hourLabel)
        hourLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    private func configureMinuteLabel() {
        addSubview(minuteLabel)
        minuteLabel.snp.makeConstraints {
            $0.top.equalTo(hourLabel.snp.top).inset(2)
            $0.leading.equalTo(hourLabel.snp.trailing)
        }
    }
    
    private func configureWeatherImageView() {
        addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(hourLabel.snp.bottom).inset(-16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)            
        }
    }
    
    private func configureTemperatureLabel() {
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            
        }
    }

    public func set(hours: String?, weatherImage: UIImage?, temperature: String?) {
        hourLabel.text = hours
        weatherImageView.image = weatherImage
        temperatureLabel.text = temperature
    }
    
}
