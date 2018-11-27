//
//  ViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 11/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let currentPlaceGuideLabel = UILabel()
    let currentPlaceButton = UIButton()
    let adScrollView = UIScrollView()
    var adImagesArray = [UIImage]()
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellData().arrayOfCellData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPlaceLabelButtonConfig()
        adScrollViewConfig()
        mainCollectionViewConfig()
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
        currentPlaceButton.setTitle("용산/숙대 ∨", for: .normal)
        currentPlaceButton.setTitleColor(.black, for: .normal)
    }
    private func adScrollViewConfig() {
        // 횡스크롤 배너
        view.addSubview(adScrollView)
        adScrollView.frame = CGRect(x: view.frame.origin.x, y: currentPlaceButton.bounds.maxY + 100, width: view.frame.width, height: 120)
        adScrollView.showsHorizontalScrollIndicator = false // 횡스크롤바 없음
        adScrollView.backgroundColor = .gray
        adScrollView.isPagingEnabled = true
        
        // 횡스크롤 배너에 이미지 넣기
        adImagesArray = [#imageLiteral(resourceName: "sunset-1645103_1280"), #imageLiteral(resourceName: "banner-1686943_1280"), #imageLiteral(resourceName: "banner-1018818_1280")]
        for i in 0..<adImagesArray.count {
            let adView = UIImageView()
            adView.contentMode = .scaleToFill
            adView.image = adImagesArray[i]
            
            let xPosition = view.frame.width * CGFloat(i)
            adView.frame = CGRect(x: xPosition, y: adScrollView.bounds.origin.y, width: adScrollView.frame.width, height: adScrollView.frame.height)
            adScrollView.contentSize.width = adScrollView.frame.width * CGFloat((i + 1))
            
            adScrollView.addSubview(adView)
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
