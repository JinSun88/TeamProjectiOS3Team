//
//  LocationSelectViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 03/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationSelectViewController: UIViewController {
    let backButton = UIButton()
    let searchTextField = UITextField()
    let confirmLocationButton = UIButton()
    let locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()
    var selectLocationMapView = GMSMapView()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        move(at: locationManager.location?.coordinate)

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        selectLocationMapViewConfig()
        confirmLocationButtonConfig()
    

    }
    
    private func topViewConfig() {
        view.addSubview(backButton)
        view.addSubview(searchTextField)
        
        searchTextField.delegate = self
        
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchDragInside)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "식당 위치 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchTextField.returnKeyType = .search
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.top.height.equalTo(backButton)
            $0.trailing.equalToSuperview()
        }
        
    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        print("backButtonDidTap")
        dismiss(animated: true, completion: nil)
    }
    
    private func selectLocationMapViewConfig() {
        view.addSubview(selectLocationMapView)
        
        selectLocationMapView.isMyLocationEnabled = true
        
        selectLocationMapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom)
            $0.bottom.equalToSuperview().offset(-50)
        }
        

    }
    
    private func confirmLocationButtonConfig() {
        view.addSubview(confirmLocationButton)
        
        confirmLocationButton.backgroundColor = .orange
        confirmLocationButton.setTitle("이 위치 설정하기", for: .normal)
        confirmLocationButton.setTitleColor(.white, for: .normal)
        
        confirmLocationButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.selectLocationMapView.camera = camera
        self.selectLocationMapView.isMyLocationEnabled = true
    }
    
}

extension LocationSelectViewController {
    func move(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
        selectLocationMapView.camera = camera
    }
}

    // 위치 변경에 따른 델리게이트 설정
extension LocationSelectViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        let coordinate = current.coordinate
        
        move(at: coordinate)
    }
}

extension LocationSelectViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
}

extension LocationSelectViewController: GMSAutocompleteViewControllerDelegate  {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        
        selectLocationMapView.camera = camera
        searchTextField.text = place.formattedAddress

        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = selectLocationMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}




