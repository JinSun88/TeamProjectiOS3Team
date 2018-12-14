//
//  ReviewDetailViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 14/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {
    
    var selectedColumnData: ServerStruct.CellDataStruct?  // 초기페이지에서 선택된 셀 데이터 인계받은 인스턴스
    let topGuideView = UIView()
    let scrollView = UIScrollView()
    let contentsView = UIView()
    
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
        
        // restaurant Name display
        let restaurantNameLabel = UILabel()
        restaurantNameLabel.textColor = UIColor(red: 243/255, green: 242/255, blue: 243/255, alpha: 1)
        restaurantNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        restaurantNameLabel.text = "\(selectedColumnData?.name ?? "Plate")의 리뷰"
        
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
    private func scrollViewConfig() {
        view.addSubview(scrollView)
        scrollView.backgroundColor =  #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.leading.trailing.bottom.equalTo(view)
        }
    }
    private func contentsViewConfig() {
        contentsView.backgroundColor = .white
        scrollView.addSubview(contentsView)
        contentsView.snp.makeConstraints { (m) in
            m.top.bottom.equalTo(scrollView).inset(10)
            m.leading.trailing.equalTo(view).inset(10)
        }
        
        let label1 = UILabel()
        contentsView.addSubview(label1)
        label1.numberOfLines = 0
        label1.text = "sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds"
        
        label1.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentsView).inset(20) // left/right padding 20pt
            make.top.equalTo(contentsView).offset(20) // attached to the top of the contentview with padding 20pt
        }
        
        let label2 = UILabel()
        contentsView.addSubview(label2)
        label2.numberOfLines = 0
        label2.text = "sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds"
        
        label2.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentsView).inset(20) // left/right padding 20pt
            make.top.equalTo(label1.snp.bottom).offset(20) // below label1 with margin 20pt
            make.bottom.equalTo(contentsView).offset(-20) // attached to the bottom of the contentview with padding 20pt
        }
    }
}
