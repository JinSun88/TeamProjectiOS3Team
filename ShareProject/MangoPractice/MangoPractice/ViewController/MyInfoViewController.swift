//
//  MyInfoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 30/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {
    let topView = UIView()
    let myImageView = UIImage()
    let nameLabel = UILabel()
    let rivisionButton = UIButton()
    let purchasedEatDealButton = UIButton()
    let wantToGoButton = UIButton()
    let myRestaurantButton = UIButton()
    let settingButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        buttonConfig()

    }
    
    private func topViewConfig() {
        view.backgroundColor = .lightGray
        topView.backgroundColor = .white
        
        
        
    }
    
    private func buttonConfig() {
        
    }
    



}
