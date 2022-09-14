//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit

class MainViewController: UIViewController {

    private var viewModel: MainViewModelInterface
    
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

