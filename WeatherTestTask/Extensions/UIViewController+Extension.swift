//
//  UIViewController+Extension.swift
//  WeatherTestTask
//
//  Created by Alex173 on 04.10.2022.
//

import UIKit

extension UIViewController {
    
    public func showAlert(title: String, message: String, buttonTitle: String, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: actionHandler)
        alertController.addAction(okAction)
        alertController.view.tintColor = UIColor.tintColor
        present(alertController, animated: true, completion: nil)
    }
    
    public func showMultipleOptionsAlert(with title: String, and message: String, alertActions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in alertActions {
            alertController.addAction(action)
        }
        alertController.view.tintColor = UIColor.tintColor
        present(alertController, animated: true, completion: nil)
    }
}
