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
import Alamofire

class ViewController: UIViewController {
    
    let topGuideView = UIView()
    var locality = String() // 성수동(동명)
    var subLocality = String() // 성수2가(상세주소)
    let currentPlaceButton = UIButton()
    let adScrollView = UIScrollView()
    let locationManager = CLLocationManager()
    var adImagesArray = [UIImage]()
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
    //    var arrayOfCellData = CellData().arrayOfCellData // 하드코딩 데이터
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // ViewContoller용 데이터 저장
        arrayOfCellData = CellData.shared.arrayOfCellData
    }
    override func viewDidLayoutSubviews() {
        // adScrollView의 위치를 오토레이아웃으로 잡기위해 viewDidLayoutSubviews에서 설정합니다.
        adScrollView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(150)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topGuideViewConfig()
        adScrollViewConfig()
        mainCollectionViewConfig()
        checkAuthorizationStatus()
        tabBarIndicatorCreator()
        
        // 주소 가져오는 처리가 완료되면 currentPlaceButtonConfig를 실행합니다.
        locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(currentPlaceButtonConfig), name: NSNotification.Name(rawValue: "addressSet"), object: nil)
    }
    private func tabBarIndicatorCreator() {
        // 탭바 주황색 인디케이터 실행 펑션
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(
            color: #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1),
            size: CGSize(
                width: tabBar.frame.width/CGFloat(tabBar.items!.count),
                height: tabBar.frame.height),  // iPhoneX(height:89)
            lineHeight: 3.0)
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
    private func topGuideViewConfig() {
        // 탑 가이드 뷰 설정(지금보고있는 지역은 + 서치버튼, 맵버튼)
        let currentPlaceGuideLabel = UILabel()
        let searchButton = UIButton()
        let mapButton = UIButton()
        
        view.addSubview(topGuideView)
        topGuideView.snp.makeConstraints { (m) in
            m.top.width.leading.equalTo(view.safeAreaLayoutGuide)
            m.height.equalTo(60)
        }
        
        // 지금보고 있는 지역은? label 위치, 폰트 사이즈, text 지정
        topGuideView.addSubview(currentPlaceGuideLabel)
        currentPlaceGuideLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(8)
            m.leading.equalToSuperview().offset(20)
        }
        currentPlaceGuideLabel.text = "지금 보고 있는 지역은"
        currentPlaceGuideLabel.font = currentPlaceGuideLabel.font.withSize(12)
        
        // 맵 버튼 콘피그
        let mapButtonImage = UIImage(named: "map_button")
        topGuideView.addSubview(mapButton)
        mapButton.setImage(mapButtonImage, for: .normal)
        mapButton.imageView?.contentMode = .scaleAspectFit
        
        mapButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalTo(topGuideView.safeAreaLayoutGuide)
            $0.width.equalTo(65)
            $0.height.equalTo(45)
        }
        mapButton.addTarget(self, action: #selector(mapButtonAction), for: .touchUpInside)
        
        // 서치 버튼 콘피그
        let searchButtonImage = UIImage(named: "search_button")
        topGuideView.addSubview(searchButton)
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalTo(mapButton.snp.leading)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
    }
    @objc private func currentPlaceButtonConfig() {
        // 현위치 버튼 위치, 폰트 사이즈, text 지정
        
        let currentAddress = "\(locality) \(subLocality)" // 성수동 성수2가
        currentPlaceButton.setTitle(currentAddress, for: .normal)
        currentPlaceButton.setTitleColor(.black, for: .normal)
        
        topGuideView.addSubview(currentPlaceButton)
        currentPlaceButton.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(20)
            m.leading.equalToSuperview().offset(20)
        }
    }
    private func adScrollViewConfig() {
        // 횡스크롤 배너
        view.addSubview(adScrollView)
        adScrollView.frame = CGRect(x: view.frame.origin.x, y: 105, width: view.frame.width, height: 150)
        adScrollView.showsHorizontalScrollIndicator = false // 횡스크롤바 없음
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
            m.top.equalTo(adScrollView.snp.bottom).offset(10)
            m.leading.trailing.bottom.equalTo(view)
        }
    }
    //  맵버튼액션 맵뷰로 이동
    @objc func mapButtonAction(sender: UIButton!) {
        print("mapButton tap")
        performSegue(withIdentifier: "showMapView", sender: self)
    }
    private func requestImage(url: String, handler: @escaping (Data) -> Void) {
        // 이미지 리퀘스트 알라모파이어 펑션
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    handler(value)
                case .failure(let error):
                    print("error = ", error.localizedDescription)
                }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    // 콜렉션셀을 터치하면 상세페이지(PlateViewController)로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row] // 선택된 셀의 컬럼 데이터를 넘겨버림
        //  destination.pk = arrayOfCellData[indexPath.row].pk    // 선택한 셀의 pk값을 저장
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
        
        var imageUrlArray: [String] = []  // 이미지 URL이 들어갈 배열 생성
        let postArrayCount = arrayOfCellData[indexPath.item].postArray.count  // 포스트(리뷰)가 몇개 인지 확인
        if postArrayCount > 0 {  // 포스트(리뷰)가 0보다 많으면
            
            for i in 0..<postArrayCount {
                let imageArrayCount = arrayOfCellData[indexPath.item].postArray[i].reviewImage?.count ?? 0  // 포스트(리뷰)에 이미지 어레이가 몇개 인지 확인
                
                for j in 0..<imageArrayCount {  // 리뷰 어레이 있는 모든 이미지를 가져오겠다!
                    let urlOfReviewImages = arrayOfCellData[indexPath.item].postArray[i].reviewImage![j].reviewImageUrl
                    imageUrlArray.append(urlOfReviewImages)
                }
            }
            
            requestImage(url: imageUrlArray.first ?? "defaultImage") { (Data) in
                guard let img = UIImage(data: Data) else { fatalError("Bad data") }
                cell.restaurantPicture.image = img
            }
        } else {
            cell.restaurantPicture.image = UIImage(named: "defaultImage") // 강제 디폴트 이미지 삽입
        }
        
        cell.rankingName.text = "\(indexPath.row + 1). \(arrayOfCellData[indexPath.item].name)"
        cell.gradePoint.text = "\(arrayOfCellData[indexPath.item].gradePoint ?? "0.0")"
        cell.restaurantLocation.text = arrayOfCellData[indexPath.item].address
        cell.viewFeedCount.text = "👁‍🗨\(arrayOfCellData[indexPath.item].viewNum ?? 0)  🖋\(arrayOfCellData[indexPath.item].reviewNum ?? 0)"
        
        return cell
    }
}
extension UIImage {
    // 탭바에 주황색 인디케이터 사용을 위한 익스텐션
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y: size.height - lineHeight), size: CGSize(width: size.width, height: lineHeight))) //  iPhoneX(Y:89)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 현재위치의 위도 경도 가져오기
        let lastestLocation: CLLocation = locations[locations.count - 1]
        let latitude = lastestLocation.coordinate.latitude
        let longitude = lastestLocation.coordinate.longitude
        
        // 위도 경도로 현재 주소 가져오기
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
                    name: NSNotification.Name(rawValue: "addressSet"),
                    object: nil)
            }
        })
    }
}
// 데이터 비동기 처리시 사용해야 하는 구문(feat.조교님) viewDidLoad 안에 론칭 필요
//        CellData.shared.fetchData(completionHander: { datas in
//            self.datasource = datas
//            self.tableView.reloadData()
//        })
