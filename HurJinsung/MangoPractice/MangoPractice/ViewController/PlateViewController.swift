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
    var pk = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        topGuideViewConfig()
        downArrowConfig()
        plateCollectionViewConfig()
        
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
        plateCollectionView.backgroundColor = .gray
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
            m.height.equalTo(120)
        }
    }
}

extension PlateViewController: UISearchControllerDelegate {
    // 터치시 이동할 내용 들어갈 예정
}

extension PlateViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
}

extension PlateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plateCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlateCollectionViewCell
        
        print(pk)
        
        for i in arrayOfCellData {
            if i.pk == pk {
               cell.restaurantPicture.image = i.image[indexPath.row]
            }
        }
        
//        for i in arrayOfCellData {
//            if i.pk == pk {
//                for a in 0..<i.image.count {
//                    cell.restaurantPicture.image = i.image[a]
//                }
//            }
//        }
//        for image in arrayOfCellData[pk].image {
//            cell.restaurantPicture.image = image
//        }
        return cell
    }
}

