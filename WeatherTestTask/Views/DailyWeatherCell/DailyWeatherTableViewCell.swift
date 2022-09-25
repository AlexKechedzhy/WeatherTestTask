//
//  DailyWeatherTableViewCell.swift
//  WeatherTestTask
//
//  Created by Alex173 on 20.09.2022.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = UIFont.systemFont(ofSize: 22)
//        label.text = "MON"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = UIFont.systemFont(ofSize: 22)
//        label.text = "27° / 19°"
        return label
    }()
    
    private let weatherImageView: UIImageView = {
//        let image = R.image.icon_white_day_cloudy()?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView()
        imageView.tintColor = R.color.black()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .clear
        configureDayLabel()
        configureTemperatureLabel()
        configureWeatherImageView()
    }
    
    private func configureDayLabel() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func configureTemperatureLabel() {
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureWeatherImageView() {
        addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
    }

    public func set(dayLabelText: String?, temperatureLabelText: String?, weatherImage: UIImage?) {
        dayLabel.text = dayLabelText
        temperatureLabel.text = temperatureLabelText
        weatherImageView.image = weatherImage
    }
    
}
