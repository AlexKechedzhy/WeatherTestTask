//
//  IconButton.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit
import SnapKit

class IconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(icon: UIImage?, size: CGFloat) {
        super.init(frame: .zero)
        let newImage = icon?.withRenderingMode(.alwaysTemplate)
        setImage(newImage, for: .normal)
        tintColor = R.color.white()
        snp.makeConstraints {
            $0.width.height.equalTo(size)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
}

