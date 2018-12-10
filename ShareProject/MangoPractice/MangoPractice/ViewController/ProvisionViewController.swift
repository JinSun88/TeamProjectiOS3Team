//
//  ProvisionViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 09/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class ProvisionViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let deatilProvisionButton = UIButton()
    let nonMemberUserPolicyButton = UIButton()
    let privacyPolicyButton = UIButton()
    let locationBasedServicesTermsandConditionsButton = UIButton()
    let communityGuideLineButton = UIButton()



    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        deatilProvisionButtonConfig()
        nonMemberUserPolicyButtonConfig()
        privacyPolicyButtonConfig()
        locationBasedServicesTermsandConditionsButtonConfig()
        communityGuideLineButtonConfig()

    }
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "약관 및 정책"
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
    
    private func deatilProvisionButtonConfig() {
        view.addSubview(deatilProvisionButton)
        deatilProvisionButton.setTitle("   이용약관", for: .normal)
        deatilProvisionButton.setTitleColor(UIColor.black, for: .normal)
        deatilProvisionButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        deatilProvisionButton.backgroundColor = .white
        deatilProvisionButton.contentHorizontalAlignment = .left
        deatilProvisionButton.addTarget(self, action: #selector(deatilProvisionButtonDidTap), for: .touchUpInside)

        deatilProvisionButton.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
    }
    
    @objc func deatilProvisionButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/terms/contract") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func nonMemberUserPolicyButtonConfig() {
        view.addSubview(nonMemberUserPolicyButton)
        nonMemberUserPolicyButton.setTitle("   비회원 이용자 이용정책", for: .normal)
        nonMemberUserPolicyButton.setTitleColor(UIColor.black, for: .normal)
        nonMemberUserPolicyButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        nonMemberUserPolicyButton.backgroundColor = .white
        nonMemberUserPolicyButton.contentHorizontalAlignment = .left
        nonMemberUserPolicyButton.addTarget(self, action: #selector(nonMemberUserPolicyButtonDidTap), for: .touchUpInside)
        
        nonMemberUserPolicyButton.snp.makeConstraints {
            $0.top.equalTo(deatilProvisionButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
    }
    
    @objc func nonMemberUserPolicyButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/terms/contract_non_signup") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func privacyPolicyButtonConfig() {
        view.addSubview(privacyPolicyButton)
        privacyPolicyButton.setTitle("   개인정보처리방침", for: .normal)
        privacyPolicyButton.setTitleColor(UIColor.black, for: .normal)
        privacyPolicyButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        privacyPolicyButton.backgroundColor = .white
        privacyPolicyButton.contentHorizontalAlignment = .left
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonButtonDidTap), for: .touchUpInside)
        
        privacyPolicyButton.snp.makeConstraints {
            $0.top.equalTo(nonMemberUserPolicyButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
    }
    
    @objc func privacyPolicyButtonButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/terms/privacy") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func locationBasedServicesTermsandConditionsButtonConfig() {
        view.addSubview(locationBasedServicesTermsandConditionsButton)
        locationBasedServicesTermsandConditionsButton.setTitle("   위치기반서비스 이용약관", for: .normal)
        locationBasedServicesTermsandConditionsButton.setTitleColor(UIColor.black, for: .normal)
        locationBasedServicesTermsandConditionsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        locationBasedServicesTermsandConditionsButton.backgroundColor = .white
        locationBasedServicesTermsandConditionsButton.contentHorizontalAlignment = .left
        locationBasedServicesTermsandConditionsButton.addTarget(self, action: #selector(locationBasedServicesTermsandConditionsButtonDidTap), for: .touchUpInside)
        
        locationBasedServicesTermsandConditionsButton.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
    }
    
    @objc func locationBasedServicesTermsandConditionsButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/terms/location") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func communityGuideLineButtonConfig() {
        view.addSubview(communityGuideLineButton)
        communityGuideLineButton.setTitle("   커뮤니티 가이드라인", for: .normal)
        communityGuideLineButton.setTitleColor(UIColor.black, for: .normal)
        communityGuideLineButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        communityGuideLineButton.backgroundColor = .white
        communityGuideLineButton.contentHorizontalAlignment = .left
        communityGuideLineButton.addTarget(self, action: #selector(communityGuideLineButtonDidTap), for: .touchUpInside)
        
        communityGuideLineButton.snp.makeConstraints {
            $0.top.equalTo(locationBasedServicesTermsandConditionsButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
    }
    
    @objc func communityGuideLineButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/terms/community_guidelines") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    

    


}
