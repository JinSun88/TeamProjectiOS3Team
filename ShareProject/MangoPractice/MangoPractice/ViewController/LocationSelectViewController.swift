//
//  LocationSelectViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 03/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import GooglePlaces
import GoogleMaps

protocol SendDataDelegate {
    func sendData(data: String, latitude: Double, longitude: Double)
} // 자동완성으로 검색된 주소값을 넘기기 위해 프로토콜 선언

class LocationSelectViewController: UIViewController {
    let backButton = UIButton()
    let searchTextField = UITextField()
    let confirmLocationButton = UIButton()
    let locationManager = CLLocationManager()
    let centerPinImage = UIImageView()
    let addressLabel = UILabel()
    let currentLocationMarker = GMSMarker()
    var selectLocationMapView = GMSMapView()
    var centerPinImageVerticalConstraint: NSLayoutConstraint!
    var delegate: SendDataDelegate?
    
    var lat: Double? // 지도로 설정한 위치의 위경도 값을 받는 변수
    var long: Double?

    
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
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
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
        dismiss(animated: true, completion: nil)
    }
    
    private func selectLocationMapViewConfig() {
        view.addSubview(selectLocationMapView)
        view.addSubview(centerPinImage)
        selectLocationMapView.addSubview(addressLabel)
        selectLocationMapView.delegate = self
        
        selectLocationMapView.isMyLocationEnabled = true
        centerPinImage.image = UIImage(named: "MapMarkerImage")
        addressLabel.backgroundColor = .white
        addressLabel.text = ""
        addressLabel.textAlignment = .center

    
        
        selectLocationMapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        centerPinImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(40)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(selectLocationMapView).offset(15)
            $0.trailing.equalTo(selectLocationMapView).offset(-15)
            $0.bottom.equalTo(selectLocationMapView).offset(-45)
            $0.height.equalTo(55)
        }
        

    }
    
    private func confirmLocationButtonConfig() {
        view.addSubview(confirmLocationButton)
        
        confirmLocationButton.backgroundColor = .orange
        confirmLocationButton.setTitle("이 위치 설정하기", for: .normal)
        confirmLocationButton.setTitleColor(.white, for: .normal)
        confirmLocationButton.addTarget(self, action: #selector(confirmLocationButtonDidTap), for: .touchUpInside)
        
        confirmLocationButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
    }
    
    @objc func confirmLocationButtonDidTap() {
        if let data = addressLabel.text {
            delegate?.sendData(data: data, latitude: lat ?? 0.0, longitude: long ?? 0.0)
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    
    // 주소라벨이 주소나타내기위한 역지오코딩
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            let originLines: String = lines.joined(separator: "\n")
            let resultAddress = originLines.replacingOccurrences(of: "대한민국", with: "") // 주소 중 대한민국 제외
            self.addressLabel.text = resultAddress
            
        }
    }
    
    private func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.selectLocationMapView.camera = camera
        self.selectLocationMapView.isMyLocationEnabled = true
    }
    
    private func openEnrollVC() {
        dismiss(animated: true, completion: nil)
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
// 자동완성된 주소를 델리게이트에 담음
extension LocationSelectViewController: GMSAutocompleteViewControllerDelegate  {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let originAddress = place.formattedAddress
        let resultAddress = originAddress?.replacingOccurrences(of: "대한민국", with: "") // 주소 중 대한민국 제외
        
        if let data = resultAddress {
            delegate?.sendData(data: data, latitude: Double(place.coordinate.latitude), longitude: Double(place.coordinate.longitude)) // 자동완성된 주소와 해당장소의 위경도 값을 펑션에 담음
        }
        dismiss(animated: true, completion: nil) //자동완성VC 닫음
        openEnrollVC() //식당등록화면으로 dismiss
        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LocationSelectViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target) //지도에서 위치를 주소는 펑션
        let positionLat = position.target.latitude
        let positionLong = position.target.longitude
        lat = positionLat
        long = positionLong
        // 해당장소의 위경도를 변수에 담음
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
}





