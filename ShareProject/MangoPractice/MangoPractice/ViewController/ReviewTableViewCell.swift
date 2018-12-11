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
    let reviewContentImage = UIImageView()
    
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
            m.top.leading.equalToSuperview().offset(10)
            m.width.height.equalTo(50)
        }
        authorImageView.image = UIImage(named: "defaultImage")
        authorImageView.layer.cornerRadius = 25
        authorImageView.clipsToBounds = true
        
        // 리뷰어 이름
        self.contentView.addSubview(authorName)
        authorName.snp.makeConstraints { (m) in
            m.centerY.height.equalTo(authorImageView)
            m.leading.equalTo(authorImageView.snp.trailing).offset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        authorName.font = UIFont(name: "Helvetica", size: 20)
        
        // 리뷰어 평가 (맛있다, 괜찮다, 별로 이미지 & 텍스트)
        self.contentView.addSubview(reviewRate)
        reviewRate.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(10)
            m.trailing.equalToSuperview().inset(10)
            m.width.height.equalTo(30)
        }
        self.contentView.addSubview(reviewRateLabel)
        reviewRateLabel.snp.makeConstraints { (m) in
            m.top.equalTo(reviewRate.snp.bottom).offset(3)
            m.centerX.equalTo(reviewRate)
        }
        reviewRateLabel.font = UIFont(name: "Helvetica", size: 12)
        reviewRateLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        
        // 리뷰 내용
        reviewContent.backgroundColor = .lightGray
        self.contentView.addSubview(reviewContent)
        reviewContent.snp.makeConstraints { (m) in
            m.top.equalTo(authorImageView.snp.bottom).offset(5)
            m.leading.equalTo(authorImageView)
            m.trailing.equalTo(reviewRate)
            m.height.equalTo(90)  // -> 고쳐야함
        }
        reviewContent.numberOfLines = 5
        reviewContent.font = UIFont(name: "Helvetica", size: 15)
        
        // 리뷰 내용 밑에 이미지
        reviewContentImage.image = UIImage(named: "defaultImage")
        self.contentView.addSubview(reviewContentImage)
        reviewContentImage.snp.makeConstraints { (m) in
            m.top.equalTo(reviewContent.snp.bottom).offset(10)
            m.leading.trailing.equalTo(reviewContent)
            m.height.equalTo(130)
        }
        reviewContentImage.contentMode = .scaleAspectFill
        reviewContentImage.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state 어디에 쓰는 물건 인고...
    }
}
