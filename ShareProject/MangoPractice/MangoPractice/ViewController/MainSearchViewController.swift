//
//  MainSearchViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 20/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import Alamofire

class MainSearchViewController: UIViewController {
    let topView = UIView()
    let backButton = UIBarButtonItem()
    let searchController = UISearchController(searchResultsController: nil)
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
    var searchActive: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionViewConfig()
        searchControllerSetUp()
    }
    
    
    
    private func mainCollectionViewConfig() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.backgroundColor = .white
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        mainCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            //            $0.top.equalTo(topView.snp.bottom)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func searchControllerSetUp() {
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "키워드로 검색해보세요."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
        
    }
    
}

extension MainSearchViewController: UICollectionViewDelegateFlowLayout {
    // 콜렉션뷰 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2, height: collectionView.frame.width / 1.7)  // collectionView.frame.height / 1.8
    }
    // 콜렉션뷰 셀의 안쪽 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    // 콜렉션뷰 셀의 미니멈 행간 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    // 콜렉션뷰 셀의 미니멈 열간 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
}

extension MainSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCellData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        
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

extension MainSearchViewController: UICollectionViewDelegate {
    // 콜렉션셀을 터치하면 상세페이지(PlateViewController)로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt indexPath")
        searchController.dismiss(animated: false)
        
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row] // 선택된 셀의 컬럼 데이터를 넘겨버림
        present(destination, animated: true)  // 플레이트뷰 컨트롤러를 띄움
    }
    
    
}

extension MainSearchViewController: UISearchControllerDelegate {
    
    
}


extension MainSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        if searchController.isActive {
            self.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
        mainCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        
        let searchString = searchController.searchBar.text!
        
        
        let url = "https://api.fastplate.xyz/api/restaurants/list/?page=1&ordering=-rate_average&search="
        let param: Parameters = [
            "search" : searchString
        ]
        Alamofire.request(url, method: .get, parameters: param)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    let result = try! JSONDecoder().decode(ServerStruct.self, from: value)
                    self.arrayOfCellData = result.results
                    print(self.arrayOfCellData)
                    self.mainCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            mainCollectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
}




