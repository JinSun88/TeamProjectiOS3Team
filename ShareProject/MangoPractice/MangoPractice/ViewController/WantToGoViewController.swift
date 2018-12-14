//
//  WantToGoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 13/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class WantToGoViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData = CellDataOrigin().arrayOfCellData //임시로 하드코딩 데이터 삽입


    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        mainCollectionViewConfig()

    }
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "가고싶다"
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 9)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(topView)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(topView).dividedBy(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.height.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.width.equalTo(150)
        }
        
    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func mainCollectionViewConfig() {
        view.addSubview(mainCollectionView)
        mainCollectionView.backgroundColor = .white
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(WantToGoCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
extension WantToGoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2, height: collectionView.frame.width / 1.7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
}


extension WantToGoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! WantToGoCollectionViewCell
        
        cell.restaurantPicture.image = UIImage(named: "blur-breakfast-close-up-376464") // 임시 디폴트 이미지
        cell.rankingName.text = "\(arrayOfCellData[indexPath.row].name)"
        cell.gradePoint.text = "\(arrayOfCellData[indexPath.item].gradePoint)"
        cell.restaurantLocation.text = "\(arrayOfCellData[indexPath.row].location)"
        cell.viewFeedCount.text = "\(arrayOfCellData[indexPath.item].viewFeedCount)"
        
        
        return cell
    }
    
    
}

extension WantToGoViewController: UICollectionViewDelegate {
    
}
