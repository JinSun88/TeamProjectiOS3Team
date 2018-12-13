//
//  EditMyInfoViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 12/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class EditMyInfoViewController: UIViewController {
    let topView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()


    }
    
    private func topViewConfig() {
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topView.backgroundColor = .white
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        titleLabel.text = "내 정보 수정"
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        topView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        
        backButton.snp.makeConstraints {
            $0.leading.equalTo(topView)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(topView).dividedBy(10)
            $0.height.equalTo(topView).dividedBy(6)
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
    


}
