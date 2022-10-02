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
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
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
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
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
        handleCellSeletionState()
    }
    
    private func handleCellSeletionState() {
        isSelected ? configureCellAsSelected() : configureCellAsDeselected()
    }
    
    private func configureCellAsSelected() {
        dayLabel.textColor = R.color.lightBlue()
        temperatureLabel.textColor = R.color.lightBlue()
        weatherImageView.tintColor = R.color.lightBlue()
        backgroundColor = R.color.white()
        layer.shadowColor = R.color.darkBlue()?.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.zPosition = 1
    }
    
    private func configureCellAsDeselected() {
        dayLabel.textColor = R.color.black()
        temperatureLabel.textColor = R.color.black()
        weatherImageView.tintColor = R.color.black()
        backgroundColor = R.color.white()
        layer.shadowColor = nil
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.zPosition = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selected ? configureCellAsSelected() : configureCellAsDeselected()
    }
    
}
