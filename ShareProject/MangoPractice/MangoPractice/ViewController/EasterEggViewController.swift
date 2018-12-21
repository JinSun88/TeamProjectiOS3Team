//
//  EasterEggViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class EasterEggViewController: UIViewController {
    
    let topGuideView = UIView()
    let scrollView = UIScrollView()
    let contentsView = UIView()
    let reviewContent = UILabel()
    let reviewImageScrollView = UIScrollView() // 횡스크롤뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topGuideViewConfig()
        scrollViewConfig()
        contentsViewConfig()
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
        let leftArrow = UIButton()
        let leftArrowImage = UIImage(named: "leftArrowWhite")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        leftArrow.setBackgroundImage(leftArrowImage, for: .normal)
        leftArrow.imageView?.contentMode = .scaleAspectFit
        
        let window = UIApplication.shared.keyWindow
        guard let unsafeHeight = window?.safeAreaInsets.top else { return }
        let unsafeHeightHalf = unsafeHeight / 2
        
        topGuideView.addSubview(leftArrow)
        leftArrow.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview().offset(unsafeHeightHalf)
            m.leading.equalToSuperview().offset(15)
            m.height.equalTo(30)
            m.width.equalTo(30)
        }
        leftArrow.addTarget(self, action: #selector(leftArrowAction), for: .touchUpInside)
        

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
    private func scrollViewConfig() {
        view.addSubview(scrollView)
        scrollView.backgroundColor =  #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.leading.trailing.equalTo(view)
            m.bottom.equalTo(view)
        }
    }
    private func contentsViewConfig() {
        contentsView.backgroundColor = .white
        
        // 콘텐츠뷰 콘피그
        scrollView.addSubview(contentsView)
        contentsView.snp.makeConstraints { (m) in
            m.top.bottom.equalTo(scrollView).inset(10)
            m.left.right.equalTo(view).inset(10)
        }
        
        let text = UITextView()
        text.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        contentsView.addSubview(text)
        text.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalTo(300)
        }
        
        text.text = "만든 사람들\r\n\r\n백엔드 개발자 박지호\r\n백엔드 개발자 정몽교\r\n\r\n프론트엔드 개발자 신창선\r\n프론트엔드 개발자 안재현\r\n프론트엔드 개발자 조민지\r\n\r\niOS 개발자 김진선\r\niOS 개발자 김양우\r\niOS 개발자 허진성"
        text.font = UIFont(name: "Helvetica", size: 20)
        
        let imageView = UIImageView()
        contentsView.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.top.equalTo(text.snp.bottom).offset(10)
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(300)
        }
        imageView.image = UIImage(named: "allPic")
        
        let text2 = UILabel()
        contentsView.addSubview(text2)
        text2.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom)
            m.leading.trailing.equalToSuperview()
            m.bottom.equalToSuperview()
        }
        
        text2.text = "이제 새로운 시작입니다! 동기 여러분 모두 화이팅!!"
        text2.textColor = .red
    }
    
    
}



