//
//  PlateMoreInfoViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 10/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class PlateMoreInfoViewController: UIViewController {

    var selectedColumnData: ServerStruct.CellDataStruct?  // 초기페이지에서 선택된 셀 데이터 인계받은 인스턴스
    let backgroundView = UIView()
    let topGuideView = UIView()
    let infoView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundViewConfig()
        topGuideViewConfig()
        infoViewConfig()
    }
    private func backgroundViewConfig() {
        backgroundView.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    private func topGuideViewConfig() {
        // 가장위에 라벨(topGuideView) 작성, 위치 잡기
        topGuideView.backgroundColor =  #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        view.addSubview(topGuideView)
        topGuideView.snp.makeConstraints { (m) in
            m.top.width.equalToSuperview()
            m.height.equalTo(80)
        }
        
        // leftArrow 버튼 설정
        let window = UIApplication.shared.keyWindow
        guard let unsafeHeight = window?.safeAreaInsets.top else { return }
        let unsafeHeightHalf = unsafeHeight / 2
        
        let leftArrow = UIButton()
        let leftArrowImage = UIImage(named: "leftArrowWhite")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        leftArrow.setBackgroundImage(leftArrowImage, for: .normal)
        leftArrow.imageView?.contentMode = .scaleAspectFit
        
        topGuideView.addSubview(leftArrow)
        leftArrow.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview().offset(unsafeHeightHalf)
            m.leading.equalToSuperview().offset(15)
            m.height.equalTo(30)
            m.width.equalTo(30)
        }
        leftArrow.addTarget(self, action: #selector(leftArrowAction), for: .touchUpInside)
    
        // restaurant Name display
        let restaurantNameLabel = UILabel()
        restaurantNameLabel.textColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        restaurantNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        restaurantNameLabel.text = selectedColumnData?.name ?? "@@"
        
        topGuideView.addSubview(restaurantNameLabel)
        restaurantNameLabel.snp.makeConstraints { (m) in
            m.trailing.bottom.equalToSuperview()
            m.centerY.equalTo(leftArrow.snp.centerY)
            m.leading.equalTo(leftArrow.snp.trailing).offset(15)
        }
    }
    @objc private func leftArrowAction() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    private func infoViewConfig() {
        infoView.backgroundColor = .white
        backgroundView.addSubview(infoView)
        infoView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom).offset(10)
            m.leading.equalToSuperview().offset(10)
            m.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        // "편의정보" 텍스트 라벨
        let convinienceInfoLabel = UILabel()
        convinienceInfoLabel.text = "편의정보"
        convinienceInfoLabel.font = UIFont(name: "Helvetica", size: 17)
        convinienceInfoLabel.textColor = #colorLiteral(red: 0.3943242431, green: 0.3943242431, blue: 0.3943242431, alpha: 1)
        
        infoView.addSubview(convinienceInfoLabel)
        convinienceInfoLabel.snp.makeConstraints { (m) in
            m.top.leading.equalToSuperview().offset(10)
        }
        
        // "마지막 업데이트" 데이터 라벨
        let modifiedAtLabel = UILabel()
        let dateString = selectedColumnData!.modifiedAt ?? "^^"  // 서버에서 받는 날짜 정보(String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"  // 서버에서 받는 날짜 포멧 통보
        let dateReal = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd" // 내가 쓰고 싶은 날짜 포멧 지정
        modifiedAtLabel.text = "마지막 업데이트: \(dateFormatter.string(from: dateReal!))"
        modifiedAtLabel.textAlignment = .right
        modifiedAtLabel.textColor = .lightGray // #colorLiteral(red: 0.8900991082, green: 0.8902520537, blue: 0.8900895715, alpha: 1)
        modifiedAtLabel.font = UIFont(name: "Helvetica", size: 12)
    
        infoView.addSubview(modifiedAtLabel)
        modifiedAtLabel.snp.makeConstraints { (m) in
            m.top.height.equalTo(convinienceInfoLabel)
            m.trailing.equalToSuperview().inset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        
        // "영업시간" 텍스트 라벨
        let bizHourLabel = UILabel()
        infoView.addSubview(bizHourLabel)
        bizHourLabel.snp.makeConstraints { (m) in
            m.top.equalTo(convinienceInfoLabel.snp.bottom).offset(10)
            m.leading.equalTo(convinienceInfoLabel)
            m.width.equalTo(80)
            m.height.equalTo(25)
        }
        bizHourLabel.text = "영업시간"
        bizHourLabel.textColor = .gray
        bizHourLabel.font = UIFont(name: "Helvetica", size: 15)
        
        // "영업시간" 데이터 라벨
        let bizHourDataLabel = UILabel()
        guard let rawBizHourData = selectedColumnData?.businessHour else { return }
        let bizHourData = rawBizHourData
        bizHourDataLabel.textAlignment = .right
        bizHourDataLabel.text = "\(bizHourData)"
        
        if rawBizHourData.contains("\r\n") {  // rawBizHourData에 \r\n(서버데이터)이 포함되어 있으면 2줄처리
            bizHourDataLabel.numberOfLines = 2
        } else {
            bizHourDataLabel.numberOfLines = 1
        }
        
        bizHourDataLabel.textColor = .black
        bizHourDataLabel.font = UIFont(name: "Helvetica", size: 15)
        
        infoView.addSubview(bizHourDataLabel)
        bizHourDataLabel.snp.makeConstraints { (m) in
            m.top.equalTo(bizHourLabel)
            if rawBizHourData.contains("\r\n") {  // rawBizHourData에 \r\n(서버데이터)이 포함되어 라벨폭을 1.8배로
                m.height.equalTo(bizHourLabel).multipliedBy(1.8)
            } else {
                m.height.equalTo(bizHourLabel)
            }
            m.trailing.equalToSuperview().inset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        
        // "쉬는시간" 텍스트 라벨 & 데이터 라벨
        let restHourLabel = UILabel()
        let restHourDataLabel = UILabel()
        let restHourData = selectedColumnData?.breakTime ?? ""
        
        if restHourData == "" {  // restHourData에 데이터가 없을 때
            infoView.addSubview(restHourLabel)
            restHourLabel.snp.makeConstraints { (m) in
                m.top.equalTo(bizHourDataLabel.snp.bottom)
                m.leading.equalTo(convinienceInfoLabel)
                m.width.equalTo(80)
                m.height.equalTo(0)
            }
        } else {  // restHourData에 데이터가 있을 때
            infoView.addSubview(restHourLabel)
            restHourLabel.snp.makeConstraints { (m) in
                m.top.equalTo(bizHourDataLabel.snp.bottom).offset(10)
                m.leading.equalTo(convinienceInfoLabel)
                m.width.equalTo(80)
                m.height.equalTo(25)
            }
            restHourLabel.text = "쉬는시간"
            restHourLabel.textColor = .gray
            restHourLabel.font = UIFont(name: "Helvetica", size: 15)
            
            infoView.addSubview(restHourDataLabel)
            restHourDataLabel.snp.makeConstraints { (m) in
                m.top.height.equalTo(restHourLabel)
                m.trailing.equalToSuperview().inset(10)
                m.width.equalToSuperview().multipliedBy(0.5)
            }
            
            restHourDataLabel.text = "\(restHourData)"
            restHourDataLabel.textColor = .black
            restHourDataLabel.font = UIFont(name: "Helvetica", size: 15)
            restHourDataLabel.textAlignment = .right
        }
        
        // "휴일" 텍스트 라벨 & 데이터 라벨
        let restDayLabel = UILabel()
        let restDayDataLabel = UILabel()
        let restDayData = selectedColumnData?.holiday ?? ""
        
        if restDayData == "" {  // restDayData에 데이터가 없을 때
            infoView.addSubview(restDayLabel)
            restDayLabel.snp.makeConstraints { (m) in
                m.top.equalTo(restHourLabel.snp.bottom)
                m.leading.equalTo(convinienceInfoLabel)
                m.width.equalTo(80)
                m.height.equalTo(0)
            }
        } else {  // restDayData에 데이터가 있을 때
            infoView.addSubview(restDayLabel)
            restDayLabel.snp.makeConstraints { (m) in
                m.top.equalTo(restHourLabel.snp.bottom).offset(10)
                m.leading.equalTo(convinienceInfoLabel)
                m.width.equalTo(80)
                m.height.equalTo(25)
            }
            restDayLabel.text = "휴일"
            restDayLabel.textColor = .gray
            restDayLabel.font = UIFont(name: "Helvetica", size: 15)
            
            infoView.addSubview(restDayDataLabel)
            restDayDataLabel.snp.makeConstraints { (m) in
                m.top.height.equalTo(restDayLabel)
                m.trailing.equalToSuperview().inset(10)
                m.width.equalToSuperview().multipliedBy(0.5)
            }
            
            restDayDataLabel.text = "\(restDayData)"
            restDayDataLabel.textColor = .black
            restDayDataLabel.font = UIFont(name: "Helvetica", size: 15)
            restDayDataLabel.textAlignment = .right
        }
        
//        // "가격정보" 텍스트 라벨 & 데이터 라벨
//        let restDayLabel = UILabel()
//        let restDayDataLabel = UILabel()
//        let restDayData = selectedColumnData?.holiday ?? ""
//
//        if restDayData == "" {  // restDayData에 데이터가 없을 때
//            infoView.addSubview(restDayLabel)
//            restDayLabel.snp.makeConstraints { (m) in
//                m.top.equalTo(restHourLabel.snp.bottom)
//                m.leading.equalTo(convinienceInfoLabel)
//                m.width.equalTo(80)
//                m.height.equalTo(0)
//            }
//        } else {  // restDayData에 데이터가 있을 때
//            infoView.addSubview(restDayLabel)
//            restDayLabel.snp.makeConstraints { (m) in
//                m.top.equalTo(restHourLabel.snp.bottom).offset(10)
//                m.leading.equalTo(convinienceInfoLabel)
//                m.width.equalTo(80)
//                m.height.equalTo(25)
//            }
//            restDayLabel.text = "휴일"
//            restDayLabel.textColor = .gray
//            restDayLabel.font = UIFont(name: "Helvetica", size: 15)
//
//            infoView.addSubview(restDayDataLabel)
//            restDayDataLabel.snp.makeConstraints { (m) in
//                m.top.height.equalTo(restDayLabel)
//                m.trailing.equalToSuperview().inset(10)
//                m.width.equalToSuperview().multipliedBy(0.5)
//            }
//
//            restDayDataLabel.text = "\(restDayData)"
//            restDayDataLabel.textColor = .black
//            restDayDataLabel.font = UIFont(name: "Helvetica", size: 15)
//            restDayDataLabel.textAlignment = .right
//        }
    }
}
