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
    
    // 초기페이지에서 선택된 셀 데이터만 저장하도록 하는 인스턴스
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
    // 주요리뷰 및 맛있다/괜찮다/별로 표시 라벨
    let majorReviewAndButtonView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        
        topGuideViewConfig()
        scrollViewConfig()
        plateCollectionViewConfig()
        middleInfoBarConfig()
        middleButtonsViewConfig()
        youTubeWebView()
        addressMapViewConfig()
        telViewConfig()
        restaurantInfoAndMenuViewConfig()
        majorReviewAndButtonViewConfig()
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
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 1800) // 스크롤뷰 높이 설정
        
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
        
        restaurantNameLabel.text = selectedColumnData?.name
        restaurantNameLabel.font = UIFont(name: "Helvetica" , size: 25)
        middleInfoBarView.addSubview(restaurantNameLabel)
        restaurantNameLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.top.equalTo(middleInfoBarView.snp.top).inset(15)
            m.bottom.equalTo(middleInfoBarView.snp.centerY)
        }
        
        restaurantViewFeedCountLabel.text = "👁‍🗨\(selectedColumnData?.viewNum ?? 0) 🖋\(selectedColumnData?.reviewNum ?? 0)"
        restaurantViewFeedCountLabel.font = UIFont(name: "Helvetica" , size: 15)
        restaurantViewFeedCountLabel.textColor = #colorLiteral(red: 0.4862189293, green: 0.4863065481, blue: 0.4862134457, alpha: 1)
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
        want2goButton.addTarget(self, action: #selector(want2goButtonTapped), for: .touchUpInside)
        
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
        checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
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
        writeReviewButton.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
        
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
        uploadPicButton.addTarget(self, action: #selector(uploadPicButtonTapped), for: .touchUpInside)
        
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
    @objc private func want2goButtonTapped() {
        print("want2goButtonTapped")
    }
    @objc private func checkInButtonTapped() {
        print("checkInButtonTapped")
    }
    @objc private func writeReviewButtonTapped() {
        print("writeReviewButtonTapped")
    }
    @objc private func uploadPicButtonTapped() {
        print("uploadPicButtonTapped")
    }
    private func youTubeWebView() {
        // 유튜브 URL에 "youtube" 포함되어 있으면이 유튜브 플레이어 표시, 없으면 높이 1 스크롤 가이드뷰를 생성
        guard let youTubeUrl = selectedColumnData?.youTubeUrl else { return }
        
        if youTubeUrl.contains("youtube") {
            scrollGuideView.addSubview(youTubeView)
            youTubeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleButtonsView.snp.bottom).offset(10)
                m.width.leading.equalToSuperview()
                m.height.equalTo(200)
            }
            youTubeView.playerVars = ["playsinline": 1 as AnyObject] // 전체화면 아닌 해당 페이지에서 플레이
            let myVideoURL = NSURL(string: youTubeUrl)
            youTubeView.loadVideoURL(myVideoURL! as URL)
        } else {
            scrollGuideView.addSubview(youTubeView)
            youTubeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleButtonsView.snp.bottom)
                m.width.equalToSuperview()
                m.height.equalTo(1)
            }
        }
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
        guard let addressDetail = selectedColumnData?.addressDetail else { return }
        addressLabel.text = addressDetail
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
        rectangle.backgroundColor = #colorLiteral(red: 0.4862189293, green: 0.4863065481, blue: 0.4862134457, alpha: 1)
        telView.addSubview(rectangle)
        rectangle.snp.makeConstraints { (m) in
            m.margins.equalToSuperview().inset(10)
        }
        
        let callButton = UIButton()
        callButton.backgroundColor = .white
        rectangle.addSubview(callButton)
        callButton.snp.makeConstraints { (m) in
            m.margins.equalToSuperview().inset(1)
        }
        
        callButton.setTitle("✆ 전화하기", for: .normal)
        callButton.setTitleColor(#colorLiteral(red: 0.4862189293, green: 0.4863065481, blue: 0.4862134457, alpha: 1), for: .normal)
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
        restaurantInfoAndMenuView.backgroundColor = .white
        scrollGuideView.addSubview(restaurantInfoAndMenuView)
        restaurantInfoAndMenuView.snp.makeConstraints { (m) in
            m.top.equalTo(telView.snp.bottom).offset(10)
            m.leading.width.equalToSuperview()
            m.height.equalTo(250)  // --> 메뉴가 들어왔을 때 사이즈 분기처리 필요!!!
        }
        
        let restaurantInfoLabel = UILabel()
        let bizHourLabel = UILabel()
        let modifiedAtLabel = UILabel()
        let bizHourDataLabel = UILabel()
        let priceLabel = UILabel()
        let priceDataLabel = UILabel()
        let visitInfoLabel = UILabel()
        let visitInfoMarkLabel = UILabel()
        let visitInfoTextLabel = UILabel()
        let moreInfoButton = UIButton()
        
        // 편의정보 라벨
        restaurantInfoLabel.backgroundColor = .white
        restaurantInfoAndMenuView.addSubview(restaurantInfoLabel)
        restaurantInfoLabel.snp.makeConstraints { (m) in
            m.top.leading.equalToSuperview().offset(10)
            m.width.equalTo(80)
            m.height.equalTo(25)
        }
        restaurantInfoLabel.text = "편의정보"
        restaurantInfoLabel.textColor = .darkGray
        restaurantInfoLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 마지막 업데이트 데이터 라벨
        modifiedAtLabel.backgroundColor = .white
        restaurantInfoAndMenuView.addSubview(modifiedAtLabel)
        modifiedAtLabel.snp.makeConstraints { (m) in
            m.top.height.equalTo(restaurantInfoLabel)
            m.trailing.equalToSuperview().inset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        guard let rawModifiedAtData = selectedColumnData?.modifiedAt else { return }
        let modifiedAtData = rawModifiedAtData[..<rawModifiedAtData.index(rawModifiedAtData.startIndex, offsetBy: 10)]
        modifiedAtLabel.textAlignment = .right
        modifiedAtLabel.text = "마지막 업데이트: \(modifiedAtData)"
        modifiedAtLabel.textColor = .lightGray
        modifiedAtLabel.font = UIFont(name: "Helvetica", size: 12)
        
        // 영업시간 라벨
        bizHourLabel.backgroundColor = .white
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
        
        // 영업시간 데이터 라벨
        guard let rawBizHourData = selectedColumnData?.businessHour else { return }
        let bizHourData = rawBizHourData
        bizHourDataLabel.textAlignment = .right
        bizHourDataLabel.text = "\(bizHourData)"
        
        if rawBizHourData.contains("\r\n") {  // rawBizHourData에 \r\n(서버데이터)이 포함되어 있으면 2줄처리
            bizHourDataLabel.numberOfLines = 2
        } else {
            bizHourDataLabel.numberOfLines = 1
        }
        
        bizHourDataLabel.textColor = .black
        bizHourDataLabel.font = UIFont(name: "Helvetica", size: 15)
        bizHourDataLabel.backgroundColor = .white
        
        restaurantInfoAndMenuView.addSubview(bizHourDataLabel)
        bizHourDataLabel.snp.makeConstraints { (m) in
            m.top.equalTo(bizHourLabel)
            if rawBizHourData.contains("\r\n") {  // rawBizHourData에 \r\n(서버데이터)이 포함되어 라벨폭을 1.8배로
                m.height.equalTo(bizHourLabel).multipliedBy(1.8)
            } else {
                m.height.equalTo(bizHourLabel)
            }
            m.trailing.equalToSuperview().inset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        
        // 가격정보 라벨
        priceLabel.backgroundColor = .white
        restaurantInfoAndMenuView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (m) in
            m.top.equalTo(bizHourDataLabel.snp.bottom)
            m.leading.equalTo(restaurantInfoLabel)
            m.width.equalTo(80)
            m.height.equalTo(25)
        }
        priceLabel.text = "가격정보"
        priceLabel.textColor = .gray
        priceLabel.font = UIFont(name: "Helvetica", size: 15)
        
        // 가격정보 데이터 라벨
        priceDataLabel.backgroundColor = .white
        restaurantInfoAndMenuView.addSubview(priceDataLabel)
        priceDataLabel.snp.makeConstraints { (m) in
            m.top.height.equalTo(priceLabel)
            m.trailing.equalToSuperview().inset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        guard let rawPriceData = selectedColumnData?.priceLevel else { return }
        let priceData = rawPriceData
        priceDataLabel.textAlignment = .right
        priceDataLabel.text = "\(priceData)"
        priceDataLabel.textColor = .black
        priceDataLabel.font = UIFont(name: "Helvetica", size: 15)
        
        // 추가 방문정보 라벨 (인포 마크 + 전화후 방문해 주세요)
        visitInfoLabel.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        restaurantInfoAndMenuView.addSubview(visitInfoLabel)
        visitInfoLabel.snp.makeConstraints { (m) in
            m.top.equalTo(priceLabel.snp.bottom).offset(10)
            m.leading.equalTo(priceLabel)
            m.trailing.equalTo(priceDataLabel)
            m.height.equalTo(60)
        }
        
        visitInfoMarkLabel.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        visitInfoLabel.addSubview(visitInfoMarkLabel)
        visitInfoMarkLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(10)
            m.centerY.equalToSuperview()
            m.width.equalTo(20)
            m.height.equalTo(20)
        }
        visitInfoMarkLabel.text = "ⓘ"
        visitInfoMarkLabel.textColor = .darkGray
        visitInfoMarkLabel.font = UIFont(name: "Helvetica", size: 20)
        
        visitInfoTextLabel.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        visitInfoLabel.addSubview(visitInfoTextLabel)
        visitInfoTextLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(3)
            m.leading.equalTo(visitInfoMarkLabel.snp.trailing).offset(5)
            m.centerY.equalToSuperview()
            m.trailing.equalToSuperview().inset(10)
        }
        visitInfoTextLabel.text = "준비한 재료가 소진되었을 경우 영업시간보다 일찍 문 닫을 수 있어요. 전화 후 방문해주세요."
        visitInfoTextLabel.numberOfLines = 2
        visitInfoTextLabel.textColor = .darkGray
        visitInfoTextLabel.font = UIFont(name: "Helvetica", size: 13)
        
        // 정보 더 보기 버튼
        moreInfoButton.backgroundColor = .white
        restaurantInfoAndMenuView.addSubview(moreInfoButton)
        moreInfoButton.snp.makeConstraints { (m) in
            m.top.equalTo(visitInfoLabel.snp.bottom).offset(10)
            m.trailing.equalTo(visitInfoLabel)
            m.height.equalTo(30)
        }
        moreInfoButton.setTitle("정보 더 보기 ＞", for: .normal)
        moreInfoButton.setTitleColor(.gray, for: .normal)
        
        moreInfoButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
        
        // !!! 메뉴가 들어오면 메뉴 표시해야 함 !!!
    }
    @objc private func moreInfoButtonTapped() {
        print("moreInfoButtonTapped")
    }
    private func majorReviewAndButtonViewConfig() {
        scrollGuideView.addSubview(majorReviewAndButtonView)
        majorReviewAndButtonView.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantInfoAndMenuView.snp.bottom).offset(10)
            m.width.equalToSuperview()
            m.height.equalTo(110)
        }
        
        // 주요리뷰(리뷰수) 표시 라벨
        let majorReviewLabel = UILabel()
        majorReviewLabel.backgroundColor = #colorLiteral(red: 0.9528378844, green: 0.9530009627, blue: 0.952827394, alpha: 1)
        majorReviewAndButtonView.addSubview(majorReviewLabel)
        majorReviewLabel.snp.makeConstraints { (m) in
            m.top.width.equalToSuperview()
            m.height.equalTo(50)
        }
        majorReviewLabel.text = "주요 리뷰 ($$)" // -->> 리뷰수 데이터 연계필요
        majorReviewLabel.font = UIFont(name: "Helvetica", size: 20)
        majorReviewLabel.textAlignment = .center
        majorReviewLabel.textColor = .orange
        
        // 맛있다! 버튼
        let goodButtonView = UIView()
        let goodButton = UIButton()
        let goodButtonImageView = UIImageView()
        let goodButtonLabel = UILabel()
        
        goodButtonView.backgroundColor = .white
        majorReviewAndButtonView.addSubview(goodButtonView)
        goodButtonView.snp.makeConstraints { (m) in
            m.top.equalTo(majorReviewLabel.snp.bottom)
            m.bottom.equalToSuperview()
            m.width.equalToSuperview().multipliedBy(0.33).inset(5)
        }
        
        goodButtonView.addSubview(goodButton)
        goodButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        goodButton.addTarget(self, action: #selector(goodButtonTapped), for: .touchUpInside)
        
        goodButtonImageView.image = UIImage(named: "GoodFace")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        goodButtonImageView.contentMode = .scaleAspectFit
        goodButtonView.addSubview(goodButtonImageView)
        goodButtonImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        goodButtonLabel.text = "맛있다! ($$)"  // -->> 리뷰수 데이터 연계필요
        goodButtonLabel.textAlignment = .center
        goodButtonLabel.font = UIFont(name: "Helvetica", size: 12)
        goodButtonLabel.textColor = .orange
        goodButtonView.addSubview(goodButtonLabel)
        goodButtonLabel.snp.makeConstraints { (m) in
            m.bottom.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        // 괜찮다 버튼
        let sosoButtonView = UIView()
        let sosoButton = UIButton()
        let sosoButtonImageView = UIImageView()
        let sosoButtonLabel = UILabel()
        
        sosoButtonView.backgroundColor = .white
        majorReviewAndButtonView.addSubview(sosoButtonView)
        sosoButtonView.snp.makeConstraints { (m) in
            m.top.equalTo(majorReviewLabel.snp.bottom)
            m.centerX.equalToSuperview()
            m.leading.equalTo(goodButtonView.snp.trailing).offset(2)
            m.bottom.equalToSuperview()
            m.width.equalTo(goodButtonView)
        }
        
        sosoButtonView.addSubview(sosoButton)
        sosoButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        sosoButton.addTarget(self, action: #selector(sosoButtonTapped), for: .touchUpInside)
        
        sosoButtonImageView.image = UIImage(named: "SosoFace")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        sosoButtonImageView.contentMode = .scaleAspectFit
        sosoButtonView.addSubview(sosoButtonImageView)
        sosoButtonImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        sosoButtonLabel.text = "괜찮다 ($$)"  // -->> 리뷰수 데이터 연계필요
        sosoButtonLabel.textAlignment = .center
        sosoButtonLabel.font = UIFont(name: "Helvetica", size: 12)
        sosoButtonLabel.textColor = .orange
        sosoButtonView.addSubview(sosoButtonLabel)
        sosoButtonLabel.snp.makeConstraints { (m) in
            m.bottom.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        // 별로 버튼
        let badButtonView = UIView()
        let badButton = UIButton()
        let badButtonImageView = UIImageView()
        let badButtonLabel = UILabel()
        
        badButtonView.backgroundColor = .white
        majorReviewAndButtonView.addSubview(badButtonView)
        badButtonView.snp.makeConstraints { (m) in
            m.top.equalTo(majorReviewLabel.snp.bottom)
            m.leading.equalTo(sosoButtonView.snp.trailing).offset(2)
            m.bottom.equalToSuperview()
            m.width.equalTo(goodButtonView)
        }
        
        badButtonView.addSubview(badButton)
        badButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        badButton.addTarget(self, action: #selector(badButtonTapped), for: .touchUpInside)
        
        badButtonImageView.image = UIImage(named: "BadFace")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        badButtonImageView.contentMode = .scaleAspectFit
        badButtonView.addSubview(badButtonImageView)
        badButtonImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        badButtonLabel.text = "별로 ($$)"  // -->> 리뷰수 데이터 연계필요
        badButtonLabel.textAlignment = .center
        badButtonLabel.font = UIFont(name: "Helvetica", size: 12)
        badButtonLabel.textColor = .orange
        badButtonView.addSubview(badButtonLabel)
        badButtonLabel.snp.makeConstraints { (m) in
            m.bottom.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
    }
    @objc private func goodButtonTapped() {
        print("goodButtonTapped")
    }
    @objc private func sosoButtonTapped() {
        print("sosoButtonTapped")
    }
    @objc private func badButtonTapped() {
        print("badButtonTapped")
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
