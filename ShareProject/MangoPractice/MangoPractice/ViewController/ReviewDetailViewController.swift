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
    var selectedPostData: ServerStruct.CellDataStruct.PostStruct?
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
        
        // 리뷰어 이미지
        let authorImageView = UIImageView()
        contentsView.addSubview(authorImageView)
        authorImageView.snp.makeConstraints { (m) in
            m.top.leading.equalTo(contentsView).offset(10)
            m.width.height.equalTo(50)
        }
        if let urlString = selectedPostData?.author.authorImage,
            let url = URL(string: urlString) {
            authorImageView.kf.setImage(with: url)
        } else {
            authorImageView.image = UIImage(named: "defaultImage")
        }
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.layer.cornerRadius = 25
        authorImageView.clipsToBounds = true
        
        // 리뷰어 이름
        let authorName = UILabel()
        contentsView.addSubview(authorName)
        authorName.snp.makeConstraints { (m) in
            m.centerY.height.equalTo(authorImageView)
            m.leading.equalTo(authorImageView.snp.trailing).offset(10)
            m.width.equalToSuperview().multipliedBy(0.5)
        }
        authorName.font = UIFont(name: "Helvetica", size: 20)
        if let authorNameData = selectedPostData?.author.authorName {
            authorName.text = authorNameData
        } else {
            authorName.text = "@@"
        }
        
        // 리뷰어 평가 (맛있다, 괜찮다, 별로 이미지 & 텍스트)
        let reviewRate = UIImageView()
        let reviewRateLabel = UILabel()
        contentsView.addSubview(reviewRate)
        reviewRate.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(10)
            m.trailing.equalToSuperview().inset(10)
            m.width.height.equalTo(30)
        }
        contentsView.addSubview(reviewRateLabel)
        reviewRateLabel.snp.makeConstraints { (m) in
            m.top.equalTo(reviewRate.snp.bottom).offset(3)
            m.centerX.equalTo(reviewRate)
        }
        reviewRateLabel.font = UIFont(name: "Helvetica", size: 12)
        reviewRateLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        
        switch selectedPostData?.reviewRate {
        case 1:
            reviewRate.image = UIImage(named: "BadFace")
            reviewRateLabel.text = "별로"
        case 3:
            reviewRate.image = UIImage(named: "SosoFace")
            reviewRateLabel.text = "괜찮다"
        case 5:
            reviewRate.image = UIImage(named: "GoodFace")
            reviewRateLabel.text = "맛있다!"
        default:
            print("평가 이상")
        }
        
        // 리뷰 내용
        let reviewContent = UILabel()
        contentsView.addSubview(reviewContent)
        reviewContent.snp.makeConstraints { (m) in
            m.top.equalTo(authorImageView.snp.bottom).offset(5)
            m.leading.equalTo(authorImageView)
            m.trailing.equalTo(reviewRate)
        }
        reviewContent.numberOfLines = 0
        reviewContent.font = UIFont(name: "Helvetica", size: 15)
        reviewContent.textColor = #colorLiteral(red: 0.175379917, green: 0.175379917, blue: 0.175379917, alpha: 1)
        if let reviewContentData = selectedPostData?.reviewContent {
            reviewContent.text = reviewContentData
        } else {
            reviewContent.text = "@@"
        }
        
        // 리뷰 내용 밑에 이미지
        let reviewContentImage = UIImageView()
        let reviewImageCount = selectedPostData?.reviewImage?.count ?? 0
        if reviewImageCount > 0,
            let reviewContentImageData = selectedPostData?.reviewImage?[0].reviewImageUrl,
            let imageUrl = URL(string: reviewContentImageData) {
            reviewContentImage.kf.setImage(with: imageUrl)
        } else {
            reviewContentImage.image = UIImage(named: "defaultImage")
        }
        
        contentsView.addSubview(reviewContentImage)
        reviewContentImage.snp.makeConstraints { (m) in   // ---->> 이미지 사이즈에 공백!!!
            m.top.equalTo(reviewContent.snp.bottom).offset(10)
            m.left.right.equalTo(contentsView).inset(10)
            m.bottom.equalTo(contentsView).inset(10)
        }
        reviewContentImage.contentMode = .scaleAspectFit
        reviewContentImage.layer.masksToBounds = true
    }
}
