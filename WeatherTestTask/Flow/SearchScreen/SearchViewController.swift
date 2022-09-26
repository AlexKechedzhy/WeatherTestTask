//
//  SearchViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModelInterface
    
    init(viewModel: SearchViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.lightBlue()
    }
}
