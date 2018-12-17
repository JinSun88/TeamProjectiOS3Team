//
//  SearchViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 14/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let searchBar = UISearchBar(frame: CGRect.zero) //서치바
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
    var filtered: [String] = []
    var searchActive: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewWillAppear(_ animated: Bool) {
        arrayOfCellData = CellData.shared.arrayOfCellData
        // 데이터 저장용
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        topViewConfig()
        //        searchBarConfig()
        mainCollectionViewConfig()
        searchControllerSetUp()
    }
    
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
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
        
    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func searchBarConfig() {
        topView.addSubview(searchBar)
        
        searchBar.placeholder = "키워드로 검색해보세요."
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal // 서치바 경계 안생기도록
        
        
        searchBar.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.top.height.equalTo(backButton)
            $0.trailing.equalTo(topView.snp.trailing)
        }
        
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
        searchController.searchResultsUpdater = self
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "키워드로 검색해보세요."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
        
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController: UICollectionViewDataSource {
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if searchActive {
            return filtered.count
        } else {
            return arrayOfCellData.count
        }
    }
    
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    // 콜렉션셀을 터치하면 상세페이지(PlateViewController)로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = PlateViewController()
        destination.selectedColumnData = arrayOfCellData[indexPath.row] // 선택된 셀의 컬럼 데이터를 넘겨버림
        //  destination.pk = arrayOfCellData[indexPath.row].pk    // 선택한 셀의 pk값을 저장
        present(destination, animated: true)  // 플레이트뷰 컨트롤러를 띄움
    }
    
    // 콜렉션 셀이 하단으로 이동하면 다음 페이지 데이터를 가져옴
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == arrayOfCellData.count - 1 {
            CellData.shared.getNextPageDataFromServer(collectionView)
            arrayOfCellData = CellData.shared.arrayOfCellData
        }
    }
    
}

extension SearchViewController: UISearchControllerDelegate {
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        return print("apple")
    }
    
    //    func updateSearchResults(for searchController: UISearchController) {
    //        let searchString = searchController.searchBar.text
    //
    //        filtered = item.filter({ (item) -> Bool in
    //            let countryText: NSString = item as NSString
    //
    //            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
    //        })
    //
    //        mainCollectionView.reloadData()
    //    }
    //
    //
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
        mainCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        mainCollectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            mainCollectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
}


