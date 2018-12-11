//
//  SettingViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 07/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit

class SettingViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let enrollButton = UIButton()
    let notificationSettingLabel = UILabel()
    let notificationSettingView = UIView()
    let notificationSettingButton = UISwitch()
    let announcementButton = UIButton()
    let customerServiceButton = UIButton()
    let helpButton = UIButton()
    let provisionButton = UIButton()
    let logoutButton = UIButton()
    let nextButton = UIButton()
    let nextButtonView = UIView()
    let nextButton1 = UIButton()
    let nextButtonView1 = UIView()
    let nextButton2 = UIButton()
    let nextButtonView2 = UIView()
    let nextButton3 = UIButton()
    let nextButtonView3 = UIView()
    let versionLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        enrollbuttonConfig()
        notificationSettingButtonConfig()
        announcementButtonConfig()
        customerServiceButtonConfig()
        helpButtonConfig()
        provisionButtonConfig()
        logoutButtonConfig()
        versionLabelConfig()
        
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
        let destination = EnrollViewController()
        present(destination, animated: true)
    }
    
    private func notificationSettingButtonConfig() {
        view.addSubview(notificationSettingView)
        notificationSettingView.addSubview(notificationSettingLabel)
        notificationSettingView.addSubview(notificationSettingButton)
        
        notificationSettingView.backgroundColor = .white
        notificationSettingLabel.text = "   알림설정"
        notificationSettingLabel.textColor = .black
        notificationSettingLabel.font = UIFont(name: "Helvetica", size: 15)
        notificationSettingLabel.backgroundColor = .clear
        notificationSettingLabel.textAlignment = .left
        notificationSettingButton.setOn(false, animated: false)
        notificationSettingButton.addTarget(self, action: #selector(notificationSettingButtonDidTap), for: .touchUpInside)
        
        notificationSettingView.snp.makeConstraints {
            $0.top.equalTo(enrollButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
            
        }
        
        notificationSettingLabel.snp.makeConstraints {
            $0.top.leading.height.equalTo(notificationSettingView)
            $0.width.equalTo(notificationSettingView).dividedBy(2)
        }

        notificationSettingButton.snp.makeConstraints {
            $0.trailing.equalTo(notificationSettingView).offset(-35)
            $0.centerY.equalTo(notificationSettingView.snp.centerY)
            $0.width.equalTo(40)
        }

    }
    
    @objc func notificationSettingButtonDidTap(_ sender: UIButton) {
        if notificationSettingButton.isOn {
            UIApplication.shared.unregisterForRemoteNotifications()
        } else {
            UIApplication.shared.registerForRemoteNotifications()
        }
    } // 알림설정 온오프
    
    private func announcementButtonConfig() {
        view.addSubview(announcementButton)
        view.addSubview(nextButtonView1)
        nextButtonView1.addSubview(nextButton1)
        
        announcementButton.setTitle("   공지사항", for: .normal)
        announcementButton.setTitleColor(UIColor.black, for: .normal)
        announcementButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        announcementButton.backgroundColor = .white
        announcementButton.contentHorizontalAlignment = .left
        nextButton1.backgroundColor = .white
        nextButton1.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton1.contentMode = .scaleAspectFit
        nextButtonView1.backgroundColor = .white
        announcementButton.addTarget(self, action: #selector(announcementButtonDidTap), for: .touchUpInside)
        nextButton1.addTarget(self, action: #selector(announcementButtonDidTap), for: .touchUpInside)
        
        
        announcementButton.snp.makeConstraints {
            $0.top.equalTo(notificationSettingView.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        nextButtonView1.snp.makeConstraints {
            $0.top.bottom.equalTo(announcementButton)
            $0.leading.equalTo(announcementButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton1.snp.makeConstraints {
            $0.top.equalTo(nextButtonView1).offset(15)
            $0.bottom.equalTo(nextButtonView1).offset(-15)
            $0.trailing.equalTo(nextButtonView1).offset(-10)
            $0.leading.equalTo(nextButtonView1).offset(15)
        }
        
    }
    @objc func announcementButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://www.mangoplate.com/notice") {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    private func customerServiceButtonConfig() {
        view.addSubview(customerServiceButton)
        view.addSubview(nextButtonView2)
        nextButtonView2.addSubview(nextButton2)
        
        customerServiceButton.setTitle("   고객센터", for: .normal)
        customerServiceButton.setTitleColor(UIColor.black, for: .normal)
        customerServiceButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        customerServiceButton.backgroundColor = .white
        customerServiceButton.contentHorizontalAlignment = .left
        nextButton2.backgroundColor = .white
        nextButton2.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton2.contentMode = .scaleAspectFit
        nextButtonView2.backgroundColor = .white
        customerServiceButton.addTarget(self, action: #selector(customerServiceButtonDidTap), for: .touchUpInside)
        nextButton1.addTarget(self, action: #selector(customerServiceButtonDidTap), for: .touchUpInside)
        
        
        customerServiceButton.snp.makeConstraints {
            $0.top.equalTo(announcementButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        nextButtonView2.snp.makeConstraints {
            $0.top.bottom.equalTo(customerServiceButton)
            $0.leading.equalTo(customerServiceButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton2.snp.makeConstraints {
            $0.top.equalTo(nextButtonView2).offset(15)
            $0.bottom.equalTo(nextButtonView2).offset(-15)
            $0.trailing.equalTo(nextButtonView2).offset(-10)
            $0.leading.equalTo(nextButtonView2).offset(15)
        }
        
    }
    @objc func customerServiceButtonDidTap(_ sender: UIButton) {
        let mailURL = URL(string: "mailto://example@mangoplate.com")!
        
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL)
        }
        
    }
    
    private func helpButtonConfig() {
        view.addSubview(helpButton)
        view.addSubview(nextButtonView3)
        nextButtonView3.addSubview(nextButton3)
        
        helpButton.setTitle("   도움말", for: .normal)
        helpButton.setTitleColor(UIColor.black, for: .normal)
        helpButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        helpButton.backgroundColor = .white
        helpButton.contentHorizontalAlignment = .left
        nextButton3.backgroundColor = .white
        nextButton3.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton3.contentMode = .scaleAspectFit
        nextButtonView3.backgroundColor = .white
        helpButton.addTarget(self, action: #selector(helpButtonDidTap), for: .touchUpInside)
        nextButton1.addTarget(self, action: #selector(helpButtonDidTap), for: .touchUpInside)
        
        
        helpButton.snp.makeConstraints {
            $0.top.equalTo(customerServiceButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-45)
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        nextButtonView3.snp.makeConstraints {
            $0.top.bottom.equalTo(helpButton)
            $0.leading.equalTo(helpButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        nextButton3.snp.makeConstraints {
            $0.top.equalTo(nextButtonView3).offset(15)
            $0.bottom.equalTo(nextButtonView3).offset(-15)
            $0.trailing.equalTo(nextButtonView3).offset(-10)
            $0.leading.equalTo(nextButtonView3).offset(15)
        }
        
    }
    @objc func helpButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "http://blog.mangoplate.com/blog/archives/category/tips-for-mangoplate") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func provisionButtonConfig() {
        view.addSubview(provisionButton)
        
        provisionButton.setTitle("   약관 및 정책", for: .normal)
        provisionButton.setTitleColor(UIColor.black, for: .normal)
        provisionButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        provisionButton.backgroundColor = .white
        provisionButton.contentHorizontalAlignment = .left
        provisionButton.addTarget(self, action: #selector(provisionButtonDidTap), for: .touchUpInside)

        
        
        provisionButton.snp.makeConstraints {
            $0.top.equalTo(helpButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        
    }
    @objc func provisionButtonDidTap(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowProvisionVC", sender: nil)
        
    }
    
    private func logoutButtonConfig() {
        view.addSubview(logoutButton)
        
        logoutButton.setTitle("   로그아웃", for: .normal)
        logoutButton.setTitleColor(UIColor.black, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        logoutButton.backgroundColor = .white
        logoutButton.contentHorizontalAlignment = .left
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(provisionButton.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        
    }
    @objc func logoutButtonDidTap(_ sender: UIButton) {
        let FBLoginManager = FBSDKLoginManager()
        FBLoginManager.logOut()
        performSegue(withIdentifier: "showLogin", sender: self)

    }
    
    private func versionLabelConfig() {
        view.addSubview(versionLabel)
        
        versionLabel.text = "   버전 1.0.0"
        versionLabel.font = UIFont(name: "Helvetica", size: 15)
        versionLabel.backgroundColor = .white
        versionLabel.textAlignment = .left
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(15)
        }
        
        
    }

  
    
    
    
    
    
}
