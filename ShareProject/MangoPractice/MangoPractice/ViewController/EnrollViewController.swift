//
//  EnrollViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 29/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SnapKit


class EnrollViewController: UIViewController {
    // 상단바
    let topBar = UIView()
    let titleLabel = UILabel()
    // 상단 레이블 및 식당 이름 및 위치 입력 텍스트필드
    let topLabel = UILabel()
    let textFieldView = UIView()
    let nameTextField = UITextField()
    let locationTextField = UITextField()
    
    // 중간 레이블
    let bottonView = UIView()
    let moreInfoLabel = UILabel()
    // 전화번호 텍스트필드
    let phoneNumberTextField = UITextField()
    // 음식종류 선택 버튼
    let foodTypeLabel = UILabel()
    let enrollButton = UIButton()
    let locationButton = UIButton()
    let koreanFoodButton = UIButton()
    let japaneseFoodButton = UIButton()
    let chineseFoodButton = UIButton()
    let westernFoodButton = UIButton()
    let globalFoodButton = UIButton()
    let buffetButton = UIButton()
    let cafeButton = UIButton()
    let liquorButton = UIButton()
    let koreanFoodlabel = UILabel()
    let japaneseFoodlabel = UILabel()
    let chineseFoodlabel = UILabel()
    let westernFoodlabel = UILabel()
    let globalFoodlabel = UILabel()
    let buffetlabel = UILabel()
    let cafelabel = UILabel()
    let liquorlabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topbarConfig()
        topViewConfig()
        enrollButtonConfig()
        bottomViewConfig()
        foodButtonConfig()
    }
    
    override func viewDidLayoutSubviews() {
        makeTextFieldUnderBar() // viewdidload할 경우 안나오는 경우가 있어서 여기에

    }
    
    
    // 텍스트 필드 아래 밑줄 삽입
    private func makeTextFieldUnderBar() {
        nameTextField.borderStyle = .none
        phoneNumberTextField.borderStyle = .none
        let nameBorder = CALayer()
        let phoneNumberBorder = CALayer()
        nameBorder.frame = CGRect(x: 0, y: nameTextField.frame.size.height - 1, width: nameTextField.frame.size.width, height: 1)
        nameBorder.backgroundColor = UIColor.lightGray.cgColor
        nameTextField.layer.addSublayer(nameBorder)
        phoneNumberBorder.frame = CGRect(x: 0, y: phoneNumberTextField.frame.size.height - 1, width: phoneNumberTextField.frame.size.width, height: 1)
        phoneNumberBorder.backgroundColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.addSublayer(phoneNumberBorder)
        
        
    }
    
    
    
    private func topbarConfig() {
        view.addSubview(topBar)
        view.addSubview(titleLabel)
        
        topBar.backgroundColor = #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)
        titleLabel.text = "식당 등록"
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "Helvetica", size: 15)
        
        
        
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 9)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(35)
            $0.bottom.equalTo(topBar)
            $0.trailing.equalToSuperview()
        }
        
  
        
    }
    
    private func topViewConfig() {
        view.addSubview(topLabel)
        view.addSubview(textFieldView)
        textFieldView.addSubview(nameTextField)
        textFieldView.addSubview(locationTextField)
        textFieldView.addSubview(locationButton)
        
        topLabel.text = "식당 이름과 위치를 알려주세요"
        topLabel.backgroundColor = .lightGray
        topLabel.textAlignment = .center
        topLabel.font = UIFont(name: "Helvetica", size: 15)
        topLabel.textColor = .darkGray
        textFieldView.backgroundColor = .white
        nameTextField.backgroundColor = .white
        nameTextField.attributedPlaceholder = NSAttributedString(string: "*식당 이름 (예: 패스트반점)", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)])
        locationTextField.backgroundColor = .white
        locationTextField.attributedPlaceholder = NSAttributedString(string: "*지역 및 위치 선택", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.4456674457, blue: 0.004210381769, alpha: 1)])
        locationButton.setImage(UIImage(named: "locationButton"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonDidTap), for: .touchUpInside)
        
        
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 18)
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 9)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo((view.frame.height) / 18)
        }
        
        locationTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.trailing.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo((view.frame.height) / 18)
        }
        
        locationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalTo(locationTextField).offset(2)
            $0.width.equalTo(40)
        }
        
    }
    
    private func bottomViewConfig() {
        view.addSubview(bottonView)
        view.addSubview(moreInfoLabel)
        bottonView.addSubview(phoneNumberTextField)
        bottonView.backgroundColor = .white
        moreInfoLabel.text = "조금 더 자세히 알려주세요"
        moreInfoLabel.backgroundColor = .lightGray
        moreInfoLabel.textAlignment = .center
        moreInfoLabel.font = UIFont(name: "Helvetica", size: 15)
        moreInfoLabel.textColor = .darkGray
        
        phoneNumberTextField.backgroundColor = .white
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "전화번호 (예: 02-123-4567)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        bottonView.snp.makeConstraints {
            $0.top.equalTo(moreInfoLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(enrollButton.snp.top)
        }
        
        moreInfoLabel.snp.makeConstraints {
            $0.top.equalTo(locationTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 18)

        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(moreInfoLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo((view.frame.height) / 18)

            
        }
        
        
    }
    
    private func enrollButtonConfig() {
        view.addSubview(enrollButton)
        
        enrollButton.backgroundColor = .gray
        enrollButton.setTitle("등록", for: .normal)
        enrollButton.setTitleColor(UIColor.white, for: .normal)
    
        
        enrollButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo((view.frame.height) / 18)
        }
        
        
    }
    
    private func foodButtonConfig() {
        bottonView.addSubview(foodTypeLabel)
        bottonView.addSubview(koreanFoodButton)
        bottonView.addSubview(japaneseFoodButton)
        bottonView.addSubview(chineseFoodButton)
        bottonView.addSubview(westernFoodButton)
        bottonView.addSubview(globalFoodButton)
        bottonView.addSubview(buffetButton)
        bottonView.addSubview(cafeButton)
        bottonView.addSubview(liquorButton)
        bottonView.addSubview(koreanFoodlabel)
        bottonView.addSubview(japaneseFoodlabel)
        bottonView.addSubview(chineseFoodlabel)
        bottonView.addSubview(westernFoodlabel)
        bottonView.addSubview(globalFoodlabel)
        bottonView.addSubview(buffetlabel)
        bottonView.addSubview(cafelabel)
        bottonView.addSubview(liquorlabel)
        
        foodTypeLabel.text = "음식 종류 선택"
        foodTypeLabel.textColor = .darkGray
        foodTypeLabel.textAlignment = .center
        foodTypeLabel.backgroundColor = .clear
    
        foodTypeLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((view.frame.height) / 18)
        }
        
        koreanFoodButton.setImage(UIImage(named: "KFood_deselected"), for: .normal)
        koreanFoodButton.setImage(UIImage(named: "KFood_selected"), for: .selected)
        koreanFoodButton.addTarget(self, action: #selector(koreanFoodbuttonDidTap), for: .touchUpInside)
        koreanFoodlabel.text = "한식"
        koreanFoodlabel.textColor = .gray
        koreanFoodlabel.backgroundColor = .white
        koreanFoodlabel.textAlignment = .center
                                koreanFoodlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))
        
        koreanFoodButton.snp.makeConstraints {
            $0.top.equalTo(foodTypeLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }

        koreanFoodlabel.snp.makeConstraints {
            $0.top.equalTo(koreanFoodButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(koreanFoodButton)
            $0.height.equalTo(8)
        }
        
        japaneseFoodButton.setImage(UIImage(named: "JFood_deselected"), for: .normal)
        japaneseFoodButton.setImage(UIImage(named: "JFood_selected"), for: .selected)
        japaneseFoodButton.addTarget(self, action:        #selector(japaneseFoodButtonDidTap), for: .touchUpInside)
        japaneseFoodlabel.text = "일식"
        japaneseFoodlabel.textColor = .gray
        japaneseFoodlabel.backgroundColor = .white
        japaneseFoodlabel.textAlignment = .center
                        japaneseFoodlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))
        
        japaneseFoodButton.snp.makeConstraints {
            $0.top.equalTo(koreanFoodButton)
            $0.leading.equalTo(koreanFoodButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        japaneseFoodlabel.snp.makeConstraints {
            $0.top.equalTo(japaneseFoodButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(japaneseFoodButton)
            $0.height.equalTo(8)
        }
        
        chineseFoodButton.setImage(UIImage(named: "CFood_deselected"), for: .normal)
        chineseFoodButton.setImage(UIImage(named: "CFood_selected"), for: .selected)
        chineseFoodButton.addTarget(self, action:        #selector(chineseFoodButtonDidTap), for: .touchUpInside)
        chineseFoodlabel.text = "중식"
        chineseFoodlabel.textColor = .gray
        chineseFoodlabel.backgroundColor = .white
        chineseFoodlabel.textAlignment = .center
                chineseFoodlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))
        
        chineseFoodButton.snp.makeConstraints {
            $0.top.equalTo(koreanFoodButton)
            $0.leading.equalTo(japaneseFoodButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        chineseFoodlabel.snp.makeConstraints {
            $0.top.equalTo(chineseFoodButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(chineseFoodButton)
            $0.height.equalTo(8)
        }
        
        westernFoodButton.setImage(UIImage(named: "WFood_deselected"), for: .normal)
        westernFoodButton.setImage(UIImage(named: "WFood_selected"), for: .selected)
        westernFoodButton.addTarget(self, action:        #selector(westernFoodButtonDidTap), for: .touchUpInside)
        westernFoodlabel.text = "양식"
        westernFoodlabel.textColor = .gray
        westernFoodlabel.backgroundColor = .white
        westernFoodlabel.textAlignment = .center
        westernFoodlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))

        
        westernFoodButton.snp.makeConstraints {
            $0.top.equalTo(koreanFoodButton)
            $0.leading.equalTo(chineseFoodButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        westernFoodlabel.snp.makeConstraints {
            $0.top.equalTo(westernFoodButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(westernFoodButton)
            $0.height.equalTo(8)
        }
        
        globalFoodButton.setImage(UIImage(named: "GFood_deselected"), for: .normal)
        globalFoodButton.setImage(UIImage(named: "GFood_selected"), for: .selected)
        globalFoodButton.addTarget(self, action:        #selector(globalFoodButtonDidTap), for: .touchUpInside)
        globalFoodlabel.text = "세계음식"
        globalFoodlabel.adjustsFontSizeToFitWidth = true
        globalFoodlabel.textColor = .gray
        globalFoodlabel.backgroundColor = .white
        globalFoodlabel.textAlignment = .center
        globalFoodlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))

        
        globalFoodButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
            $0.top.equalTo(koreanFoodlabel.snp.bottom).offset(30)
        }
        
        globalFoodlabel.snp.makeConstraints {
            $0.top.equalTo(globalFoodButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(globalFoodButton)
            $0.height.equalTo(8)
        }
        
        buffetButton.setImage(UIImage(named: "Buffet_deselected"), for: .normal)
        buffetButton.setImage(UIImage(named: "Buffet_selected"), for: .selected)
        buffetButton.addTarget(self, action:        #selector(buffetButtonDidTap), for: .touchUpInside)
        buffetlabel.text = "뷔페"
        buffetlabel.textColor = .gray
        buffetlabel.backgroundColor = .white
        buffetlabel.textAlignment = .center
        buffetlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))

        
        buffetButton.snp.makeConstraints {
            $0.top.equalTo(globalFoodButton)
            $0.leading.equalTo(globalFoodButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        buffetlabel.snp.makeConstraints {
            $0.top.equalTo(buffetButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(buffetButton)
            $0.height.equalTo(8)
        }
        
        cafeButton.setImage(UIImage(named: "Cafe_deselected"), for: .normal)
        cafeButton.setImage(UIImage(named: "Cafe_selected"), for: .selected)
        cafeButton.imageView?.contentMode = .scaleAspectFit
        cafeButton.addTarget(self, action:        #selector(cafeButtonDidTap), for: .touchUpInside)
        cafelabel.text = "카페"
        cafelabel.font = UIFont(name: "Helvetica", size: CGFloat(10))
        cafelabel.textColor = .gray
        cafelabel.backgroundColor = .white
        cafelabel.textAlignment = .center

        cafeButton.snp.makeConstraints {
            $0.top.equalTo(globalFoodButton)
            $0.leading.equalTo(buffetButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        cafelabel.snp.makeConstraints {
            $0.top.equalTo(cafeButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(cafeButton)
            $0.height.equalTo(8)
        }
        
        liquorButton.setImage(UIImage(named: "Drinks_deselected"), for: .normal)
        liquorButton.setImage(UIImage(named: "Drinks_selected"), for: .selected)
        liquorButton.imageView?.contentMode = .scaleAspectFit
        liquorButton.addTarget(self, action:        #selector(liquorButtonDidTap), for: .touchUpInside)
        liquorlabel.text = "주점"
        liquorlabel.font = UIFont(name: "Helvetica", size: CGFloat(10))
        liquorlabel.textColor = .gray
        liquorlabel.backgroundColor = .white
        liquorlabel.textAlignment = .center
        
        liquorButton.snp.makeConstraints {
            $0.top.equalTo(globalFoodButton)
            $0.leading.equalTo(cafeButton.snp.trailing).offset((view.frame.width - 200) / 5)
            $0.width.height.equalTo(50)
        }
        
        liquorlabel.snp.makeConstraints {
            $0.top.equalTo(liquorButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(liquorButton)
            $0.height.equalTo(8)
        }

    }
    
    @objc func locationButtonDidTap(_ sender: UIButton) {
        performSegue(withIdentifier: "showLocationSelectView", sender: self)
    }
    
    // 자동완성된 주소를 받기 위한 프로토콜 채택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationSelectView" {
            let viewController: LocationSelectViewController = segue.destination as! LocationSelectViewController
                viewController.delegate = self
        }
    }
    
    
    
    @objc func koreanFoodbuttonDidTap(_ sender: UIButton) {

        if koreanFoodButton.isSelected == true {
            koreanFoodButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = true
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = false

        }
    }
    
    @objc func japaneseFoodButtonDidTap(_ sender: UIButton) {
        
        if japaneseFoodButton.isSelected == true {
            japaneseFoodButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = true
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func chineseFoodButtonDidTap(_ sender: UIButton) {
        
        if chineseFoodButton.isSelected == true {
            chineseFoodButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = true
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func westernFoodButtonDidTap(_ sender: UIButton) {
        
        if westernFoodButton.isSelected == true {
            westernFoodButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = true
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func globalFoodButtonDidTap(_ sender: UIButton) {
        
        if globalFoodButton.isSelected == true {
            globalFoodButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = true
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func buffetButtonDidTap(_ sender: UIButton) {
        
        if buffetButton.isSelected == true {
            buffetButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = true
            cafeButton.isSelected = false
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func cafeButtonDidTap(_ sender: UIButton) {
        
        if cafeButton.isSelected == true {
            cafeButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = true
            liquorButton.isSelected = false
            
        }
    }
    
    @objc func liquorButtonDidTap(_ sender: UIButton) {
        
        if liquorButton.isSelected == true {
            liquorButton.isSelected = false
        } else {
            koreanFoodButton.isSelected = false
            japaneseFoodButton.isSelected = false
            chineseFoodButton.isSelected = false
            westernFoodButton.isSelected = false
            globalFoodButton.isSelected = false
            buffetButton.isSelected = false
            cafeButton.isSelected = false
            liquorButton.isSelected = true
            
        }
    }
}
// 자동완성된 주소를 주소 텍스트필드에 입력하도록 설정
extension EnrollViewController: SendDataDelegate {
    func sendData(data: String) {
        locationTextField.text = data
    }
}
