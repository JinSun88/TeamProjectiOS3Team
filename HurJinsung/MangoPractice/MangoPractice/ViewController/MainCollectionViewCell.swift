//
//  MainCollectionViewCell.swift
//  MangoPractice
//
//  Created by Bernard Hur on 12/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: UICollectionViewCell {
    let restaurantPicture = UIImageView()
    let rankingName = UILabel()
    let restaurantLocation = UILabel()
    let viewFeedCount = UILabel()
    let gradePoint = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()               // 오토레이아웃이 들어오면 에러처리
    }
    
    private func configureUI() {    // cell 안에 구성 셋팅
        rankingName.font = UIFont(name: "Helvetica", size: CGFloat(15))
        gradePoint.textColor = .orange
        gradePoint.font = UIFont(name: "Helvetica", size: CGFloat(20))
        restaurantLocation.font = UIFont(name: "Helvetica", size: CGFloat(10))
        restaurantLocation.textColor = .gray
        viewFeedCount.font = UIFont(name: "Helvetica", size: CGFloat(10))
        viewFeedCount.textColor = .gray
        
        self.contentView.addSubview(restaurantPicture)
        self.contentView.addSubview(rankingName)
        self.contentView.addSubview(restaurantLocation)
        self.contentView.addSubview(viewFeedCount)
        self.contentView.addSubview(gradePoint)
        
        // Autolayout
        restaurantPicture.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalTo(self.contentView.snp.height).multipliedBy(0.7)
        }
        rankingName.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantPicture.snp.bottom)
            m.leading.equalTo(self.contentView)
            m.trailing.equalTo(self.contentView).multipliedBy(0.8)
        }
        gradePoint.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantPicture.snp.bottom)
            m.trailing.equalTo(self.contentView)
        }
        restaurantLocation.snp.makeConstraints { (m) in
            m.top.equalTo(rankingName.snp.bottom)
            m.leading.equalTo(self.contentView)
        }
        viewFeedCount.snp.makeConstraints { (m) in
            m.top.equalTo(restaurantLocation.snp.bottom)
            m.leading.equalTo(self.contentView)
        }
    }
}
