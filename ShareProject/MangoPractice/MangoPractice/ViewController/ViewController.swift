//
//  ViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 11/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import CoreLocation


class ViewController: UIViewController {
    
    let currentPlaceGuideLabel = UILabel()
    let currentPlaceButton = UIButton()
    let searchButton = UIButton()
    let mapButton = UIButton()
    let adScrollView = UIScrollView()
    let locationManager = CLLocationManager()
    var adImagesArray = [UIImage]()
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellData().arrayOfCellData
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPlaceLabelButtonConfig()
        adScrollViewConfig()
        mainCollectionViewConfig()
        mapButtonConfig()
        searchButtonConfig()
        checkAuthorizationStatus()

    }
    
    // 위치 사용권한 체크
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        //            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            startUpdatingLocation()
        }
    }
    
    private func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedAlways || status == .authorizedWhenInUse,
            CLLocationManager.locationServicesEnabled()
            else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0 // 이벤트를 발생시키는 최소거리
        locationManager.startUpdatingLocation()
        
    }
    
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
    
    private func mapButtonConfig() {
        let mapButtonImage = UIImage(named: "map_button")
        view.addSubview(mapButton)
        mapButton.setImage(mapButtonImage, for: .normal)
        mapButton.imageView?.contentMode = .scaleAspectFit
        
        mapButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(70)
            $0.height.equalTo(50)
        }
        
        mapButton.addTarget(self, action: #selector(mapButtonAction), for: .touchUpInside)
    }
    
    private func searchButtonConfig() {
        let searchButtonImage = UIImage(named: "search_button")
        view.addSubview(searchButton)
        
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(mapButton.snp.leading)
            $0.width.equalTo(43)
            $0.height.equalTo(43)
        }
        
        
    }
    private func adScrollViewConfig() {
        
        // 횡스크롤 배너
        view.addSubview(adScrollView)
        adScrollView.frame = CGRect(x: view.frame.origin.x, y: currentPlaceButton.bounds.maxY + 100, width: view.frame.width, height: 120)
        adScrollView.showsHorizontalScrollIndicator = false // 횡스크롤바 없음
        adScrollView.backgroundColor = .gray
        adScrollView.isPagingEnabled = true
        
        
        // 횡스크롤 배너에 이미지 넣기
        adImagesArray = [UIImage(named: "ad2") , UIImage(named: "ad1"), UIImage(named: "ad3")] as! [UIImage]
        for i in 0..<adImagesArray.count {
            let adView = UIImageView()
            adView.contentMode = .scaleToFill
            adView.image = adImagesArray[i]
            
            let xPosition = view.frame.width * CGFloat(i)
            adView.frame = CGRect(x: xPosition, y: adScrollView.bounds.origin.y, width: adScrollView.frame.width, height: adScrollView.frame.height)
            adScrollView.contentSize.width = adScrollView.frame.width * CGFloat((i + 1))
            
            adScrollView.addSubview(adView)
            
        }
        let button1 = UIButton()
        let button2 = UIButton()
        let button3 = UIButton()
        
        button1.backgroundColor = .clear
        adScrollView.addSubview(button1)
        button1.frame = CGRect(x: view.frame.width * 0, y: adScrollView.bounds.origin.y, width: adScrollView.frame.width, height: adScrollView.frame.height)
        button1.addTarget(self, action: #selector(button1Action), for: .touchUpInside)
        
        button2.backgroundColor = .clear
        adScrollView.addSubview(button2)
        button2.frame = CGRect(x: view.frame.width * 1, y: adScrollView.bounds.origin.y, width: adScrollView.frame.width, height: adScrollView.frame.height)
        button2.addTarget(self, action: #selector(button2Action), for: .touchUpInside)
        
        button3.backgroundColor = .clear
        adScrollView.addSubview(button3)
        button3.frame = CGRect(x: view.frame.width * 2, y: adScrollView.bounds.origin.y, width: adScrollView.frame.width, height: adScrollView.frame.height)
        button3.addTarget(self, action: #selector(button3Action), for: .touchUpInside)
    }
    
    @objc func button1Action() {
        print("button1 Actioned")
        if let url = URL(string: "https://www.mangoplate.com/eat_deals") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @objc func button2Action() {
        print("button2 Actioned")
        if let url = URL(string: "http://www.mangoplate.com/campaigns/48?utm_source=url&utm_campaign=48&utm_medium=campaign&utm_term=v3_ios") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @objc func button3Action() {
        print("button3 Actioned")
        
        if let url = URL(string: "https://www.mangoplate.com/top_lists/832_wangsimni?utm_source=url&utm_campaign=832_wangsimni&utm_medium=toplist&utm_term=v3_ios") {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
        
      
    
    
    private func mainCollectionViewConfig() {
        // mainCollectionView Setting
        mainCollectionView.backgroundColor = .white
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")  //  콜렉션뷰쎌 연결(레지스터)
        
        // 콜렉션뷰 레이아웃 설정
        view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { (m) in
            m.top.equalTo(adScrollView.snp.bottom).offset(20)
            m.leading.trailing.bottom.equalTo(view)
        }
    }
    
    //  맵버튼액션 맵뷰로 이동
    
    @objc func mapButtonAction(sender: UIButton!) {
        print("mapButton tap")
        performSegue(withIdentifier: "showMapView", sender: self)
     
    }
    
    
    
    
    
}

extension ViewController: UICollectionViewDelegate {
    // 콜렉션셀을 터치하면 상세페이지(PlateViewController)로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row] // 선택된 셀의 컬럼 데이터를 넘겨버림
//        destination.pk = arrayOfCellData[indexPath.row].pk    // 선택한 셀의 pk값을 저장
        present(destination, animated: true)  // 플레이트뷰 컨트롤러를 띄움
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2, height: collectionView.frame.height / 3)
    }
    // 콜렉션뷰 셀의 안쪽 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    // 콜렉션뷰 셀의 미니멈 행간 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    // 콜렉션뷰 셀의 미니멈 열간 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
}
extension ViewController: UICollectionViewDataSource {
    // cell 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    // cell 구성하기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        cell.restaurantPicture.image = arrayOfCellData[indexPath.item].image.first
        cell.rankingName.text = "\(arrayOfCellData[indexPath.item].ranking). \(arrayOfCellData[indexPath.item].name)"
        cell.gradePoint.text = String(arrayOfCellData[indexPath.item].gradePoint)
        cell.restaurantLocation.text = String(arrayOfCellData[indexPath.item].location)
        cell.viewFeedCount.text = arrayOfCellData[indexPath.item].viewFeedCount
        
        return cell
    }
}


