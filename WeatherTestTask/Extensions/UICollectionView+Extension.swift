//
//  UICollectionView+Extension.swift
//  WeatherTestTask
//
//  Created by Alex173 on 19.09.2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            assertionFailure("Cell is not registered")
            return T()
        }
        return cell
    }
    
}
