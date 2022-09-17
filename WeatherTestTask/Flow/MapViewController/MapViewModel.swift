//
//  MapViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation

protocol MapViewModelInterface {
    func goBack()
}

class MapViewModel: MapViewModelInterface {
    
    weak var coordinator: MainCoordinatorInteface?
    
    func goBack() {
        coordinator?.goBack()
    }
}
