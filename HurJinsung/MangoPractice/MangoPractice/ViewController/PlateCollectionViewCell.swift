//
//  PlateCollectionViewCell.swift
//  MangoPractice
//
//  Created by Bernard Hur on 22/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

final class PlateCollectionViewCell: UICollectionViewCell {
    let restaurantPicture = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        self.contentView.addSubview(restaurantPicture)
        
        restaurantPicture.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.leading.equalToSuperview().offset(10)
            m.width.height.equalTo(100)
        }
    }
}
