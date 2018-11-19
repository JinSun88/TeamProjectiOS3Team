//
//  PickTableViewCell.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 16/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

class PickTableViewCell: UITableViewCell {

    @IBOutlet weak var pickImageView: UIImageView!
    
    @IBOutlet weak var pickTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
