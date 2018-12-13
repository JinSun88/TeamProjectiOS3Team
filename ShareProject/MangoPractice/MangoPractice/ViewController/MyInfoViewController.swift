//
//  MyInfoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 30/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import FBSDKCoreKit
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
    let nextButtonView = UIView()
    let nextButton = UIButton()
    let nextButtonView1 = UIView()
    let nextButton1 = UIButton()
    let nextButtonView2 = UIView()
    let nextButton2 = UIButton()
    let nextButtonView3 = UIView()
    let nextButton3 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        buttonConfig()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.clipsToBounds = true
        // 레이아웃이 잡히기 전까지 이미지뷰의 width값이 0이기 때문에 레이아웃이 다 호출된 후 이미지뷰 동그랗게
    }
    
    
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(myImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(rivisionButton)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        topView.backgroundColor = .white
        rivisionButton.setImage(UIImage(named: "rivisionButton"), for: .normal)
        rivisionButton.addTarget(self, action: #selector(rivisionButtonDidTap), for: .touchUpInside)

        getFBUserInfo() //페이스북 데이터 가져오기
        
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
    //Facebook에서 프로필 이미지와 이름 데이터 가져와서 프로필 사진과 이미지로 설정
    private func getFBUserInfo() {
        if FBSDKAccessToken.current() != nil {
            print(FBSDKAccessToken.current()?.permissions ?? "")
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
            let connection = FBSDKGraphRequestConnection()

            connection.add(graphRequest) { (connection, result, error) -> Void in
                let data = result as! [String : AnyObject]

                self.nameLabel.text = data["name"] as? String

                let FBid = data["id"] as? String

                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")

                self.myImageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)

            }
            connection.start()
        }
    }
    
    @objc func rivisionButtonDidTap(_ sender: UIButton){
        performSegue(withIdentifier: "showEditMyInfo", sender: self)
    }
    
    private func buttonConfig() {
        view.addSubview(purchasedEatDealButton)
        view.addSubview(wantToGoButton)
        view.addSubview(myRestaurantButton)
        view.addSubview(settingButton)
        view.addSubview(nextButtonView)
        view.addSubview(nextButtonView1)
        view.addSubview(nextButtonView2)
        view.addSubview(nextButtonView3)
        nextButtonView.addSubview(nextButton)
        nextButtonView1.addSubview(nextButton1)
        nextButtonView2.addSubview(nextButton2)
        nextButtonView3.addSubview(nextButton3)

        purchasedEatDealButton.setTitle("     구매한 EAT딜", for: .normal)
        purchasedEatDealButton.setTitleColor(UIColor.black, for: .normal)
        purchasedEatDealButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        purchasedEatDealButton.backgroundColor = .white
        purchasedEatDealButton.contentHorizontalAlignment = .left
        nextButton.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton.contentMode = .scaleAspectFit
        nextButtonView.backgroundColor = .white
        
        wantToGoButton.setTitle("     가고싶다", for: .normal)
        wantToGoButton.setTitleColor(UIColor.black, for: .normal)
        wantToGoButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        wantToGoButton.backgroundColor = .white
        wantToGoButton.contentHorizontalAlignment = .left
        nextButton1.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton1.contentMode = .scaleAspectFit
        nextButtonView1.backgroundColor = .white
        
        
        myRestaurantButton.setTitle("     내가 등록한 식당", for: .normal)
        myRestaurantButton.setTitleColor(UIColor.black, for: .normal)
        myRestaurantButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        myRestaurantButton.backgroundColor = .white
        myRestaurantButton.contentHorizontalAlignment = .left
        nextButton2.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton2.contentMode = .scaleAspectFit
        nextButtonView2.backgroundColor = .white
        
        settingButton.setTitle("     설정", for: .normal)
        settingButton.setTitleColor(UIColor.black, for: .normal)
        settingButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        settingButton.backgroundColor = .white
        settingButton.contentHorizontalAlignment = .left
        nextButton3.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton3.contentMode = .scaleAspectFit
        nextButtonView3.backgroundColor = .white
        
        settingButton.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)

        
        purchasedEatDealButton.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(12)
        }
        
        nextButtonView.snp.makeConstraints {
            $0.top.bottom.equalTo(purchasedEatDealButton)
            $0.leading.equalTo(purchasedEatDealButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(nextButtonView).offset(20)
            $0.bottom.equalTo(nextButtonView).offset(-20)
            $0.trailing.equalTo(nextButtonView).offset(-10)
            $0.leading.equalTo(nextButtonView).offset(15)
        }
        
        wantToGoButton.snp.makeConstraints {
            $0.top.equalTo(purchasedEatDealButton.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(12)
        }
        
        nextButtonView1.snp.makeConstraints {
            $0.top.bottom.equalTo(wantToGoButton)
            $0.leading.equalTo(wantToGoButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton1.snp.makeConstraints {
            $0.top.equalTo(nextButtonView1).offset(20)
            $0.bottom.equalTo(nextButtonView1).offset(-20)
            $0.trailing.equalTo(nextButtonView1).offset(-10)
            $0.leading.equalTo(nextButtonView1).offset(15)
        }
        
        myRestaurantButton.snp.makeConstraints {
            $0.top.equalTo(wantToGoButton.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(12)
        }
        
        nextButtonView2.snp.makeConstraints {
            $0.top.bottom.equalTo(myRestaurantButton)
            $0.leading.equalTo(myRestaurantButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton2.snp.makeConstraints {
            $0.top.equalTo(nextButtonView2).offset(20)
            $0.bottom.equalTo(nextButtonView2).offset(-20)
            $0.trailing.equalTo(nextButtonView2).offset(-10)
            $0.leading.equalTo(nextButtonView2).offset(15)
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(myRestaurantButton.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(12)
        }
        
        nextButtonView3.snp.makeConstraints {
            $0.top.bottom.equalTo(settingButton)
            $0.leading.equalTo(settingButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton3.snp.makeConstraints {
            $0.top.equalTo(nextButtonView3).offset(20)
            $0.bottom.equalTo(nextButtonView3).offset(-20)
            $0.trailing.equalTo(nextButtonView3).offset(-10)
            $0.leading.equalTo(nextButtonView3).offset(15)
        }

        
    }
    
    @objc func settingButtonDidTap(_sender: UIButton) {
        performSegue(withIdentifier: "showSettingVC", sender: self)
    }
    



}
