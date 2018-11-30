//
//  PlateViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit
import YouTubePlayer_Swift
import GoogleMaps

final class PlateViewController: UIViewController {
    
    // 각 인스턴스를 밖에서 만들어 주는 이유는 Auto레이아웃을 잡아주기 위함입니다. (안에 만들면 각각 참조가 안됨)
    
    // 스크롤뷰 위에 올리는 가이드뷰(필수 덕목)
    let scrollView = UIScrollView()
    let scrollGuideView = UIView()
    
    // 닫힘버튼(∨), 마이리스트 추가 버튼, 공유하기 버튼 올리는 뷰
    let topGuideView = UIView()
    
    // 콜렉션뷰와 (선택된) 셀데이터
    var plateCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
//    var arrayOfCellData = CellData().arrayOfCellData --> 안쓰는듯
    var selectedColumnData: CellDataStruct?
    
    // 맛집명, 뷰수, 리뷰수, 평점 올리는 뷰
    let middleInfoBarView = UIView()
    // 가고싶다~사진올리기 버튼들을 올리는 뷰
    let middleButtonsView = UIView()
    
    // 맛집 유튜브 연동 뷰
    let youTubeView = YouTubePlayerView()
    // 맛집 주소와 맵 올리는 뷰
    let addressMapView = UIView()
    let mapView = GMSMapView() // MapView(viewDidLayoutSubviews에서 사용해야 하기 때문에 클래스에서 설정)
    
