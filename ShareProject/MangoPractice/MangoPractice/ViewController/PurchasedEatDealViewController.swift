//
//  PurchasedEatDealViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 13/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class PurchasedEatDealViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    var mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
//    var arrayOfCellData = CellDataOrigin().arrayOfCellData //임시로 하드코딩 데이터 삽입
    var result: [Result] = []
    var images: [Eatdealimage] = []
    var urls = [String]()
    var nextViewImage: UIImage?


    

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        mainCollectionViewConfig()
        getData()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "구매한 EAT딜"
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
        
        mainCollectionView.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(PurchasedEatDealCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        
        mainCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
    }
    
    private func getData() {
        let url = URL(string: "https://fastplate.xyz/api/eatdeals/list/")!
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let jsonObject =  try! JSONDecoder().decode(EatDealData.self, from: data)
            self.result = jsonObject.results
            
            for i in jsonObject.results.makeIterator() {
                self.images.append(contentsOf: i.eatdealimages)
            }
            
            for i in self.images.makeIterator() {
                self.urls.append(i.image)
            }
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
        dataTask.resume()
        
    }
}
extension PurchasedEatDealViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    // 셀간 간격 주기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // 맨 위랑 아래 살짝 떼기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right:0)
    }

}

extension PurchasedEatDealViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! PurchasedEatDealCollectionViewCell
        cell.subNameLabel.text = result[indexPath.row].subName
        cell.nameLabel.text = result[indexPath.row].dealName
        cell.priceLabel.text = "￦\(result[indexPath.row].discountPrice.withComma)"
        cell.dateLabel.text = "2018-12-21~2019-03-07"
        
        guard let url = URL(string: urls[indexPath.row]) else { return cell }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        task.resume()
        
        return cell
    }
    
    
}

extension PurchasedEatDealViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: urls[indexPath.row]) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.nextViewImage = image
            
        }
        task.resume()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eatSelectedViewController = storyboard.instantiateViewController(withIdentifier: "EatSelectedViewController") as! EatSelectedViewController
        
        DispatchQueue.main.async {
            
            eatSelectedViewController.mainImages = self.nextViewImage!
            eatSelectedViewController.dealName = self.result[indexPath.row].dealName
            eatSelectedViewController.subName = self.result[indexPath.row].subName
            eatSelectedViewController.startDate = self.result[indexPath.row].startDate
            eatSelectedViewController.endDate = self.result[indexPath.row].endDate
            eatSelectedViewController.basePrice = self.result[indexPath.row].basePrice
            eatSelectedViewController.discountRate = self.result[indexPath.row].discountRate
            eatSelectedViewController.discountPrice = self.result[indexPath.row].discountPrice
            eatSelectedViewController.introduceRes = self.result[indexPath.row].introduceRes
            eatSelectedViewController.introduceMenu = self.result[indexPath.row].introduceMenu
            eatSelectedViewController.caution = self.result[indexPath.row].caution
            eatSelectedViewController.howToUse = self.result[indexPath.row].howToUse
            eatSelectedViewController.refund = self.result[indexPath.row].refund
            eatSelectedViewController.inquiry = self.result[indexPath.row].inquiry
        }
        
        present(eatSelectedViewController, animated: true, completion: nil)
    }
    
}
