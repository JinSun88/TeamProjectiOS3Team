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
import Alamofire
import Kingfisher

final class PlateViewController: UIViewController {
    
    // 각 인스턴스를 밖에서 만들어 주는 이유는 Auto레이아웃을 잡아주기 위함입니다. (안에 만들면 각각 참조가 안됨)
    
    let scrollView = UIScrollView()  // 스크롤뷰 위에 올리는 가이드뷰(필수 덕목)
    let scrollGuideView = UIView()
    let topGuideView = UIView()  // 닫힘버튼(∨)
    let downArrow = UIButton() // topGuideView 안의 닫힘버튼(∨)
    let restaurantNameLabelOnTop = UILabel() // topGuideView 안의 맛집 이름
    var plateCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())  // 콜렉션뷰와 (선택된) 셀데이터
    var selectedColumnData: ServerStruct.CellDataStruct?  // 초기페이지에서 선택된 셀 데이터만 저장하도록 하는 인스턴스
    var reviewImageUrlArray:[String] = [] // 초기페이지에서 선택된 셀의 리뷰 이미지 배열
    let middleInfoBarView = UIView()  // 맛집명, 뷰수, 리뷰수, 평점 올리는 뷰
    let middleButtonsView = UIView()  // 가고싶다~사진올리기 버튼들을 올리는 뷰
    let writeReviewBackgroundView = UIView() // 리뷰쓰기 실행시 베이스 뷰
    let uploadPicBackgroundView = UIView() // 사진올리기 실행시 베이스 뷰
    let imagePicker = UIImagePickerController() // 포토라이브러리 컨트롤러
    let photoLibraryImageView = UIImageView() // 포토라이브러리 표시되는 이미지뷰
    let middleButtonsView2 = UIView() // 스크롤시 고정되는 뷰
    var middleButtonsView2IsOn: Bool = false
    let youTubeView = YouTubePlayerView()  // 맛집 유튜브 연동 뷰
    var youTubeUsing: Bool = false // 유튜브가 사용되는지 아닌지를 확인하는 변수(스크롤가이드의 사이즈 영향)
    let addressMapView = UIView()  // 맛집 주소와 맵 올리는 뷰
    let mapView = GMSMapView() // MapView(viewDidLayoutSubviews에서 사용해야 하기 때문에 클래스에서 설정)
    let telView = UIView()  // 전화걸기 올리는 뷰
    let restaurantInfoAndMenuView = UIView()  // 편의정보 & 메뉴 올리는 뷰
    let majorReviewAndButtonView = UIView()  // 주요리뷰 및 맛있다/괜찮다/별로 표시 라벨
    let reviewTableView = UITableView() // 리뷰 올라가는 테이블 뷰
    let moreReviewView = UIView() // 마지막 "리뷰 더보기" 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        
        topGuideViewConfig()
        scrollViewConfig()
        plateCollectionViewConfig()
        middleInfoBarConfig()
        middleButtonsViewConfig()
        imagePicker.delegate = self // 사진 라이브러리 접근
        youTubeWebView()
        addressMapViewConfig()
        telViewConfig()
        restaurantInfoAndMenuViewConfig()
        majorReviewAndButtonViewConfig()
        reviewTableViewConfig()
        moreReviewViewConfig()
    }
    private func topGuideViewConfig() {
        
        // 가장위에 라벨(topGuideView) 작성, 위치 잡기
        topGuideView.backgroundColor = UIColor(red: 0.976802, green: 0.47831, blue: 0.170915, alpha: 0)
        view.addSubview(topGuideView)
        topGuideView.snp.makeConstraints { (m) in
            m.top.width.leading.trailing.equalToSuperview()
            m.height.equalTo(80)
        }
        
        // topGuideLabel 위에 DownArrow 버튼 설정
        let window = UIApplication.shared.keyWindow
        guard let unsafeHeight = window?.safeAreaInsets.top else { return }
        let unsafeHeightHalf = unsafeHeight / 2
        
        let downArrowImage = UIImage(named: "downArrowWhite")
        let tintedImage = downArrowImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        downArrow.setImage(tintedImage, for: .normal)
        downArrow.tintColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        downArrow.imageView?.contentMode = .scaleAspectFit
        
        topGuideView.addSubview(downArrow)
        downArrow.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview().offset(unsafeHeightHalf)
            m.leading.equalToSuperview().offset(20)
            m.height.equalTo(30)
            m.width.equalTo(30)
        }
        downArrow.addTarget(self, action: #selector(downArrowAction), for: .touchUpInside)
        
        topGuideView.addSubview(restaurantNameLabelOnTop)
        restaurantNameLabelOnTop.snp.makeConstraints { (m) in
            m.leading.equalTo(downArrow.snp.trailing).offset(20)
            m.centerY.equalTo(downArrow)
            m.width.equalToSuperview().multipliedBy(0.7)
        }
        restaurantNameLabelOnTop.text = selectedColumnData?.name
        restaurantNameLabelOnTop.font = UIFont(name: "Helvetica", size: 18)
        restaurantNameLabelOnTop.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 0)
    }
    @objc private func downArrowAction(sender: UIButton) {
        // downArrow 버튼 클릭하면 현재뷰컨트롤러가 dismiss
        presentingViewController?.dismiss(animated: true)
    }
    private func scrollViewConfig() {
        scrollView.delegate = self
        // youTube가 포함되는지 여부를 확인
        if selectedColumnData?.youTubeUrl?.contains("youtube") ?? false {
            youTubeUsing = true
        } else {
            youTubeUsing = false
        }
        
        // 스크롤뷰 콘피그
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.width.leading.bottom.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 800)
        
        // 스크롤 가이드뷰 콘피그
        scrollView.addSubview(scrollGuideView)
        scrollGuideView.snp.makeConstraints {
            $0.top.width.leading.bottom.equalToSuperview()
            
            if youTubeUsing == false {
                $0.height.equalTo(1350) // 유튜브 없는 스크롤뷰의 높이를 설정
            } else {
                $0.height.equalTo(1550) // 유튜브 있는 스크롤뷰의 높이를 설정
            }
        }
    }
    private func plateCollectionViewConfig() {
        // 선택된 맛집 데이터의 리뷰 이미지만 배열로 생성하는 부분
        let postArrayCount = selectedColumnData?.postArray.count ?? 0
        var reviewImageArray:[[ServerStruct.CellDataStruct.PostStruct.ReviewImageStruct]] = [[]]
        
        for i in 0..<postArrayCount {
            guard let tempData = selectedColumnData?.postArray[i].reviewImage else { return }
            reviewImageArray.append(tempData)
            
            let reviewImageCount = selectedColumnData?.postArray[i].reviewImage?.count ?? 0
            for j in 0..<reviewImageCount {
                guard let tempData2 = selectedColumnData?.postArray[i].reviewImage?[j].reviewImageUrl else { return }
                reviewImageUrlArray.append(tempData2)
            }
        }
        
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
            m.width.leading.equalToSuperview()
            m.height.equalTo(100)
        }
        
        restaurantNameLabel.text = selectedColumnData?.name
        restaurantNameLabel.font = UIFont(name: "Helvetica" , size: 22)
        middleInfoBarView.addSubview(restaurantNameLabel)
        restaurantNameLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.top.equalTo(middleInfoBarView.snp.top).inset(15)
            m.bottom.equalTo(middleInfoBarView.snp.centerY)
        }
        
        restaurantViewFeedCountLabel.text = "👁‍🗨\(selectedColumnData?.viewNum ?? 0)  🖋\(selectedColumnData?.reviewNum ?? 0)  ⭐️ \(selectedColumnData?.wantNum ?? 0)"
        restaurantViewFeedCountLabel.font = UIFont(name: "Helvetica" , size: 13)
        restaurantViewFeedCountLabel.textColor = #colorLiteral(red: 0.4862189293, green: 0.4863065481, blue: 0.4862134457, alpha: 1)
        middleInfoBarView.addSubview(restaurantViewFeedCountLabel)
        restaurantViewFeedCountLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.bottom.equalTo(middleInfoBarView.snp.bottom).inset(15)
            m.top.equalTo(middleInfoBarView.snp.centerY)
        }
        
        //        restaurantGradePointLabel.backgroundColor = .yellow
        restaurantGradePointLabel.text = selectedColumnData?.gradePoint ?? "##"
        restaurantGradePointLabel.textAlignment = .right
        restaurantGradePointLabel.font = UIFont(name: "Helvetica" , size: 40)
        restaurantGradePointLabel.textColor = .orange
        middleInfoBarView.addSubview(restaurantGradePointLabel)
        restaurantGradePointLabel.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantNameLabel)
            m.trailing.equalToSuperview().inset(15)
            m.height.equalTo(60)
            m.width.equalTo(90)
        }
        
    }
    private func middleButtonsViewConfig() {
        // middleButtonsView Auto-Layout 셋팅
        middleButtonsView.backgroundColor = .white
        scrollGuideView.addSubview(middleButtonsView)
        middleButtonsView.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom).offset(10)
            m.width.equalToSuperview()
            m.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.2)
        }
        
        // 가고싶다~사진올리기 버튼 및 라벨 올리기
        let want2goView = UIView()
        let want2goButton = UIButton()
        let want2goImageView = UIImageView()
        let want2goLabel = UILabel()
        
        middleButtonsView.addSubview(want2goView)
        want2goView.snp.makeConstraints { (m) in
            m.top.leading.bottom.equalToSuperview()
            m.width.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        want2goView.addSubview(want2goButton)
        want2goButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        want2goButton.addTarget(self, action: #selector(want2goButtonTapped), for: .touchUpInside)
        
        want2goImageView.image = UIImage(named: "StarEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        want2goImageView.contentMode = .scaleAspectFit
        want2goView.addSubview(want2goImageView)
        want2goImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        want2goLabel.text = "가고싶다"
        want2goLabel.textColor = .orange
        want2goLabel.font = UIFont(name: "Helvetica", size: 13)
        want2goLabel.textAlignment = .center
        want2goView.addSubview(want2goLabel)
        want2goLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let checkInView = UIView()
        let checkInButton = UIButton()
        let checkInImageView = UIImageView()
        let checkInLabel = UILabel()
        
        middleButtonsView.addSubview(checkInView)
        checkInView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(want2goView.snp.trailing)
            m.width.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        checkInView.addSubview(checkInButton)
        checkInButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        checkInImageView.image = UIImage(named: "CheckInEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: -2, bottom: 0, right: -2))
        checkInImageView.contentMode = .scaleAspectFit
        checkInView.addSubview(checkInImageView)
        checkInImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        checkInLabel.text = "체크인"
        checkInLabel.textColor = .orange
        checkInLabel.font = UIFont(name: "Helvetica", size: 13)
        checkInLabel.textAlignment = .center
        checkInView.addSubview(checkInLabel)
        checkInLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let writeReviewView = UIView()
        let writeReviewButton = UIButton()
        let writeReviewImageView = UIImageView()
        let writeReviewLabel = UILabel()
        
        middleButtonsView.addSubview(writeReviewView)
        writeReviewView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(checkInView.snp.trailing)
            m.width.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        writeReviewView.addSubview(writeReviewButton)
        writeReviewButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        writeReviewButton.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
        
        writeReviewImageView.image = UIImage(named: "PenEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -9, left: -7, bottom: -5, right: -7))
        writeReviewImageView.contentMode = .scaleAspectFit
        writeReviewView.addSubview(writeReviewImageView)
        writeReviewImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        writeReviewLabel.text = "리뷰쓰기"
        writeReviewLabel.textColor = .orange
        writeReviewLabel.font = UIFont(name: "Helvetica", size: 13)
        writeReviewLabel.textAlignment = .center
        writeReviewView.addSubview(writeReviewLabel)
        writeReviewLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let uploadPicView = UIView()
        let uploadPicButton = UIButton()
        let uploadPicImageView = UIImageView()
        let uploadPicLabel = UILabel()
        
        middleButtonsView.addSubview(uploadPicView)
        uploadPicView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(writeReviewView.snp.trailing)
            m.width.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        uploadPicView.addSubview(uploadPicButton)
        uploadPicButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        uploadPicButton.addTarget(self, action: #selector(uploadPicButtonTapped), for: .touchUpInside)
        
        uploadPicImageView.image = UIImage(named: "CameraEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -7, left: -5, bottom: 0, right: -5))
        uploadPicImageView.contentMode = .scaleAspectFit
        uploadPicView.addSubview(uploadPicImageView)
        uploadPicImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        uploadPicLabel.text = "사진올리기"
        uploadPicLabel.textColor = .orange
        uploadPicLabel.font = UIFont(name: "Helvetica", size: 13)
        uploadPicLabel.textAlignment = .center
        uploadPicView.addSubview(uploadPicLabel)
        uploadPicLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
    }
    private func middleButtonsViewConfig2() {
        middleButtonsView2IsOn = true
        // 스크롤시 고정되는 부분(신규 생성)
        // middleButtonsView Auto-Layout 셋팅
        middleButtonsView2.backgroundColor = .white
        view.addSubview(middleButtonsView2)
        middleButtonsView2.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom).offset(5)
            m.width.equalToSuperview()
            m.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.2)
        }
        let upperGrayBar = UIView()
        upperGrayBar.backgroundColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        middleButtonsView2.addSubview(upperGrayBar)
        upperGrayBar.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.height.equalTo(5)
            m.width.equalToSuperview()
        }
        let bottomGrayBar = UIView()
        bottomGrayBar.backgroundColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        middleButtonsView2.addSubview(bottomGrayBar)
        bottomGrayBar.snp.makeConstraints { (m) in
            m.top.equalTo(middleButtonsView2.snp.bottom)
            m.height.equalTo(5)
            m.width.equalToSuperview()
        }
        
        // 가고싶다~사진올리기 버튼 및 라벨 올리기
        let want2goView = UIView()
        let want2goButton = UIButton()
        let want2goImageView = UIImageView()
        let want2goLabel = UILabel()
        
        middleButtonsView2.addSubview(want2goView)
        want2goView.snp.makeConstraints { (m) in
            m.top.leading.bottom.equalToSuperview()
            m.width.equalToSuperview().multipliedBy(0.25)
        }
        
        want2goView.addSubview(want2goButton)
        want2goButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        want2goButton.addTarget(self, action: #selector(want2goButtonTapped), for: .touchUpInside)
        
        want2goImageView.image = UIImage(named: "StarEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        want2goImageView.contentMode = .scaleAspectFit
        want2goView.addSubview(want2goImageView)
        want2goImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        want2goLabel.text = "가고싶다"
        want2goLabel.textColor = .orange
        want2goLabel.font = UIFont(name: "Helvetica", size: 13)
        want2goLabel.textAlignment = .center
        want2goView.addSubview(want2goLabel)
        want2goLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let checkInView = UIView()
        let checkInButton = UIButton()
        let checkInImageView = UIImageView()
        let checkInLabel = UILabel()
        
        middleButtonsView2.addSubview(checkInView)
        checkInView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(want2goView.snp.trailing)
            m.width.equalTo(middleButtonsView.snp.width).multipliedBy(0.25)
        }
        
        checkInView.addSubview(checkInButton)
        checkInButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        checkInImageView.image = UIImage(named: "CheckInEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: -2, bottom: 0, right: -2))
        checkInImageView.contentMode = .scaleAspectFit
        checkInView.addSubview(checkInImageView)
        checkInImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        checkInLabel.text = "체크인"
        checkInLabel.textColor = .orange
        checkInLabel.font = UIFont(name: "Helvetica", size: 13)
        checkInLabel.textAlignment = .center
        checkInView.addSubview(checkInLabel)
        checkInLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let writeReviewView = UIView()
        let writeReviewButton = UIButton()
        let writeReviewImageView = UIImageView()
        let writeReviewLabel = UILabel()
        
        middleButtonsView2.addSubview(writeReviewView)
        writeReviewView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(checkInView.snp.trailing)
            m.width.equalToSuperview().multipliedBy(0.25)
        }
        
        writeReviewView.addSubview(writeReviewButton)
        writeReviewButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        writeReviewButton.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
        
        writeReviewImageView.image = UIImage(named: "PenEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -9, left: -7, bottom: -5, right: -7))
        writeReviewImageView.contentMode = .scaleAspectFit
        writeReviewView.addSubview(writeReviewImageView)
        writeReviewImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        writeReviewLabel.text = "리뷰쓰기"
        writeReviewLabel.textColor = .orange
        writeReviewLabel.font = UIFont(name: "Helvetica", size: 13)
        writeReviewLabel.textAlignment = .center
        writeReviewView.addSubview(writeReviewLabel)
        writeReviewLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let uploadPicView = UIView()
        let uploadPicButton = UIButton()
        let uploadPicImageView = UIImageView()
        let uploadPicLabel = UILabel()
        
        middleButtonsView2.addSubview(uploadPicView)
        uploadPicView.snp.makeConstraints { (m) in
            m.top.bottom.equalToSuperview()
            m.leading.equalTo(writeReviewView.snp.trailing)
            m.width.equalToSuperview().multipliedBy(0.25)
        }
        
        uploadPicView.addSubview(uploadPicButton)
        uploadPicButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        uploadPicButton.addTarget(self, action: #selector(uploadPicButtonTapped), for: .touchUpInside)
        
        uploadPicImageView.image = UIImage(named: "CameraEmpty")?.withAlignmentRectInsets(UIEdgeInsets(top: -7, left: -5, bottom: 0, right: -5))
        uploadPicImageView.contentMode = .scaleAspectFit
        uploadPicView.addSubview(uploadPicImageView)
        uploadPicImageView.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.7)
        }
        
        uploadPicLabel.text = "사진올리기"
        uploadPicLabel.textColor = .orange
        uploadPicLabel.font = UIFont(name: "Helvetica", size: 13)
        uploadPicLabel.textAlignment = .center
        uploadPicView.addSubview(uploadPicLabel)
        uploadPicLabel.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
    }
    @objc private func want2goButtonTapped() {
        print("want2goButtonTapped")
    }
    @objc private func checkInButtonTapped() {
        print("checkInButtonTapped")
    }
    @objc private func writeReviewButtonTapped() {
        // 베이스 백그라운드 뷰(흐릿)
        view.addSubview(writeReviewBackgroundView)
        writeReviewBackgroundView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        writeReviewBackgroundView.backgroundColor = UIColor(white: 0.01, alpha: 0.9)
        
        // "리뷰 쓰기" 라벨
        let writeReviewLabel = UILabel()
        writeReviewBackgroundView.addSubview(writeReviewLabel)
        writeReviewLabel.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(40)
        }
        writeReviewLabel.text = "리뷰 쓰기"
        writeReviewLabel.textColor = .white
        writeReviewLabel.font = UIFont.systemFont(ofSize: 20)
        
        // x 버튼
        let xButtonOfWriteReview = UIButton()
        writeReviewBackgroundView.addSubview(xButtonOfWriteReview)
        xButtonOfWriteReview.snp.makeConstraints { (m) in
            m.top.centerY.equalTo(writeReviewLabel)
            m.width.height.equalTo(32)
            m.trailing.equalToSuperview().inset(20)
        }
        let xIcon = UIImage(named: "x")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        xButtonOfWriteReview.setImage(xIcon, for: .normal)
        xButtonOfWriteReview.tintColor = .white
        xButtonOfWriteReview.imageView?.contentMode = .scaleAspectFit
        xButtonOfWriteReview.addTarget(self, action: #selector(xButtonOfWriteReviewTapped), for: .touchUpInside)
        
        // 포토라이브러리 이미지뷰 세팅
        photoLibraryImageView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        writeReviewBackgroundView.addSubview(photoLibraryImageView)
        photoLibraryImageView.snp.makeConstraints { (m) in
            m.top.equalTo(writeReviewLabel.snp.bottom).offset(15)
            m.leading.equalToSuperview().offset(30)
            m.trailing.equalToSuperview().inset(30)
            m.height.equalToSuperview().multipliedBy(0.3)
        }
        
        // 맛있다! 괜찮다 별로 선택 뷰
        let rateSelectAndWriteView = UIView()
        writeReviewBackgroundView.addSubview(rateSelectAndWriteView)
        rateSelectAndWriteView.snp.makeConstraints { (m) in
            m.top.equalTo(photoLibraryImageView.snp.bottom).offset(15)
            m.leading.trailing.equalTo(photoLibraryImageView)
            m.height.equalToSuperview().multipliedBy(0.5)
        }
        rateSelectAndWriteView.backgroundColor = .white
        
        let goodButton = UIButton()
        let goodButtonLabel = UILabel()
        let sosoButton = UIButton()
        let sosoButtonLabel = UILabel()
        let badButton = UIButton()
        let badButtonLabel = UILabel()
        
        writeReviewBackgroundView.addSubview(goodButton)
        goodButton.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(10)
            m.leading.equalToSuperview().offset(10)
            m.width.height.equalTo(writeReviewBackgroundView.snp.width).multipliedBy(0.3)
        }
        writeReviewBackgroundView.addSubview(goodButtonLabel)
        
//
//        // 포토라이브러리 이미지뷰에서 바텀까지 centerY를 잡는 뷰
//        let centerYView = UIView()
//        uploadPicBackgroundView.addSubview(centerYView)
//        centerYView.snp.makeConstraints { (m) in
//            m.leading.trailing.equalToSuperview()
//            m.top.equalTo(photoLibraryImageView.snp.bottom)
//            m.bottom.equalToSuperview()
//        }
//
//        // 포토라이브러리 불러오기 버튼
//        let photoLibraryLoadButton = UIButton()
//        uploadPicBackgroundView.addSubview(photoLibraryLoadButton)
//        photoLibraryLoadButton.snp.makeConstraints { (m) in
//            m.leading.equalToSuperview().offset(40)
//            m.centerY.equalTo(centerYView)
//            m.width.equalTo(80)
//            m.height.equalTo(50)
//        }
//        photoLibraryLoadButton.setTitle("내 사진", for: .normal)
//        photoLibraryLoadButton.backgroundColor =  #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
//        photoLibraryLoadButton.addTarget(self, action: #selector(photoLibraryLoadButtonTapped), for: .touchUpInside)
//        photoLibraryLoadButton.layer.cornerRadius = 10
//
//        // 카메라 불러오기 버튼
//        let cameraLoadButton = UIButton()
//        uploadPicBackgroundView.addSubview(cameraLoadButton)
//        cameraLoadButton.snp.makeConstraints { (m) in
//            m.trailing.equalToSuperview().inset(40)
//            m.centerY.equalTo(centerYView)
//            m.width.equalTo(80)
//            m.height.equalTo(50)
//        }
//        cameraLoadButton.setTitle("카메라", for: .normal)
//        cameraLoadButton.backgroundColor =  #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
//        cameraLoadButton.addTarget(self, action: #selector(cameraLoadButtonTapped), for: .touchUpInside)
//        cameraLoadButton.layer.cornerRadius = 10
//
//        // 업로드 확정 버튼
//        let uploadButton = UIButton()
//        uploadPicBackgroundView.addSubview(uploadButton)
//        uploadButton.snp.makeConstraints { (m) in
//            m.centerY.equalTo(centerYView)
//            m.centerX.equalToSuperview()
//            m.width.height.equalTo(80)
//        }
//        let uploadImage = UIImage(named: "uploadCloud")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        uploadButton.setImage(uploadImage, for: .normal)
//        uploadButton.tintColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
//        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
//
    }
    @objc private func xButtonOfWriteReviewTapped() {  // 리뷰쓰기의 x버튼 실행 시
        let xButtonAlert = UIAlertController(title: nil, message: "현재 화면을 닫을 경우 리뷰가 더이상 업로드되지 않습니다", preferredStyle: .actionSheet)
        xButtonAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        xButtonAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
            self.writeReviewBackgroundView.removeFromSuperview()
            self.writeReviewBackgroundView.subviews.forEach { $0.removeFromSuperview() }
            self.photoLibraryImageView.image = nil
        }))
        self.present(xButtonAlert, animated: true)
    }
    @objc private func uploadPicButtonTapped() {
        // 베이스 백그라운드 뷰(흐릿)
        view.addSubview(uploadPicBackgroundView)
        uploadPicBackgroundView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        uploadPicBackgroundView.backgroundColor = UIColor(white: 0.01, alpha: 0.9)
        
        // 사진올리기 라벨
        let uploadPicLabel = UILabel()
        uploadPicBackgroundView.addSubview(uploadPicLabel)
        uploadPicLabel.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(40)
        }
        uploadPicLabel.text = "사진올리기"
        uploadPicLabel.textColor = .white
        uploadPicLabel.font = UIFont.systemFont(ofSize: 20)
        
        /// 이미지 업로드 부분(feat 강사님)
        //        Alamofire.upload(multipartFormData: {
        //            $0.append(<#T##data: Data##Data#>, withName: <#T##String#>)
        //        }, with: <#T##URLRequestConvertible#>, encodingCompletion: <#T##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##(SessionManager.MultipartFormDataEncodingResult) -> Void#>)
        ///
        
        // x 버튼
        let xButton = UIButton()
        uploadPicBackgroundView.addSubview(xButton)
        xButton.snp.makeConstraints { (m) in
            m.top.centerY.equalTo(uploadPicLabel)
            m.width.height.equalTo(32)
            m.trailing.equalToSuperview().inset(20)
        }
        let xIcon = UIImage(named: "x")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        xButton.setImage(xIcon, for: .normal)
        xButton.tintColor = .white
        xButton.imageView?.contentMode = .scaleAspectFit
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        
        // 포토라이브러리 이미지뷰 세팅
        photoLibraryImageView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        uploadPicBackgroundView.addSubview(photoLibraryImageView)
        photoLibraryImageView.snp.makeConstraints { (m) in
            m.top.equalTo(uploadPicLabel.snp.bottom).offset(30)
            m.centerX.equalToSuperview()
            m.width.height.equalTo(uploadPicBackgroundView).multipliedBy(0.7)
        }
        
        // 포토라이브러리 이미지뷰에서 바텀까지 centerY를 잡는 뷰
        let centerYView = UIView()
        uploadPicBackgroundView.addSubview(centerYView)
        centerYView.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.top.equalTo(photoLibraryImageView.snp.bottom)
            m.bottom.equalToSuperview()
        }
        
        // 포토라이브러리 불러오기 버튼
        let photoLibraryLoadButton = UIButton()
        uploadPicBackgroundView.addSubview(photoLibraryLoadButton)
        photoLibraryLoadButton.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(40)
            m.centerY.equalTo(centerYView)
            m.width.equalTo(80)
            m.height.equalTo(50)
        }
        photoLibraryLoadButton.setTitle("내 사진", for: .normal)
        photoLibraryLoadButton.backgroundColor =  #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        photoLibraryLoadButton.addTarget(self, action: #selector(photoLibraryLoadButtonTapped), for: .touchUpInside)
        photoLibraryLoadButton.layer.cornerRadius = 10
        
        // 카메라 불러오기 버튼
        let cameraLoadButton = UIButton()
        uploadPicBackgroundView.addSubview(cameraLoadButton)
        cameraLoadButton.snp.makeConstraints { (m) in
            m.trailing.equalToSuperview().inset(40)
            m.centerY.equalTo(centerYView)
            m.width.equalTo(80)
            m.height.equalTo(50)
        }
        cameraLoadButton.setTitle("카메라", for: .normal)
        cameraLoadButton.backgroundColor =  #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        cameraLoadButton.addTarget(self, action: #selector(cameraLoadButtonTapped), for: .touchUpInside)
        cameraLoadButton.layer.cornerRadius = 10
        
        // 업로드 확정 버튼
        let uploadButton = UIButton()
        uploadPicBackgroundView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { (m) in
            m.centerY.equalTo(centerYView)
            m.centerX.equalToSuperview()
            m.width.height.equalTo(80)
        }
        let uploadImage = UIImage(named: "uploadCloud")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        uploadButton.setImage(uploadImage, for: .normal)
        uploadButton.tintColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
    }
    @objc private func xButtonTapped() { // 사진 올리기의 x 버튼 눌렀을 때 디스미스
        let xButtonAlert = UIAlertController(title: nil, message: "현재 화면을 닫을 경우 사진이 더이상 업로드되지 않습니다", preferredStyle: .actionSheet)
        xButtonAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        xButtonAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
            self.uploadPicBackgroundView.removeFromSuperview()
            self.uploadPicBackgroundView.subviews.forEach { $0.removeFromSuperview() }
            self.photoLibraryImageView.image = nil
        }))
        self.present(xButtonAlert, animated: true)
    }
    @objc func photoLibraryLoadButtonTapped() { // 포토라이브러리 불러오기
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func cameraLoadButtonTapped() {
        print("camera light action")
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func uploadButtonTapped() { // --> 업로드 버튼 탭!!!
        let uploadButtonAlert = UIAlertController(title: nil, message: "사진을 올리시겠습니까?", preferredStyle: .actionSheet)
        uploadButtonAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        uploadButtonAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
            // 컨펌 했을 때 액션
            
            
            ////////
            self.uploadPicBackgroundView.removeFromSuperview()
            self.uploadPicBackgroundView.subviews.forEach { $0.removeFromSuperview() }
            self.photoLibraryImageView.image = nil
            
            let uploadConfirmAlert = UIAlertController(title: nil, message: "완료 되었습니다.", preferredStyle: .alert)
            self.present(uploadConfirmAlert, animated: true)
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                uploadConfirmAlert.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(uploadButtonAlert, animated: true)
    }
    private func youTubeWebView() {
        guard let youTubeUrl = selectedColumnData?.youTubeUrl else { return }  // 유튜브 URL에 "youtube" 포함되어 있으면이 유튜브 플레이어 표시, 없으면 높이 1 스크롤 가이드뷰를 생성
        
        if youTubeUrl.contains("youtube") {
            scrollGuideView.addSubview(youTubeView)
            youTubeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleButtonsView.snp.bottom).offset(10)
                m.width.leading.equalToSuperview()
                m.height.equalTo(200)
            }
            youTubeView.playerVars = ["playsinline": 1 as AnyObject]  // 전체화면 아닌 해당 페이지에서 플레이
            let myVideoURL = NSURL(string: youTubeUrl)
            
            DispatchQueue.main.async {
                self.youTubeView.loadVideoURL(myVideoURL! as URL)
            }
        } else {
            scrollGuideView.addSubview(youTubeView)
            youTubeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleButtonsView.snp.bottom)
                m.width.leading.equalToSuperview()
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
        guard let addressDetail = selectedColumnData?.address else { return }
        addressLabel.text = addressDetail
        addressLabel.textColor = .gray
        
        // 맵뷰 마커 설정
        let marker = GMSMarker()
        guard let latitude = selectedColumnData?.latitude else { return }
        guard let longitude = selectedColumnData?.longitude else { return }
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "\(selectedColumnData?.name ?? "여긴 어디지요?")"
        marker.icon = UIImage(named: "MapMarkerImage")
        marker.map = mapView
        mapView.isMyLocationEnabled = false
        mapView.settings.scrollGestures = false
        
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
        let dateString = selectedColumnData!.modifiedAt ?? "^^"  // 서버에서 받는 날짜 정보(String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"  // 서버에서 받는 날짜 포멧 통보
        let dateReal = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd" // 내가 쓰고 싶은 날짜 포멧 지정
        modifiedAtLabel.text = "마지막 업데이트: \(dateFormatter.string(from: dateReal!))"
        modifiedAtLabel.textAlignment = .right
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
        
        // 메뉴
        guard let menuText = selectedColumnData?.menuText else { return }
        if menuText != "" { // 메뉴 텍스트가 "" 가 아닐때(메뉴 정보가 있을 때)
          let menuLabel = UILabel() // "메뉴 텍스트" 콘피그
            restaurantInfoAndMenuView.addSubview(menuLabel)
            menuLabel.snp.makeConstraints { (m) in
                m.top.equalTo(moreInfoButton.snp.bottom)
                m.leading.equalToSuperview().offset(10)
                m.width.equalTo(80)
                m.height.equalTo(25)
            }
            menuLabel.text = "메뉴"
            menuLabel.textColor = .darkGray
            menuLabel.font = UIFont.boldSystemFont(ofSize: 17)
            
            // 메뉴 텍스트의 음식과 가격을 분리
            let menuTextArr = menuText.components(separatedBy: " ")
            let menuTextArrCount = menuTextArr.count
            var menuNameData: String = ""
            
            for i in 0..<menuTextArrCount-1 { // 메뉴(마지막에서 두번째 배열까지)와 가격(마지막 배열)
                menuNameData += menuTextArr[i]
            }
            let menuPriceData = menuTextArr.last ?? "업데이트중"
            
            // 메뉴 이름 라벨
            let menuNameLabel = UILabel()
            restaurantInfoAndMenuView.addSubview(menuNameLabel)
            menuNameLabel.snp.makeConstraints { (m) in
                m.top.equalTo(menuLabel.snp.bottom)
                m.leading.equalTo(restaurantInfoLabel)
                m.width.equalTo(80)
                m.height.equalTo(25)
            }
            menuNameLabel.text = "메뉴"
            menuNameLabel.textColor = .gray
            menuNameLabel.font = UIFont(name: "Helvetica", size: 15)
            menuNameLabel.textAlignment = .left
            menuNameLabel.text = "\(menuNameData)"
            
            // 메뉴 가격 라벨
            let menuPriceLabel = UILabel()
            restaurantInfoAndMenuView.addSubview(menuPriceLabel)
            menuPriceLabel.snp.makeConstraints { (m) in
                m.top.equalTo(menuLabel.snp.bottom)
                m.trailing.equalToSuperview().inset(10)
                m.width.equalTo(80)
                m.height.equalTo(25)
            }
            menuPriceLabel.textColor = .gray
            menuPriceLabel.font = UIFont(name: "Helvetica", size: 15)
            menuPriceLabel.textAlignment = .right
            menuPriceLabel.text = "\(menuPriceData)"
        }
    }
    @objc private func moreInfoButtonTapped() {
        // 선택된 셀의 컬럼 데이터를 넘겨버림
        let destination = PlateMoreInfoViewController()
        destination.selectedColumnData = selectedColumnData
        
        // "정보 더 보기" 버튼 탭
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
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
        guard let postCount = selectedColumnData?.postArray.count else { return }
        majorReviewLabel.text = "주요 리뷰 (\(postCount))"
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
        
        guard let goodCount = selectedColumnData?.rateGood else { return }
        goodButtonLabel.text = "맛있다! (\(goodCount))"
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
        
        guard let sosoCount = selectedColumnData?.rateNormal else { return }
        sosoButtonLabel.text = "괜찮다 (\(sosoCount))"
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
        
        guard let badCount = selectedColumnData?.rateBad else { return }
        badButtonLabel.text = "별로 (\(badCount))"
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
        let destination = ReviewOnlyViewController()
        destination.selectedColumnData = selectedColumnData
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 5 }) {
            destination.selectedRatePostArray = tempArray
            destination.selectedRate = "5"
        } else {
            destination.selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
            destination.selectedRate = "0"
        }
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
    @objc private func sosoButtonTapped() {
        let destination = ReviewOnlyViewController()
        destination.selectedColumnData = selectedColumnData
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 3 }) {
            destination.selectedRatePostArray = tempArray
            destination.selectedRate = "3"
        } else {
            destination.selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
            destination.selectedRate = "0"
        }
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
    @objc private func badButtonTapped() {
        let destination = ReviewOnlyViewController()
        destination.selectedColumnData = selectedColumnData
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 1 }) {
            destination.selectedRatePostArray = tempArray
            destination.selectedRate = "1"
        } else {
            destination.selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
            destination.selectedRate = "0"
        }
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
    private func reviewTableViewConfig() {
        // reviewTableView Setting
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewCell")
        
        // 테이블뷰 레이아웃 설정
        scrollGuideView.addSubview(reviewTableView)
        reviewTableView.snp.makeConstraints { (m) in
            m.top.equalTo(majorReviewAndButtonView.snp.bottom).offset(10)
            m.leading.equalToSuperview().offset(10)
            m.trailing.equalToSuperview().inset(10)
            m.height.equalTo(300)
        }
    }
    private func moreReviewViewConfig() {
        scrollGuideView.addSubview(moreReviewView)
        moreReviewView.snp.makeConstraints { (m) in
            m.height.equalTo(17)
            m.width.equalToSuperview().multipliedBy(0.5)
            m.trailing.equalToSuperview().inset(15)
            m.bottom.equalToSuperview().inset(20)
        }
        
        let moreReviewButton = UIButton()
        moreReviewView.addSubview(moreReviewButton)
        moreReviewButton.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        moreReviewButton.setTitle("리뷰 더 보기 ❯", for: .normal)
        moreReviewButton.setTitleColor(#colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1), for: .normal)
        moreReviewButton.contentHorizontalAlignment = .trailing
        moreReviewButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        moreReviewButton.addTarget(self, action: #selector(moreReviewButtonTapped), for: .touchUpInside)
    }
    @objc private func moreReviewButtonTapped() {
        let destination = ReviewOnlyViewController()
        destination.selectedColumnData = selectedColumnData
        
        if let tempArray = selectedColumnData?.postArray {
            destination.selectedRatePostArray = tempArray
            destination.selectedRate = "0"
        } else {
            destination.selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
            destination.selectedRate = "0"
        }
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
}
extension PlateViewController: UICollectionViewDelegate {
    // 상단 리뷰 이미지 콜렉션뷰 터치시 액션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ReviewDetailViewController()
        destination.selectedColumnData = selectedColumnData
        
        let selectedImageUrl = reviewImageUrlArray[indexPath.row]
        let postArrayCount = selectedColumnData?.postArray.count ?? 0
        
        for i in 0..<postArrayCount {
            let reviewImageCount = selectedColumnData?.postArray[i].reviewImage?.count ?? 0
            
            for j in 0..<reviewImageCount {
                if selectedImageUrl == selectedColumnData?.postArray[i].reviewImage?[j].reviewImageUrl {
                    guard let tempArray = selectedColumnData?.postArray[i] else { return }
                    destination.selectedPostData = tempArray
                }
            }
        }
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
}
extension PlateViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    // 콜렉션뷰 열간 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(2)
    }
}
extension PlateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImageUrlArray.count
    }
    // 셀에 이미지 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plateCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlateCollectionViewCell
        
        if let url = URL(string: reviewImageUrlArray[indexPath.item]) {
            cell.restaurantPicture.kf.setImage(with: url)
        } else {
            cell.restaurantPicture.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
}
extension PlateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let postCount = selectedColumnData?.postArray.count else { return 0 }
        return postCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = .none  // 터치해도 색 변하지 않음
        
        // 리뷰어 프로필 사진 가져오기
        if let urlString = selectedColumnData?.postArray[indexPath.row].author.authorImage,
            let url = URL(string: urlString) {
            cell.authorImageView.kf.setImage(with: url)
        } else {
            cell.authorImageView.image = UIImage(named: "defaultImage")
        }
        
        // 리뷰어 이름 가져오기
        cell.authorName.text = selectedColumnData?.postArray[indexPath.row].author.authorName
        
        switch selectedColumnData?.postArray[indexPath.row].reviewRate {
        case 1:
            cell.reviewRate.image = UIImage(named: "BadFace")
            cell.reviewRateLabel.text = "별로"
        case 3:
            cell.reviewRate.image = UIImage(named: "SosoFace")
            cell.reviewRateLabel.text = "괜찮다"
        case 5:
            cell.reviewRate.image = UIImage(named: "GoodFace")
            cell.reviewRateLabel.text = "맛있다!"
        default:
            print("평가 이상")
        }
        
        // 리뷰 내용
        cell.reviewContent.text = selectedColumnData?.postArray[indexPath.row].reviewContent
        
        // 리뷰 이미지
        let reviewImageUrl: String
        if let post = selectedColumnData?.postArray[indexPath.row],
            let reviewImage = post.reviewImage,
            !reviewImage.isEmpty {
            reviewImageUrl = reviewImage[0].reviewImageUrl
        } else {
            reviewImageUrl = "defaultImage"
        }
        
        if let url = URL(string: reviewImageUrl) {
            cell.reviewContentImage.kf.setImage(with: url)
        } else if reviewImageUrl == "defaultImage" {
            cell.reviewContentImage.image = UIImage(named: "defaultImage")
        } else {
            cell.reviewContentImage.image = UIImage(named: "defaultImage")
        }
        return cell
    }
}
extension PlateViewController: UITableViewDelegate {
    // 리뷰 테이블 뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    // 리뷰 터치시 액션
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 컬럼 데이터를 넘겨버림
        let destination = ReviewDetailViewController()
        destination.selectedColumnData = selectedColumnData
        destination.selectedPostData = selectedColumnData?.postArray[indexPath.row]
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil)
    }
}
extension PlateViewController: UIScrollViewDelegate {
    // 스크롤시 topGuideView의 색 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return } // 스크롤뷰(자기자신)만 반응하도록 설정. 테이블뷰는 반응하지 않음
        
