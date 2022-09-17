//
//  MainViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 14.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var mapButton: IconButton = {
        let button = IconButton(icon: R.image.icon_my_location())
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: IconButton = {
        let button = IconButton(icon: R.image.icon_search())
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()

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
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = R.color.darkBlue()
        configureMapButton()
        configureSearchButton()
    }

    private func configureMapButton() {
        view.addSubview(mapButton)
        mapButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.top)
            $0.trailing.equalTo(mapButton.snp.leading).inset(-16)
        }
    }

    @objc private func mapButtonPressed() {
        viewModel.showMapScreen()
    }
    
    @objc private func searchButtonPressed() {
        viewModel.showSearchScreen()
    }
}

