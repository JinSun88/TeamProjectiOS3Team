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
    let buttonView = UIView()
    let mainView = ViewController()
    let locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var mapCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellData.shared.arrayOfCellData
    var selectedColumnData: CellDataStruct?  // --> 현재 안쓰는듯?
    
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
        buttonViewConfig()
        mapViewConfig()
        collectionViewConfig()
<<<<<<< HEAD
=======
        getData()
        
>>>>>>> 7e571e2c43f045d99e8b37d7e58c677d9a6ecc4c
    }
    
    
    // 현재지역 버튼 셋업
    private func currentPlaceLabelButtonConfig() {
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
        currentPlaceButton.setTitle("왕십리/성동 ∨", for: .normal)
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
    
    private func buttonViewConfig() {
        view.addSubview(buttonView)
        buttonView.backgroundColor = .lightGray
        
        buttonView.snp.makeConstraints {
            $0.top.equalTo(currentPlaceButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func mapViewConfig() {
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        mapView.isMyLocationEnabled = true
    }
    
    private func collectionViewConfig() {
        mapCollectionView.backgroundColor = .clear
        mapCollectionView.dataSource = self
        mapCollectionView.delegate = self
        mapCollectionView.isPagingEnabled = true
        
        mapCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        
        if let layout = mapCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        mapView.addSubview(mapCollectionView)
        mapCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalTo(view).offset(view.frame.width * 0.08)
            $0.trailing.equalTo(view).offset(-(view.frame.width * 0.08))
            $0.height.equalTo(100)
        }
    }
    
    @objc func mapUnwindButtonAction(sender: UIButton!) {
        print("mapUnwindButton tap")
        dismiss(animated: true, completion: nil)
    }
<<<<<<< HEAD
=======
    
    func getData() {
        RestaurantService().restaurantList(type: .restaurantList) { data in
            print("debug: \(data)")
        }
    }
    
    func makeMaker() {
        
    }
    
>>>>>>> 7e571e2c43f045d99e8b37d7e58c677d9a6ecc4c
}

// 이동에 대해 변하도록 설정
extension MapViewController {
    func move(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
        mapView.camera = camera
    }
}
// 위치 변경에 따른 델리게이트 설정
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        let coordinate = current.coordinate
        
        move(at: coordinate)
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 6) * 5, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
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
        cell.gradePoint.text = "\(arrayOfCellData[indexPath.item].gradePoint ?? 0.0)"
        cell.restaurantLocation.text = String(arrayOfCellData[indexPath.item].address)
        cell.viewFeedCount.text = "👁‍🗨\(arrayOfCellData[indexPath.item].viewNum)  🖋\(arrayOfCellData[indexPath.item].reviewNum)"
        
        return cell
    }
}

extension MapViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mapCollectionView {
            var currentCellOffset = mapCollectionView.contentOffset
            currentCellOffset.x += mapCollectionView.frame.width / 2
            if let indexPath = mapCollectionView.indexPathForItem(at: currentCellOffset) {
                mapCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}






