//
//  SearchViewModel.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import Foundation

protocol SearchViewModelInterface {
    func goBack()
}

class SearchViewModel: SearchViewModelInterface {
    
    weak var coordinator: MainCoordinatorInteface?
    
    func goBack() {
        coordinator?.goBack()
    }
}

