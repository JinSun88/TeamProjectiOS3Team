//
//  SettingViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 07/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let enrollButton = UIButton()
    let announcementButton = UIButton()
    let customerServiceButton = UIButton()
    let helpButton = UIButton()
    let provisionButton = UIButton()
    let logoutButton = UIButton()
    let nextButton = UIButton()
    let nextButtonView = UIView()
    let versionLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        enrollbuttonConfig()
        
    }
    
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "설정"
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 9)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(topView)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(topView).dividedBy(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.height.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.width.equalTo(150)
        }
        
    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func enrollbuttonConfig() {
        view.addSubview(enrollButton)
        view.addSubview(nextButtonView)
        nextButtonView.addSubview(nextButton)
        
        enrollButton.setTitle("   식당 등록", for: .normal)
        enrollButton.setTitleColor(UIColor.black, for: .normal)
        enrollButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        enrollButton.backgroundColor = .white
        enrollButton.contentHorizontalAlignment = .left
        nextButton.backgroundColor = .white
        nextButton.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton.contentMode = .scaleAspectFit
        nextButtonView.backgroundColor = .white
        enrollButton.addTarget(self, action: #selector(enrollButtonDidTap), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(enrollButtonDidTap), for: .touchUpInside)
        
        
        enrollButton.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        nextButtonView.snp.makeConstraints {
            $0.top.bottom.equalTo(enrollButton)
            $0.leading.equalTo(enrollButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(nextButtonView).offset(15)
            $0.bottom.equalTo(nextButtonView).offset(-15)
            $0.trailing.equalTo(nextButtonView).offset(-10)
            $0.leading.equalTo(nextButtonView).offset(15)
        }
    }
    
    @objc func enrollButtonDidTap() {
        // 식당등록화면으로
    }
    
  
    
    
    
    
    
}
