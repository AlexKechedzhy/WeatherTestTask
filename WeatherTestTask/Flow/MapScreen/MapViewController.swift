//
//  MapViewController.swift
//  WeatherTestTask
//
//  Created by Alex173 on 17.09.2022.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func userDidChooseCoordinates(latitude: Double, longitude: Double)
}

class MapViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.addAnnotation(pointAnnotation)
        return mapView
    }()
    
    private lazy var backButton: IconButton = {
        let image = R.image.icon_back()
        let button = IconButton(icon: image, size: 40)
        button.layer.cornerRadius = 20
        button.backgroundColor = R.color.darkBlue()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var getWeatherButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get weather", for: .normal)
        button.backgroundColor = R.color.darkBlue()
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(userDidPressGetWeatherButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private var viewModel: MapViewModelInterface
    
    private var delegate: MapViewControllerDelegate?
    
    private let pointAnnotation = MKPointAnnotation()
    
    init(viewModel: MapViewModelInterface, delegate: MapViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTapGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerScreen()
    }
    
    private func configureView() {
        view.backgroundColor = R.color.lightBlue()
        configureMapView()
        configureBackButton()
        configureGetWeatherButton()
    }
    
    private func configureTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTap(sender:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureBackButton() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    private func configureGetWeatherButton() {
        view.addSubview(getWeatherButton)
        getWeatherButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    private func centerScreen() {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        latitudinalMeters: 100000,
                                        longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func backButtonPressed() {
        viewModel.goBack()
    }
    
    @objc private func userDidTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        pointAnnotation.coordinate = locationCoordinate
        getWeatherButton.isHidden = false
    }
    
    @objc private func userDidPressGetWeatherButton() {
        let selectedLatitude = pointAnnotation.coordinate.latitude
        let selectedLongitude = pointAnnotation.coordinate.longitude
        delegate?.userDidChooseCoordinates(latitude: selectedLatitude, longitude: selectedLongitude)
        viewModel.goBack()
    }
}
