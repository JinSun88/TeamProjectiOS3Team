//
//  MapViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 27/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit


class MapViewController: UIViewController {
    let currentPlaceGuideLabel = UILabel()
    let currentPlaceButton = UIButton()
    let searchButton = UIButton()
    let mapUnwindButton = UIButton()
    let mainView = ViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapUnwindButtonConfig()
        currentPlaceLabelButtonConfig()
        mapUnwindButtonConfig()
        searchButtonConfig()

    }
    // 현재지역 버튼 셋업
    private func currentPlaceLabelButtonConfig() {
        // 지금보고 있는 지역은? label 위치, 폰트 사이즈, text 지정
        view.addSubview(currentPlaceGuideLabel)
        currentPlaceGuideLabel.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            m.leading.equalTo(view).offset(30)
        
        }
        
        currentPlaceGuideLabel.text = "지금 보고 있는 지역은"
        currentPlaceGuideLabel.font = currentPlaceGuideLabel.font.withSize(10)
        
        // 현위치 버튼 위치, 폰트 사이즈, text 지정
        view.addSubview(currentPlaceButton)
        currentPlaceButton.snp.makeConstraints { (m) in
            m.top.equalTo(currentPlaceGuideLabel.snp.bottom)
            m.leading.equalTo(currentPlaceGuideLabel)
        }
        currentPlaceButton.setTitle("왕십리/성동 ∨", for: .normal)
        currentPlaceButton.setTitleColor(.black, for: .normal)
    }
    
    private func mapUnwindButtonConfig() {
        let mapUnwindButtonImage = UIImage(named: "mapUnwindButton")
        view.addSubview(mapUnwindButton)
        mapUnwindButton.setImage(mapUnwindButtonImage, for: .normal)
        mapUnwindButton.imageView?.contentMode = .scaleAspectFit
        
        mapUnwindButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(70)
            $0.height.equalTo(50)
        }
        
        mapUnwindButton.addTarget(self, action: #selector(mapUnwindButtonAction), for: .touchUpInside)
    }
    
    private func searchButtonConfig() {
        let searchButtonImage = UIImage(named: "search_button")
        view.addSubview(searchButton)
        
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(mapUnwindButton.snp.leading)
            $0.width.equalTo(43)
            $0.height.equalTo(43)
        }
    }
   
    @objc func mapUnwindButtonAction(sender: UIButton!) {
        print("mapUnwindButton tap")
        dismiss(animated: true, completion: nil)

    }
    


}
