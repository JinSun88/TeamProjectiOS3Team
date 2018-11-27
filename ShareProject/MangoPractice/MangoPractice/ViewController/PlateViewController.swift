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

final class PlateViewController: UIViewController {
    
    // 각 인스턴스를 밖에서 만들어 주는 이유는 Auto레이아웃을 잡아주기 위함입니다. (안에 만들면 각각 참조가 안됨)
    let scrollView = UIScrollView()
    let scrollGuideView = UIView() // 스크롤뷰 위에 올리는 가이드뷰(필수 덕목)
    let topGuideView = UIView()
    let downArrow = UIButton()
    var plateCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellData().arrayOfCellData
    var selectedColumnData: CellDataStruct?
    let middleInfoBarView = UIView()
    let middleButtonsView = UIView() // 가고싶다~사진올리기 버튼들을 올리는 뷰
    let want2goButton = UIButton()
    let want2goLabel = UILabel()
    let checkInButton = UIButton()
    let checkInLabel = UILabel()
    let writeReviewButton = UIButton()
    let writeReviewLabel = UILabel()
    let uploadPicButton = UIButton()
    let uploadPicLabel = UILabel()
    let youTube = YouTubePlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        topGuideViewConfig()
        scrollViewConfig()
        downArrowConfig()
        plateCollectionViewConfig()
        middleInfoBarConfig()
        middleButtonLabelConfig()
        youTubeWebView()
    }
    private func topGuideViewConfig() {
        // 가장위에 라벨(topGuideView) 작성, 위치 잡기
        topGuideView.backgroundColor = .lightGray
        view.addSubview(topGuideView)
        topGuideView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide)
            m.width.equalToSuperview()
            m.height.equalTo(80)
        }
    }
    private func downArrowConfig() {
        // topGuideLabel 위에 DownArrow 버튼 설정
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
    private func scrollViewConfig(){
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
            $0.height.equalTo(1200)  // 스크롤뷰의 높이를 설정
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
    private func middleInfoBarConfig(){
        let restaurantNameLabel = UILabel()
        let restaurantViewFeedCountLabel = UILabel()
        let restaurantGradePointLabel = UILabel()
        
        //        middleInfoBarView.backgroundColor = .darkGray
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
        restaurantViewFeedCountLabel.text = selectedColumnData?.viewFeedCount
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
        restaurantGradePointLabel.text = String(selectedColumnData!.gradePoint)
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
    private func middleButtonsViewConfig(){
        middleButtonsView.backgroundColor = .lightGray
        scrollGuideView.addSubview(middleButtonsView)
        middleButtonsView.snp.makeConstraints { (m) in
            m.top.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }
        
    }
    private func middleButtonLabelConfig(){
        
        want2goButton.setImage(#imageLiteral(resourceName: "cooking-dinner-food-76093"), for: .normal)
        scrollGuideView.addSubview(want2goButton)
        want2goButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom)
            m.leading.equalToSuperview()
            m.width.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.25)
        }

        want2goLabel.text = "가고싶다"
        want2goLabel.textColor = .orange
        want2goLabel.textAlignment = .center
        scrollGuideView.addSubview(want2goLabel)
        want2goLabel.snp.makeConstraints {
            $0.top.equalTo(want2goButton.snp.bottom)
            $0.width.equalTo(want2goButton)
        }
        
        checkInButton.setImage(#imageLiteral(resourceName: "burrito-chicken-close-up-461198"), for: .normal)
        scrollGuideView.addSubview(checkInButton)
        checkInButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom)
            m.leading.equalTo(want2goButton.snp.trailing)
            m.width.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.25)
        }
        
        checkInLabel.text = "체크인"
        checkInLabel.textColor = .orange
        checkInLabel.textAlignment = .center
        scrollGuideView.addSubview(checkInLabel)
        checkInLabel.snp.makeConstraints {
            $0.top.equalTo(checkInButton.snp.bottom)
            $0.leading.equalTo(checkInButton)
            $0.width.equalTo(checkInButton)
        }
        
        writeReviewButton.setImage(#imageLiteral(resourceName: "sunset-1645103_1280"), for: .normal)
        scrollGuideView.addSubview(writeReviewButton)
        writeReviewButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom)
            m.leading.equalTo(checkInButton.snp.trailing)
            m.width.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.25)
        }
        
        writeReviewLabel.text = "리뷰쓰기"
        writeReviewLabel.textColor = .orange
        writeReviewLabel.textAlignment = .center
        scrollGuideView.addSubview(writeReviewLabel)
        writeReviewLabel.snp.makeConstraints {
            $0.top.equalTo(writeReviewButton.snp.bottom)
            $0.leading.equalTo(writeReviewButton)
            $0.width.equalTo(writeReviewButton)
        }
        
        uploadPicButton.setImage(#imageLiteral(resourceName: "banner-1686943_1280"), for: .normal)
        scrollGuideView.addSubview(uploadPicButton)
        uploadPicButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom)
            m.leading.equalTo(writeReviewButton.snp.trailing)
            m.width.height.equalTo(scrollGuideView.snp.width).multipliedBy(0.25)
        }
        
        uploadPicLabel.text = "사진올리기"
        uploadPicLabel.textColor = .orange
        uploadPicLabel.textAlignment = .center
        scrollGuideView.addSubview(uploadPicLabel)
        uploadPicLabel.snp.makeConstraints {
            $0.top.equalTo(uploadPicButton.snp.bottom)
            $0.leading.equalTo(uploadPicButton)
            $0.width.equalTo(uploadPicButton)
        }
        
    }
    private func youTubeWebView() {
        // 유튜브 URL이 없으면 진행하지 않도록 처리 필요
        scrollGuideView.addSubview(youTube)
        youTube.snp.makeConstraints { (m) in
            m.top.equalTo(want2goLabel.snp.bottom).offset(10)
            m.width.leading.equalToSuperview()
            m.height.equalTo(200)
        }
        
        youTube.playerVars = ["playsinline": 1 as AnyObject] // 전체화면 아닌 해당 페이지에서 플레이
        let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=jJt2Wunh5d4")
        youTube.loadVideoURL(myVideoURL! as URL)
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
        return selectedColumnData?.image.count ?? 0
        //        return arrayOfCellData.filter { $0.pk == pk }.first?.image.count ?? 0 // 고차함수 사용예 (pk는 유닉한 값)
    }
    // 셀에 이미지 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plateCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlateCollectionViewCell
        cell.restaurantPicture.image = selectedColumnData?.image[indexPath.item]
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
