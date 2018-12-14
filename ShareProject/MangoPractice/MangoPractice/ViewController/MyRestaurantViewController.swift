//
//  MyRestaurantViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 13/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class MyRestaurantViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    var mainTableView = UITableView(frame: CGRect.zero)
    var arrayOfCellData = CellDataOrigin().arrayOfCellData //임시로 하드코딩 데이터 삽입

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        mainTableViewConfig()


    }
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "내가 등록한 식당"
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
    
    private func mainTableViewConfig() {
        view.addSubview(mainTableView)
        mainTableView.backgroundColor = .white
        mainTableView.dataSource = self
        mainTableView.delegate = self
//        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL") // 테이블뷰 서브타이틀 사용 시에는 사용해서는 안됨
        
        mainTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
    }


}

extension MyRestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블뷰의 서브타이틀 사용을 위해 처리 필요
        var cell = mainTableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL")
        }
        cell!.imageView?.image = UIImage(named: "defaultImage")// 디폴트 이미지 삽입
        cell!.textLabel?.text = "\(arrayOfCellData[indexPath.row].name)"
        cell!.detailTextLabel?.text = "\(arrayOfCellData[indexPath.row].address)"
        
        return cell!
        
    }
}

extension MyRestaurantViewController: UITableViewDelegate {

    
}
