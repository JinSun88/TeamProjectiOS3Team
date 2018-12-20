//
//  WantToGoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 13/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class WantToGoViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var userWantToGoData = ServerStruct.CellDataStruct.self
    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
    var wantToGoArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        mainCollectionViewConfig()
        getUserData()
        getRestaurantData()

    }
    
    private func getUserData() {
        guard let wantToGoCount = UserData.shared.userCellData?.user.wannaGo?.count else { return }
        for i in 0..<wantToGoCount {
            wantToGoArray.append(UserData.shared.userCellData?.user.wannaGo?[i].restaurant ?? 0)
        }
            }
    
    private func getRestaurantData(){
        
        guard let wantToGoCount = UserData.shared.userCellData?.user.wannaGo?.count else { return }
        print("count:", wantToGoCount)
        print("array:", wantToGoArray)
        for i in 0..<wantToGoCount {
            let url = "https://api.fastplate.xyz/api/restaurants/list/\(wantToGoArray[i])"
            Alamofire.request(url, method: .get)
            .validate()
                .responseData{ (response) in
                    switch response.result {
                    case .success(let value):
                        let results = try! JSONDecoder().decode(self.userWantToGoData, from: value)
                        self.arrayOfCellData.append(results)
                        self.mainCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
        }

        
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
            
            guard let url = URL(string: imageUrlArray.first ?? "nil") else { return cell}
            cell.restaurantPicture.kf.setImage(with: url)
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

extension WantToGoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row] // 선택된 셀의 컬럼 데이터를 넘겨버림
        present(destination, animated: true)  // 플레이트뷰 컨트롤러를 띄움
    }
    
}
