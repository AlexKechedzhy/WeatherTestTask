//
//  MapViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation
import CoreLocation

protocol MapViewModelInterface {
    func goBack()
}

class MapViewModel: NSObject, MapViewModelInterface {
    
    weak var coordinator: MainCoordinatorInteface?
    
    override init() {
        super.init()
    }
    
    func goBack() {
        coordinator?.goBack()
    }
}