        let currentPositionY = scrollView.contentOffset.y
        
        //        let point = CGPoint(x: 0, y: currentPositionY) // 콜렉션뷰의 와이 위치가 겹치면 트루(feat.강사님)
        //        print(middleInfoBarView.point(inside: point, with: nil))
        
        if middleInfoBarView.frame.minY < currentPositionY &&
            middleInfoBarView.frame.minY + 30 > currentPositionY {
            
            // topGuideView 배경색, 맛집 이름색 변경
            let alphaData = (1 / 30) * (currentPositionY - middleInfoBarView.frame.minY)
            topGuideView.backgroundColor = UIColor(red: 0.976802, green: 0.47831, blue: 0.170915, alpha: alphaData)
            restaurantNameLabelOnTop.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: alphaData)
        }
        
        // downArrow, topGuideView 2차색 변경(상기로는 빠른 스크롤시 색이 미쳐 바뀌지 않음)
        if currentPositionY > middleInfoBarView.frame.minY + 30 {
            topGuideView.backgroundColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
            downArrow.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            restaurantNameLabelOnTop.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if currentPositionY < middleInfoBarView.frame.minY {
            topGuideView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            downArrow.tintColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
            restaurantNameLabelOnTop.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        }
        
        // 일정 위치에서 middleButtonView2를 생성, 소멸 시킴
        if currentPositionY > middleButtonsView.frame.minY - 5 && middleButtonsView2IsOn == false {
            middleButtonsViewConfig2()
        } else if currentPositionY < middleButtonsView.frame.minY - 5 && middleButtonsView2IsOn == true {
            middleButtonsView2.removeFromSuperview()
            middleButtonsView2.subviews.forEach{ $0.removeFromSuperview() }
            middleButtonsView2IsOn = false
        }
    }
}
extension PlateViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            photoLibraryImageView.contentMode = .scaleAspectFit
            photoLibraryImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

