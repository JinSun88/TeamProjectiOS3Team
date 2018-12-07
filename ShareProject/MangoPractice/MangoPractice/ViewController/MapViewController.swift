//
//  MapViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 27/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import AddressBookUI

class MapViewController: UIViewController {
    let currentPlaceGuideLabel = UILabel()
    let currentPlaceButton = UIButton()
    let searchButton = UIButton()
    let mapUnwindButton = UIButton()
    let mainView = ViewController()
    let locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var mapCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MapViewFlowLayout())
    var arrayOfCellData = CellData.shared.arrayOfCellData
    var selectedColumnData: ServerStruct.CellDataStruct?
    var locality = String() // 성수동(동명)
    var subLocality = String() // 성수2가(상세주소)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        move(at: locationManager.location?.coordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapUnwindButtonConfig()
        currentPlaceLabelButtonConfig()
        mapUnwindButtonConfig()
        searchButtonConfig()
        mapViewConfig()
        collectionViewConfig()
        makeMaker()
        
        // 주소 가져오는 처리가 완료되면 currentPlaceButtonConfig를 재실행합니다.
        locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(currentPlaceLabelButtonConfig), name: NSNotification.Name(rawValue: "addressSetAtMapViewController"), object: nil)
    }
    
    // 현재지역 버튼 셋업
    @objc private func currentPlaceLabelButtonConfig() {
        // 지금보고 있는 지역은? label 위치, 폰트 사이즈, text 지정
        view.addSubview(currentPlaceGuideLabel)
        currentPlaceGuideLabel.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            m.leading.equalTo(view).offset(30)
        }
        
        currentPlaceGuideLabel.text = "지금 보고 있는 지역은"
        currentPlaceGuideLabel.font = currentPlaceGuideLabel.font.withSize(10)
        
        // 현위치 버튼 위치, 폰트 사이즈, text 지정
        view.addSubview(currentPlaceButton)
        currentPlaceButton.snp.makeConstraints { (m) in
            m.top.equalTo(currentPlaceGuideLabel.snp.bottom)
            m.leading.equalTo(currentPlaceGuideLabel)
        }
    
        let currentAddress = "\(locality) \(subLocality)"
        currentPlaceButton.setTitle(currentAddress, for: .normal)
        currentPlaceButton.setTitleColor(.black, for: .normal)
    }
    
    private func mapUnwindButtonConfig() {
        let mapUnwindButtonImage = UIImage(named: "mapUnwindButton")
        view.addSubview(mapUnwindButton)
        mapUnwindButton.setImage(mapUnwindButtonImage, for: .normal)
        mapUnwindButton.imageView?.contentMode = .scaleAspectFit
        
        mapUnwindButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(70)
            $0.height.equalTo(50)
        }
        
        mapUnwindButton.addTarget(self, action: #selector(mapUnwindButtonAction), for: .touchUpInside)
    }
    
    private func searchButtonConfig() {
        let searchButtonImage = UIImage(named: "search_button")
        view.addSubview(searchButton)
        
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(mapUnwindButton.snp.leading)
            $0.width.equalTo(43)
            $0.height.equalTo(43)
        }
    }
    
    private func mapViewConfig() {
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.equalTo(currentPlaceButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        mapView.isMyLocationEnabled = true
    }
    
    private func collectionViewConfig() {
        mapCollectionView.backgroundColor = .clear
        mapCollectionView.dataSource = self
        mapCollectionView.delegate = self
        mapCollectionView.isPagingEnabled = false
        
        mapCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        
        if let layout = mapCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        mapView.addSubview(mapCollectionView)
        mapCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.width.equalTo(mapView)
            $0.height.equalTo(100)
        }
    }
    
    @objc func mapUnwindButtonAction(sender: UIButton!) {
        print("mapUnwindButton tap")
        dismiss(animated: true, completion: nil)
    }

    func makeMaker() {
        var latitude: [CLLocationDegrees] = CellData.shared.arrayOfCellData.map {
            $0.latitude ?? 0.0
        }// latitude만 어레이로
        var longitude: [CLLocationDegrees] = CellData.shared.arrayOfCellData.map {
            $0.longitude ?? 0.0
        }// longitude만 어레이로
        var name = CellData.shared.arrayOfCellData.map {
            $0.name
        }
        
        // 마커찍기(이름과 순위 표시)
        for i in 0 ..< arrayOfCellData.count {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude[i], longitude: longitude[i])
            marker.title = "\(i + 1). \(name[i]) "
            marker.map = mapView
            marker.icon = UIImage(named:"MapMarkerImage")
        }
    }
}

// 이동에 대해 변하도록 설정
extension MapViewController {
    func move(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        mapView.camera = camera
    }
}
// 위치 변경에 따른 델리게이트 설정
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        let coordinate = current.coordinate
        
        move(at: coordinate)
        
        // 위도 경도로 현재 주소 가져오기
        let lastestLocation: CLLocation = locations[locations.count - 1]
        let latitude = lastestLocation.coordinate.latitude
        let longitude = lastestLocation.coordinate.longitude
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let currentLocality: String = address.last?.locality {
                    self.locality = currentLocality
                }
                if let currentThoroughfare: String = address.last?.thoroughfare {
                    self.subLocality = currentThoroughfare
                }
                
                // 위에 처리(주소 가져오기)가 끝나면 노티피케이션을 띄우겠습니다.
                self.locationManager.stopUpdatingLocation()
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: "addressSetAtMapViewController"),
                    object: nil)
            }
        })
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 6) * 5, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (collectionView.frame.width * 0.1), bottom: 0, right: (collectionView.frame.width * 0.1))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(10)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let offset = collectionView.bounds.width / 2
        let contentOffset = offset + (collectionView.contentOffset.x)
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: contentOffset, y: collectionView.bounds.height / 2)) else { return }
        let data = arrayOfCellData[indexPath.item]
        let camera = GMSCameraPosition.camera(withLatitude: data.latitude ?? 0.0, longitude: data.longitude ?? 0.0, zoom: 15.0)
        let position = GMSCameraUpdate.setCamera(camera)
        mapView.animate(with: position) // 카메라 이동자연스럽게 되도록
        
        
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mapCollectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! MapCollectionViewCell
        
        cell.restaurantPicture.image = UIImage(named: "defaultImage") // 강제 디폴트 이미지 삽입
        cell.rankingName.text = "\(indexPath.row + 1). \(arrayOfCellData[indexPath.item].name)"
        cell.gradePoint.text = "\(arrayOfCellData[indexPath.item].gradePoint ?? "0.0")"
        cell.restaurantLocation.text = arrayOfCellData[indexPath.item].address
        cell.viewFeedCount.text = "👁‍🗨\(arrayOfCellData[indexPath.item].viewNum ?? 0)  🖋\(arrayOfCellData[indexPath.item].reviewNum ?? 0)"
        
        return cell
    }
}

extension MapViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row]
        present(destination, animated: true)
        
    }
}







