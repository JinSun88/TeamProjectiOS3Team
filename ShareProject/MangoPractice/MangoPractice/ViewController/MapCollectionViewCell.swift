//
//  MapCollectionViewCell.swift
//  MangoPractice
//
//  Created by jinsunkim on 28/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class MapCollectionViewCell: UICollectionViewCell {
    let restaurantPicture = UIImageView()
    let contentArea = UIView()
    let rankingName = UILabel()
    let restaurantLocation = UILabel()
    let viewFeedCount = UILabel()
    let gradePoint = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        contentArea.backgroundColor = .white
        rankingName.font = UIFont(name: "Helvetica", size: CGFloat(17))
        gradePoint.textColor = .orange
        gradePoint.font = UIFont(name: "Helvetica", size: CGFloat(20))
        restaurantLocation.font = UIFont(name: "Helvetica", size: CGFloat(12))
        restaurantLocation.textColor = .gray
        viewFeedCount.font = UIFont(name: "Helvetica", size: CGFloat(12))
        viewFeedCount.textColor = .gray
        
        self.contentView.addSubview(contentArea)
        self.contentView.addSubview(restaurantPicture)
        self.contentView.addSubview(rankingName)
        self.contentView.addSubview(restaurantLocation)
        self.contentView.addSubview(viewFeedCount)
        self.contentView.addSubview(gradePoint)
    
        restaurantPicture.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(self.contentView)
            $0.width.equalTo(self.contentView).dividedBy(3.5)
        }

        contentArea.snp.makeConstraints {
            $0.top.bottom.width.height.equalTo(self.contentView)
        }
        
        rankingName.snp.makeConstraints {
            $0.top.equalTo(contentArea)
            $0.leading.equalTo(restaurantPicture.snp.trailing).offset(10)
            $0.width.height.equalTo(contentArea).multipliedBy(0.5)
        }

        gradePoint.snp.makeConstraints {
            $0.top.equalTo(contentArea).offset(15)
            $0.trailing.equalTo(contentArea).offset(-15)
        }

        restaurantLocation.snp.makeConstraints {
            $0.top.equalTo(rankingName.snp.bottom)
            $0.leading.equalTo(restaurantPicture.snp.trailing).offset(10)
            $0.height.equalTo(contentArea).multipliedBy(0.25)
            $0.width.equalTo(contentArea).multipliedBy(0.9)
        }

        viewFeedCount.snp.makeConstraints {
            $0.top.equalTo(restaurantLocation.snp.bottom)
            $0.leading.equalTo(restaurantPicture.snp.trailing).offset(10)
            $0.height.equalTo(contentArea).multipliedBy(0.25)
            $0.width.equalTo(contentArea).multipliedBy(0.45)
        }

    
    
    }
}
