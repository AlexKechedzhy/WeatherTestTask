//
//  WeatherTopView.swift
//  WeatherTestTask
//
//  Created by Alex173 on 03.10.2022.
//

import UIKit

protocol WeatherTopViewDelegate {
    func mapButtonPressed()
    func searchButtonPressed()
}

class WeatherTopView: UIView {
    
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
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private var delegate: WeatherTopViewDelegate
    
    init(delegate: WeatherTopViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = R.color.darkBlue()
        configureMapButton()
        configureSearchButton()
        configureLocationIconImageView()
        configureLocationTitleLabel()
        configureDateLabel()
    }
    
    private func configureMapButton() {
        addSubview(mapButton)
        mapButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureSearchButton() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.top)
            $0.trailing.equalTo(mapButton.snp.leading).inset(-16)
        }
    }
    
    private func configureLocationIconImageView() {
        addSubview(locationIconImageView)
        locationIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
    }
    
    private func configureLocationTitleLabel() {
        addSubview(locationTitleLabel)
        locationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIconImageView)
            $0.leading.equalTo(locationIconImageView.snp.trailing).inset(-8)
            $0.trailing.equalTo(searchButton.snp.leading).inset(-8)
        }
    }
    
    private func configureDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(locationIconImageView.snp.bottom).inset(-16)
            $0.leading.equalTo(locationIconImageView)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    public func setTitleLabelText(_ text: String?) {
        locationTitleLabel.text = text
    }
    
    public func setDateLabelText(_ text: String?) {
        dateLabel.text = text
    }
    
    @objc private func mapButtonPressed() {
        delegate.mapButtonPressed()
    }
    
    @objc private func searchButtonPressed() {
        delegate.searchButtonPressed()
    }
    
}
