//
//  ReviewTableViewCell.swift
//  MangoPractice
//
//  Created by Bernard Hur on 10/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    let authorImageView = UIImageView()
    let authorName = UILabel()
    var reviewRate = UIImageView()
    var reviewRateLabel = UILabel()
    let reviewContent = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        // 리뷰어 이미지
        self.contentView.addSubview(authorImageView)
        authorImageView.snp.makeConstraints { (m) in
            m.top.leading.equalToSuperview().offset(5)
            m.width.height.equalTo(50)
        }
        
        authorImageView.backgroundColor = .red
        
        // 리뷰어 이름
        self.contentView.addSubview(authorName)
        authorName.snp.makeConstraints { (m) in
            m.centerY.height.equalTo(authorImageView)
            m.leading.equalTo(authorImageView.snp.trailing).offset(5)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        
        authorName.backgroundColor = .yellow
        
        // 리뷰어 평가
        self.contentView.addSubview(reviewRate)
        reviewRate.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(5)
            m.trailing.equalToSuperview().inset(5)
            m.width.height.equalTo(30)
        }
        self.contentView.addSubview(reviewRateLabel)
        reviewRateLabel.snp.makeConstraints { (m) in
            m.top.equalTo(reviewRate.snp.bottom).offset(3)
            m.centerX.equalTo(reviewRate)
        }
        
        reviewRateLabel.font = UIFont(name: "Helvetica", size: 10)
        
        // 리뷰 내용
        self.contentView.addSubview(reviewContent)
        reviewContent.snp.makeConstraints { (m) in
            m.top.equalTo(reviewRate.snp.bottom).offset(5)
            m.width.equalToSuperview()
            m.height.equalTo(100)  // -> 고쳐야함
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state 어디에 쓰는 물건 인고...
    }
    
}
