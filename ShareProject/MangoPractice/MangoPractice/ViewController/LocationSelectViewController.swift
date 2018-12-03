//
//  LocationSelectViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 03/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSelectViewController: UIViewController {
    let backButton = UIButton()
    let searchTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchTextField.delegate = self
        topViewConfig()

    }
    
    private func topViewConfig() {
        view.addSubview(backButton)
        view.addSubview(searchTextField)
        
        backButton.setImage(UIImage(named: "backArrowButton"), for: .normal)
        backButton.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchDragInside)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "식당 위치 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchTextField.returnKeyType = .search
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.top.height.equalTo(backButton)
            $0.trailing.equalToSuperview()
        }
        
    }
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
//extension LocationSelectViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
//
//    func searchPlaceFromGoogle(place: String) {
//
//    }
//}


