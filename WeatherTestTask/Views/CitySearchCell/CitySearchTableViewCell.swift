//
//  CitySearchCell.swift
//  WeatherTestTask
//
//  Created by Alex173 on 30.09.2022.
//

import UIKit

class CitySearchTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = R.color.white()
        textLabel?.textColor = R.color.black()
        textLabel?.textAlignment = .center
        selectionStyle = .gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = R.color.lightBlue()?.withAlphaComponent(0.7)
        selectedBackgroundView = backgroundView
    }
    
}
