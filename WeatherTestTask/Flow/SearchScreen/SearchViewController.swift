//
//  SearchViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit

protocol SearchViewControllerDelegate {
    func userDidSelectLocation(coordinates: [Double]?, locationName: String?)
}

class SearchViewController: UIViewController {
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.darkBlue()
        return view
    }()
    
    private lazy var backButton: IconButton = {
        let image = R.image.icon_back()
        let button = IconButton(icon: image, size: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: IconButton = {
        let image = R.image.icon_search()
        let button = IconButton(icon: image, size: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchFieldDidChange(_:)), for: .editingChanged)
        searchField.backgroundColor = R.color.white()
        searchField.borderStyle = .roundedRect
        searchField.textColor = R.color.black()
        searchField.autocorrectionType = .no
        return searchField
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(CitySearchTableViewCell.self)
        return tableView
    }()
    
    private var viewModel: SearchViewModelInterface
    
    private var delegate: SearchViewControllerDelegate
    
    init(viewModel: SearchViewModelInterface, delegate: SearchViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
    }
    
    private func configureViewModel() {
        viewModel.reloadSearchTableViewBlock = { [weak self] in
            self?.searchTableView.reloadData()
        }
        viewModel.userDidSelectLocationBlock = { [weak self] coordinates, locationName in
            self?.delegate.userDidSelectLocation(coordinates: coordinates, locationName: locationName)
        }
    }
    
    private func configureView() {
        view.backgroundColor = R.color.white()
        configureTopView()
        configureBackButton()
        configureSearchButton()
        configureSearchBar()
        configureSearchTableView()
    }
    
    private func configureTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureBackButton() {
        topView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
    }
    
    private func configureSearchButton() {
        topView.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func configureSearchBar() {
        topView.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            $0.leading.equalTo(backButton.snp.trailing).inset(-8)
            $0.trailing.equalTo(searchButton.snp.leading).inset(-8)
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configureSearchTableView() {
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func backButtonPressed() {
        viewModel.goBack()
    }
    
    @objc private func searchButtonPressed() {
        viewModel.userDidPressSearchButton()
    }
    
    @objc private func searchFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else {
            return
        }
        viewModel.getCitySearchData(searchText: searchText)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
