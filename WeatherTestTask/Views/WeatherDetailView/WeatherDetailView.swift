//
//  WeatherDetailView.swift
//  WeatherTestTask
//
//  Created by Alex173 on 24.09.2022.
//

import UIKit

class WeatherDetailView: UIView {
    
    private let primaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = R.color.white()
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = R.color.white()
        return label
    }()
    
    private let secondaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = R.color.white()
        return imageView
    }()
    
    init(primaryImage: UIImage?) {
        primaryImageView.image = primaryImage
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        tintColor = R.color.white()
        configurePrimaryImageView()
        configureTextLabel()
        configureSecondaryImageView()
    }
    
    private func configurePrimaryImageView() {
        addSubview(primaryImageView)
        primaryImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func configureTextLabel() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(primaryImageView.snp.trailing).inset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureSecondaryImageView() {
        addSubview(secondaryImageView)
        secondaryImageView.snp.makeConstraints {
            $0.leading.equalTo(textLabel.snp.trailing).inset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    public func setInfo(labelText: String?, secondaryImage: UIImage? = nil) {
        textLabel.text = labelText
        secondaryImageView.image = secondaryImage
    }
    
}
