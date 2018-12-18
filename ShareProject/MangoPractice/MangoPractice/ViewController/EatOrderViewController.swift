//
//  EatOrderViewController.swift
//  final
//
//  Created by yang on 03/12/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import UIKit

class EatOrderViewController: UIViewController {
    
    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    
    var orderImage = UIImage()
    var dealName = String()
    var subName = String()
    var price = Int()
    var totalPrice = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderImageView.image = orderImage
        dealNameLabel.text = dealName
        subNameLabel.text = subName
        priceLabel.text = "￦\(price.withComma)"
        totalPriceLabel.text = "￦\(price.withComma)"

    }
}
