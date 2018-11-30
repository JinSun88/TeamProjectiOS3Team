//
//  EatDealTableViewCell.swift
//  MangoPractice
//
//  Created by yang on 30/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class EatDealTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
