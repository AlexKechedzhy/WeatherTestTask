//
//  MainCoordinator.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    init(navigationController: UINavigationController)
}

protocol MainCoordinatorInteface: Coordinator {
    func goBack()
    func showMapScreen()
}

class MainCoordinator: MainCoordinatorInteface {
    
    private let navigationController: UINavigationController
    
    func start() {
        let viewModel = MainViewModel()
        let mainController = MainViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(mainController, animated: false)
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showMapScreen() {
        let viewModel = MapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}

