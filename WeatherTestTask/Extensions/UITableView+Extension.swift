//
//  UITableView+Extension.swift
//  WeatherTestTask
//
//  Created by Alex173 on 19.09.2022.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            assertionFailure("Cell is not registered")
            return T()
        }
        return cell
    }
    
}
