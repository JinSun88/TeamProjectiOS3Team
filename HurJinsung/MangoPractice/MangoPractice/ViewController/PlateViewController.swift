//
//  PlateViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

final class PlateViewController: UIViewController {
    
    let topGuideView = UIView()
    let downArrow = UIButton()
    var plateCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellData().arrayOfCellData
    var selectedColumnData: CellDataStruct?
    let middleInfoBarView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        topGuideViewConfig()
        downArrowConfig()
        plateCollectionViewConfig()
        middleInfoBarConfig()
        middleButtonLabelConfig()
        
    }
    private func topGuideViewConfig() {
        // 가장위에 라벨(topGuideView) 작성, 위치 잡기
        topGuideView.backgroundColor = .darkGray
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
        view.addSubview(plateCollectionView)
        plateCollectionView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom).offset(10)
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(150)
        }
    }
    private func middleInfoBarConfig(){
        let restaurantNameLabel = UILabel()
        let restaurantViewFeedCountLabel = UILabel()
        let restaurantGradePointLabel = UILabel()
        
//        middleInfoBarView.backgroundColor = .darkGray
        view.addSubview(middleInfoBarView)
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
    private func middleButtonLabelConfig(){
        
        let want2goButton = UIButton()
        let want2goLabel = UILabel()
        let checkInButton = UIButton()
        let checkInLabel = UILabel()
        let writeReviewButton = UIButton()
        let writeReviewLabel = UILabel()
        let uploadPicButton = UIButton()
        let uploadPicLabel = UILabel()
        
        want2goButton.backgroundColor = .red
        want2goButton.setImage(#imageLiteral(resourceName: "cooking-dinner-food-76093"), for: .normal)
        view.addSubview(want2goButton)
        want2goButton.snp.makeConstraints { (m) in
            m.top.equalTo(middleInfoBarView.snp.bottom).offset(10)
            m.leading.equalToSuperview().offset(10)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.height.equalTo(600)
        }
        
        
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
