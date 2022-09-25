//
//  MapViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit

class MapViewController: UIViewController {
    
    private var viewModel: MapViewModelInterface
    
    init(viewModel: MapViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.black()
    }
}
