//
//  PurchasedEatDealCollectionViewCell.swift
//  MangoPractice
//
//  Created by jinsunkim on 14/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class PurchasedEatDealCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let subNameLabel = UILabel()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // 셀 이미지뷰를 동그랗게 해주기 위한 처리
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layoutIfNeeded()
        self.imageView.layer.cornerRadius = imageView.frame.width / 2
        self.imageView.clipsToBounds = true

    }
    
    
    private func configureUI() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(subNameLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(dateLabel)
        
        contentView.backgroundColor = .white
        subNameLabel.font = UIFont(name: "Helvetica", size: CGFloat(12))
        subNameLabel.textColor = .gray
        nameLabel.font = UIFont(name: "Helvetica", size: CGFloat(16))
        nameLabel.textColor = #colorLiteral(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
        priceLabel.font = UIFont(name: "Helvetica", size: CGFloat(14))
        priceLabel.textColor = #colorLiteral(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
        dateLabel.font = UIFont(name: "Helvetica", size: CGFloat(11))
        dateLabel.textColor = .darkGray
        imageView.contentMode = .scaleAspectFill


        imageView.snp.makeConstraints {
            $0.leading.equalTo(self.contentView).offset(10)
            $0.top.equalTo(self.contentView).offset(10)
            $0.bottom.equalTo(self.contentView).offset(-10)
            $0.width.equalTo(self.contentView.frame.height - 20)
        }
        
        subNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalTo(imageView.snp.trailing).offset(15)
            $0.height.equalTo(self.contentView.frame.height / 7)
            $0.width.equalTo(self.contentView.frame.width - self.contentView.frame.height - 20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(subNameLabel)
            $0.top.equalTo(subNameLabel.snp.bottom).offset(5)
            $0.width.height.equalTo(subNameLabel)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.width.height.equalTo(subNameLabel)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.leading.width.height.equalTo(subNameLabel)
        }
        
    

        
    }
    
    
}
