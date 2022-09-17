//
//  MainViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import Foundation

protocol MainViewModelInterface {
    func showMapScreen()
    func showSearchScreen()
}

class MainViewModel: NSObject, MainViewModelInterface {
    
    weak var coordinator: MainCoordinatorInteface?
    
    func showMapScreen() {
        coordinator?.showMapScreen()
    }
    
    func showSearchScreen() {
        coordinator?.showSearchScreen()
    }
    
}
