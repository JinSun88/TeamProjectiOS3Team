//
//  MyInfoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 30/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class MyInfoViewController: UIViewController {
    let topView = UIView()
    let myImageView = UIImageView()
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
        view.addSubview(topView)
        topView.addSubview(myImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(rivisionButton)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        topView.backgroundColor = .white
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.image = UIImage(named: "GFood_selected") // 더미이미지
        myImageView.contentMode = .scaleAspectFill
        nameLabel.text = "someone" // 더미 텍스트
        rivisionButton.setImage(UIImage(named: "rivisionButton"), for: .normal)
    
        
        topView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        myImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(80)
            $0.bottom.equalTo(topView).offset(-45)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(myImageView.snp.top).offset(15)
            $0.leading.equalTo(myImageView.snp.trailing).offset(30)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        
        rivisionButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
            $0.width.equalTo(60)
        }

    }
    
    private func buttonConfig() {
        view.addSubview(purchasedEatDealButton)
        view.addSubview(wantToGoButton)
        view.addSubview(myRestaurantButton)
        view.addSubview(settingButton)
        
        purchasedEatDealButton.setImage(UIImage(named: "purchasedEatDealButton"), for: .normal)
        wantToGoButton.setImage(UIImage(named: "wantToGoButton"), for: .normal)
        myRestaurantButton.setImage(UIImage(named: "myRestaurantButton"), for: .normal)
        settingButton.setImage(UIImage(named: "settingButton"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)

        
        purchasedEatDealButton.contentMode = .scaleAspectFill
        wantToGoButton.contentMode = .scaleAspectFill
        myRestaurantButton.contentMode = .scaleAspectFill
        settingButton.contentMode = .scaleAspectFill
        
        purchasedEatDealButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(15)
            $0.height.equalTo(topView).dividedBy(3.5)
        }
        
        wantToGoButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(purchasedEatDealButton.snp.bottom).offset(15)
            $0.height.equalTo(topView).dividedBy(3.5)
        }
        
        myRestaurantButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(wantToGoButton.snp.bottom).offset(15)
            $0.height.equalTo(topView).dividedBy(3.5)
        }
        
        settingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(myRestaurantButton.snp.bottom).offset(15)
            $0.height.equalTo(topView).dividedBy(3.5)
        }

        
    }
    
    @objc func settingButtonDidTap(_sender: UIButton) {
        performSegue(withIdentifier: "showSettingVC", sender: self)
    }
    



}