    // 전화걸기 올리는 뷰
    let telView = UIView()
    // 편의정보 & 메뉴 올리는 뷰
    let restaurantInfoAndMenuView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        topGuideViewConfig()
        scrollViewConfig()
        plateCollectionViewConfig()
        middleInfoBarConfig()
        middleButtonsViewConfig()
        youTubeWebView()
        addressMapViewConfig()
        telViewConfig()
        restaurantInfoAndMenuViewConfig()
    }
    private func topGuideViewConfig() {
        // 가장위에 라벨(topGuideView) 작성, 위치 잡기
        topGuideView.backgroundColor = .white
        view.addSubview(topGuideView)
        topGuideView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide)
            m.width.equalToSuperview()
            m.height.equalTo(80)
        }
        
        // topGuideLabel 위에 DownArrow 버튼 설정
        let downArrow = UIButton()
        let downArrowImage = UIImage(named: "DropDownArrow")
        downArrow.setBackgroundImage(downArrowImage, for: .normal)
        downArrow.imageView?.contentMode = .scaleAspectFit
        
        topGuideView.addSubview(downArrow)
        downArrow.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.leading.equalToSuperview().offset(10)
            m.height.equalTo(30)
            m.width.equalTo(30)
        }
        downArrow.addTarget(self, action: #selector(downArrowAction), for: .touchUpInside)
    }
    @objc private func downArrowAction(sender: UIButton) {
        // downArrow 버튼 클릭하면 현재뷰컨트롤러가 dismiss
        presentingViewController?.dismiss(animated: true)
    }
    private func scrollViewConfig() {
        // 스크롤뷰 콘피그
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.width.leading.bottom.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 1200) // 스크롤뷰 높이 설정
        
        // 스크롤 가이드뷰 콘피그
        scrollView.addSubview(scrollGuideView)
        scrollGuideView.snp.makeConstraints {
            $0.top.width.leading.equalToSuperview()
            $0.height.equalTo(1800)  // 스크롤뷰의 높이를 설정
        }
    }
    private func plateCollectionViewConfig() {
        // plateCollectionView Setting
        plateCollectionView.backgroundColor = .white
        plateCollectionView.dataSource = self
        plateCollectionView.delegate = self
        
        // 콜렉션뷰셀 연결
        plateCollectionView.register(PlateCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // 콜렉션뷰 디렉션(종/횡) 방향 설정
        if let layout = plateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // 플레이트 콜렉션뷰 레이아웃 설정
        scrollGuideView.addSubview(plateCollectionView)
        plateCollectionView.snp.makeConstraints { (m) in
            m.top.equalTo(scrollGuideView).offset(10)
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(150)
        }
    }
    private func middleInfoBarConfig() {
        let restaurantNameLabel = UILabel()
        let restaurantViewFeedCountLabel = UILabel()
        let restaurantGradePointLabel = UILabel()
        
        middleInfoBarView.backgroundColor = .white
        scrollGuideView.addSubview(middleInfoBarView)
        middleInfoBarView.snp.makeConstraints { (m) in
            m.top.equalTo(plateCollectionView.snp.bottom).offset(10)
            m.width.equalToSuperview()
            m.height.equalTo(100)
        }
        
        //        restaurantNameLabel.backgroundColor = .red
        restaurantNameLabel.text = selectedColumnData?.name
        restaurantNameLabel.font = UIFont(name: "Helvetica" , size: 25)
        middleInfoBarView.addSubview(restaurantNameLabel)
        restaurantNameLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.top.equalTo(middleInfoBarView.snp.top).inset(15)
            m.bottom.equalTo(middleInfoBarView.snp.centerY)
        }
        
        //        restaurantViewFeedCountLabel.backgroundColor = .blue
        restaurantViewFeedCountLabel.text = "👁‍🗨\(selectedColumnData?.viewNum ?? 0) 🖋\(selectedColumnData?.reviewNum ?? 0)"
        restaurantViewFeedCountLabel.font = UIFont(name: "Helvetica" , size: 15)
        restaurantViewFeedCountLabel.textColor = .gray
        middleInfoBarView.addSubview(restaurantViewFeedCountLabel)
        restaurantViewFeedCountLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.bottom.equalTo(middleInfoBarView.snp.bottom).inset(15)
            m.top.equalTo(middleInfoBarView.snp.centerY)
        }
        
        //        restaurantGradePointLabel.backgroundColor = .yellow
        restaurantGradePointLabel.text = String(selectedColumnData?.gradePoint ?? 0.0)
        restaurantGradePointLabel.textAlignment = .right
        restaurantGradePointLabel.font = UIFont(name: "Helvetica" , size: 40)
        restaurantGradePointLabel.textColor = .orange
        middleInfoBarView.addSubview(restaurantGradePointLabel)
        restaurantGradePointLabel.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantNameLabel)
            m.trailing.equalToSuperview().inset(15)
            m.height.width.equalTo(60)
        }
        
    }
    private func middleButtonsViewConfig() {
        // middleButtonsView Auto-Layout 셋팅
        middleButtonsView.backgroundColor = .white
        scrollGuideView.addSubview(middleButtonsView)
        middleButtonsView.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom).offset(10)
            m.width.equalToSuperview()
            m.height.equalTo(120)
        }
        
        // 가고싶다~사진올리기 버튼 및 라벨 올리기
        let want2goButton = UIButton()
        let want2goLabel = UILabel()
        let checkInButton = UIButton()
        let checkInLabel = UILabel()
        let writeReviewButton = UIButton()
        let writeReviewLabel = UILabel()
        let uploadPicButton = UIButton()
        let uploadPicLabel = UILabel()
        
        want2goButton.setImage(#imageLiteral(resourceName: "cooking-dinner-food-76093"), for: .normal)
        middleButtonsView.addSubview(want2goButton)
        want2goButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView)
            m.leading.equalToSuperview()
            m.width.height.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        want2goLabel.text = "가고싶다"
        want2goLabel.textColor = .orange
        want2goLabel.textAlignment = .center
        middleButtonsView.addSubview(want2goLabel)
        want2goLabel.snp.makeConstraints {
            $0.top.equalTo(want2goButton.snp.bottom)
            $0.width.equalTo(want2goButton)
        }
        
        checkInButton.setImage(#imageLiteral(resourceName: "burrito-chicken-close-up-461198"), for: .normal)
        middleButtonsView.addSubview(checkInButton)
        checkInButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView)
            m.leading.equalTo(want2goButton.snp.trailing)
            m.width.height.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        checkInLabel.text = "체크인"
        checkInLabel.textColor = .orange
        checkInLabel.textAlignment = .center
        middleButtonsView.addSubview(checkInLabel)
        checkInLabel.snp.makeConstraints {
            $0.top.equalTo(checkInButton.snp.bottom)
            $0.leading.equalTo(checkInButton)
            $0.width.equalTo(checkInButton)
        }
        
        writeReviewButton.setImage(#imageLiteral(resourceName: "sunset-1645103_1280"), for: .normal)
        middleButtonsView.addSubview(writeReviewButton)
        writeReviewButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView)
            m.leading.equalTo(checkInButton.snp.trailing)
            m.width.height.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        writeReviewLabel.text = "리뷰쓰기"
        writeReviewLabel.textColor = .orange
        writeReviewLabel.textAlignment = .center
        middleButtonsView.addSubview(writeReviewLabel)
        writeReviewLabel.snp.makeConstraints {
            $0.top.equalTo(writeReviewButton.snp.bottom)
            $0.leading.equalTo(writeReviewButton)
            $0.width.equalTo(writeReviewButton)
        }
        
        uploadPicButton.setImage(#imageLiteral(resourceName: "banner-1686943_1280"), for: .normal)
        middleButtonsView.addSubview(uploadPicButton)
        uploadPicButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView)
            m.leading.equalTo(writeReviewButton.snp.trailing)
            m.width.height.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        uploadPicLabel.text = "사진올리기"
        uploadPicLabel.textColor = .orange
        uploadPicLabel.textAlignment = .center
        middleButtonsView.addSubview(uploadPicLabel)
        uploadPicLabel.snp.makeConstraints {
            $0.top.equalTo(uploadPicButton.snp.bottom)
            $0.leading.equalTo(uploadPicButton)
            $0.width.equalTo(uploadPicButton)
        }
    }
    private func youTubeWebView() {
        // 유튜브 URL이 없으면 높이 1 스크롤 가이드뷰를 생성하고 아니면 유튜브 플레이어 표시
        guard let youTubeUrl = selectedColumnData?.youTubeUrl else {     // -> 가드렛이 잘못 쓰인건지 확인 필요!!!!
            scrollGuideView.addSubview(youTubeView)
            youTubeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleButtonsView.snp.bottom)
                m.width.equalToSuperview()
                m.height.equalTo(1)
            }
            return }
        
        // 유튜브 URL이 있으면 하기 진행
        scrollGuideView.addSubview(youTubeView)
        youTubeView.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView.snp.bottom).offset(10)
            m.width.leading.equalToSuperview()
            m.height.equalTo(200)
        }
        
        youTubeView.playerVars = ["playsinline": 1 as AnyObject] // 전체화면 아닌 해당 페이지에서 플레이
        let myVideoURL = NSURL(string: youTubeUrl)
        youTubeView.loadVideoURL(myVideoURL! as URL)
    }
    private func addressMapViewConfig() {
        addressMapView.backgroundColor = .white
        scrollGuideView.addSubview(addressMapView)
        addressMapView.snp.makeConstraints { (m) in
            m.top.equalTo(youTubeView.snp.bottom).offset(10)
            m.leading.width.equalToSuperview()
            m.height.equalTo(150)
        }
        
        // 주소 표시 뷰 세팅, 주소를 라벨에 삽입
        let addressLabel = UILabel()
        addressLabel.backgroundColor = .white
        addressMapView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.width.equalToSuperview().multipliedBy(0.8)
            m.centerX.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        guard let address = selectedColumnData?.address else { return }
        addressLabel.text = address
        addressLabel.textColor = .gray
        
        // 맵뷰 마커 설정
        let marker = GMSMarker()
        guard let latitude = selectedColumnData?.latitude else { return }
        guard let longitude = selectedColumnData?.longitude else { return }
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "\(selectedColumnData?.name ?? "여긴 어디지요?")"
        marker.map = mapView
        mapView.isMyLocationEnabled = false
        
        // 맵뷰 오토레이아웃
        addressMapView.addSubview(mapView)
        mapView.snp.makeConstraints { (m) in
            m.top.equalTo(addressLabel.snp.bottom).offset(5)
            m.width.leading.bottom.equalToSuperview()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 맵뷰 오토레이아웃 설정된 뒤에 "카메라" 값을 입력해야 맵 중앙에 마커 표시됨
        guard let latitude = selectedColumnData?.latitude else { return }
        guard let longitude = selectedColumnData?.longitude else { return }
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        mapView.camera = camera
    }
    private func telViewConfig() {
        telView.backgroundColor = .white
        scrollGuideView.addSubview(telView)
        telView.snp.makeConstraints { (m) in
            m.top.equalTo(addressMapView.snp.bottom).offset(10)
            m.leading.width.equalToSuperview()
            m.height.equalTo(80)
        }
        let rectangle = UIView()
        rectangle.backgroundColor = .black
        telView.addSubview(rectangle)
        rectangle.snp.makeConstraints { (m) in
            m.margins.equalToSuperview().inset(10)
        }
        
        let callButton = UIButton()
        callButton.backgroundColor = .white
        rectangle.addSubview(callButton)
        callButton.snp.makeConstraints { (m) in
            m.margins.equalToSuperview().inset(2)
        }
        
        callButton.setTitle("✆ 전화하기", for: .normal)
        callButton.setTitleColor(.black, for: .normal)
        callButton.titleLabel?.font = UIFont(name: "Helvetica", size: 25)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
    }
    @objc private func callButtonTapped(){
        let telNumber = selectedColumnData?.phoneNum
        // 알럿 생성, 실행시 전화 연결
        let callAlert = UIAlertController(title: nil, message: "식당에 전화하시겠습니까", preferredStyle: .actionSheet)
        callAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        callAlert.addAction(UIAlertAction(title: "전화하기", style: .default, handler: { (UIAlertAction) in
            if let url = URL(string: "tel://\(telNumber ?? "0")") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)            }
        }))
        self.present(callAlert, animated: true)
    }
    private func restaurantInfoAndMenuViewConfig() {
        restaurantInfoAndMenuView.backgroundColor = .gray
        scrollGuideView.addSubview(restaurantInfoAndMenuView)
        restaurantInfoAndMenuView.snp.makeConstraints { (m) in
            m.top.equalTo(telView.snp.bottom).offset(10)
            m.leading.width.equalToSuperview()
            m.height.equalTo(300)
        }
        
        let restaurantInfoLabel = UILabel()
        let bizHourLabel = UILabel()
//        let bizHourDataLabel = UILabel()
//        let priceLabel = UILabel()
//        let priceDataLabel = UILabel()
//        let moreInfoButton = UIButton()
        
        // 편의정보 라벨
        restaurantInfoLabel.backgroundColor = .blue
        restaurantInfoAndMenuView.addSubview(restaurantInfoLabel)
        restaurantInfoLabel.snp.makeConstraints { (m) in
            m.top.leading.equalToSuperview().offset(10)
            m.width.equalTo(80)
            m.height.equalTo(25)
        }
        restaurantInfoLabel.text = "편의정보"
        restaurantInfoLabel.textColor = .darkGray
        restaurantInfoLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        // 영업시간 라벨
        bizHourLabel.backgroundColor = .magenta
        restaurantInfoAndMenuView.addSubview(bizHourLabel)
        bizHourLabel.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantInfoLabel.snp.bottom)
            m.leading.equalTo(restaurantInfoLabel)
            m.width.equalTo(80)
            m.height.equalTo(25)
        }
        bizHourLabel.text = "영업시간"
        bizHourLabel.textColor = .gray
        bizHourLabel.font = UIFont(name: "Helvetica", size: 15)
    }
}

extension PlateViewController: UISearchControllerDelegate {
    // 터치시 이동할 내용 들어갈 예정
}
extension PlateViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
extension PlateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 // 하드코딩으로 4 잡았습니다 (selectedColumnData?.image.count ?? 0)원데이터
        //        return arrayOfCellData.filter { $0.pk == pk }.first?.image.count ?? 0 // 고차함수 사용예 (pk는 유닉한 값)
    }
    // 셀에 이미지 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plateCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlateCollectionViewCell
        cell.restaurantPicture.image = UIImage(named: "defaultImage")  // 이미지 강제 삽입
        return cell
    }
}

// 유엽군이 만든 버튼제작 func
//var btns: [UIButton] = []
//func createbtn(title: String, frame: CGRect, tag: Int) {
//    let btn = UIButton()
//    btn.frame = frame
//    btn.tag = tag
//    btns.append(btn)
//    view.addSubview(btn)
//}
