//
//  ReviewOnlyViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 17/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class ReviewOnlyViewController: UIViewController {
    var selectedColumnData: ServerStruct.CellDataStruct?  // 초기페이지에서 선택된 셀 데이터 인계받은 인스턴스
    var selectedRatePostArray: [ServerStruct.CellDataStruct.PostStruct?] = []
    var selectedRate: String?
    
    let topGuideView = UIView()
    let selectRateView = UIView()
    let allButtonLabel = UILabel()
    let allButtonUnderBar = UIView()
    let goodButtonLabel = UILabel()
    let goodButtonUnderBar = UIView()
    let sosoButtonLabel = UILabel()
    let sosoButtonUnderBar = UIView()
    let badButtonLabel = UILabel()
    let badButtonUnderBar = UIView()
    let reviewTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        
        topGuideViewConfig()
        selectRateViewConfig()
        reviewTableViewConfig()
        
        // 맛집 상세 페이지에서 맛있다, 괜찮다, 별로 버튼 눌렀을 때 해당 평가 리뷰로 전송
        if selectedRate == "5" {
            goodButtonTapped()
        } else if selectedRate == "3" {
            sosoButtonTapped()
        } else if selectedRate == "1" {
            badButtonTapped()
        } else {
            allButtonTapped()
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
    private func selectRateViewConfig() {
        selectRateView.backgroundColor = .white
        view.addSubview(selectRateView)
        selectRateView.snp.makeConstraints { (m) in
            m.top.equalTo(topGuideView.snp.bottom)
            m.leading.width.trailing.equalToSuperview()
            m.height.equalTo(65)
        }
        
        // 전체 버튼 & 갯수
        let allPostCount = selectedColumnData?.postArray.count ?? 0
        
        allButtonLabel.backgroundColor = .white
        allButtonLabel.numberOfLines = 2
        allButtonLabel.text = "\(allPostCount)\n전체"
        allButtonLabel.textAlignment = .center
        allButtonLabel.font = UIFont(name: "Helvetica", size: 16)
        allButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        selectRateView.addSubview(allButtonLabel)
        allButtonLabel.snp.makeConstraints { (m) in
            m.top.leading.equalToSuperview()
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalToSuperview().inset(3)
        }
        
        let allButton = UIButton()
        selectRateView.addSubview(allButton)
        allButton.snp.makeConstraints { (m) in
            m.edges.equalTo(allButtonLabel)
        }
        allButton.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        
        allButtonUnderBar.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        selectRateView.addSubview(allButtonUnderBar)
        allButtonUnderBar.snp.makeConstraints { (m) in
            m.top.equalTo(allButtonLabel.snp.bottom)
            m.leading.trailing.equalTo(allButtonLabel)
            m.height.equalTo(3)
        }
        
        //  맛있다! 버튼 & 갯수
        let goodPostArray = selectedColumnData?.postArray.filter { $0.reviewRate == 5 }
        let goodPostArrayCount = goodPostArray?.count ?? 0

        goodButtonLabel.backgroundColor = .white
        goodButtonLabel.numberOfLines = 2
        goodButtonLabel.text = "\(goodPostArrayCount)\n맛있다!"
        goodButtonLabel.textAlignment = .center
        goodButtonLabel.font = UIFont(name: "Helvetica", size: 16)
        goodButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)

        selectRateView.addSubview(goodButtonLabel)
        goodButtonLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.leading.equalTo(allButtonLabel.snp.trailing)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalToSuperview().inset(3)
        }

        let goodButton = UIButton()
        selectRateView.addSubview(goodButton)
        goodButton.snp.makeConstraints { (m) in
            m.edges.equalTo(goodButtonLabel)
        }
        goodButton.addTarget(self, action: #selector(goodButtonTapped), for: .touchUpInside)

        goodButtonUnderBar.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        selectRateView.addSubview(goodButtonUnderBar)
        goodButtonUnderBar.snp.makeConstraints { (m) in
            m.top.equalTo(goodButtonLabel.snp.bottom)
            m.leading.trailing.equalTo(goodButtonLabel)
            m.height.equalTo(3)
        }
        
        //  괜찮다 버튼 & 갯수
        let sosoPostArray = selectedColumnData?.postArray.filter { $0.reviewRate == 3 }
        let sosoPostArrayCount = sosoPostArray?.count ?? 0
        
        sosoButtonLabel.backgroundColor = .white
        sosoButtonLabel.numberOfLines = 2
        sosoButtonLabel.text = "\(sosoPostArrayCount)\n괜찮다"
        sosoButtonLabel.textAlignment = .center
        sosoButtonLabel.font = UIFont(name: "Helvetica", size: 16)
        sosoButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        selectRateView.addSubview(sosoButtonLabel)
        sosoButtonLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.leading.equalTo(goodButtonLabel.snp.trailing)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalToSuperview().inset(3)
        }
        
        let sosoButton = UIButton()
        selectRateView.addSubview(sosoButton)
        sosoButton.snp.makeConstraints { (m) in
            m.edges.equalTo(sosoButtonLabel)
        }
        sosoButton.addTarget(self, action: #selector(sosoButtonTapped), for: .touchUpInside)
        
        sosoButtonUnderBar.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        selectRateView.addSubview(sosoButtonUnderBar)
        sosoButtonUnderBar.snp.makeConstraints { (m) in
            m.top.equalTo(sosoButtonLabel.snp.bottom)
            m.leading.trailing.equalTo(sosoButtonLabel)
            m.height.equalTo(3)
        }
        
        //  별로 버튼 & 갯수
        let badPostArray = selectedColumnData?.postArray.filter { $0.reviewRate == 1 }
        let badPostArrayCount = badPostArray?.count ?? 0
        
        badButtonLabel.backgroundColor = .white
        badButtonLabel.numberOfLines = 2
        badButtonLabel.text = "\(badPostArrayCount)\n별로"
        badButtonLabel.textAlignment = .center
        badButtonLabel.font = UIFont(name: "Helvetica", size: 16)
        badButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        selectRateView.addSubview(badButtonLabel)
        badButtonLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.leading.equalTo(sosoButtonLabel.snp.trailing)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalToSuperview().inset(3)
        }
        
        let badButton = UIButton()
        selectRateView.addSubview(badButton)
        badButton.snp.makeConstraints { (m) in
            m.edges.equalTo(badButtonLabel)
        }
        badButton.addTarget(self, action: #selector(badButtonTapped), for: .touchUpInside)
        
        badButtonUnderBar.backgroundColor = #colorLiteral(red: 0.913626194, green: 0.9137828946, blue: 0.9136161804, alpha: 1)
        selectRateView.addSubview(badButtonUnderBar)
        badButtonUnderBar.snp.makeConstraints { (m) in
            m.top.equalTo(badButtonLabel.snp.bottom)
            m.leading.trailing.equalTo(badButtonLabel)
            m.height.equalTo(3)
        }
    }
    @objc private func allButtonTapped() {
        allButtonLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        allButtonUnderBar.backgroundColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        goodButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        if let tempArray = selectedColumnData?.postArray {
            selectedRatePostArray = tempArray
        } else {
            selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
        }
        reviewTableView.reloadData()
    }
    @objc private func goodButtonTapped() {
        allButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        allButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        goodButtonUnderBar.backgroundColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        sosoButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 5 }) {
            selectedRatePostArray = tempArray
        } else {
            selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
        }
        reviewTableView.reloadData()
    }
    @objc private func sosoButtonTapped() {
        allButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        allButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        sosoButtonUnderBar.backgroundColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        badButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 3 }) {
            selectedRatePostArray = tempArray
        } else {
            selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
        }
        reviewTableView.reloadData()
    }
    @objc private func badButtonTapped() {
        allButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        allButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        goodButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonLabel.textColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        sosoButtonUnderBar.backgroundColor = #colorLiteral(red: 0.8399392962, green: 0.8399392962, blue: 0.8399392962, alpha: 1)
        badButtonLabel.textColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        badButtonUnderBar.backgroundColor = #colorLiteral(red: 0.9768021703, green: 0.478310287, blue: 0.1709150374, alpha: 1)
        
        if let tempArray = (selectedColumnData?.postArray.filter { $0.reviewRate == 1 }) {
            selectedRatePostArray = tempArray
        } else {
            selectedRatePostArray = (selectedColumnData?.postArray ?? nil)!
        }
        reviewTableView.reloadData()
    }
    private func reviewTableViewConfig() {
        // reviewTableView Setting
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewCell")
        
        // 테이블뷰 레이아웃 설정
        view.addSubview(reviewTableView)
        reviewTableView.snp.makeConstraints { (m) in
            m.top.equalTo(selectRateView.snp.bottom).offset(10)
            m.leading.equalToSuperview().offset(10)
            m.trailing.equalToSuperview().inset(10)
            m.bottom.equalToSuperview().inset(10)
        }
    }
}
extension ReviewOnlyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let postCount = selectedRatePostArray.count
        return postCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = .none  // 터치해도 색 변하지 않음
        
        // 리뷰어 프로필 사진 가져오기
        if let urlString = selectedRatePostArray[indexPath.row]?.author.authorImage,
            let url = URL(string: urlString) {
            cell.authorImageView.kf.setImage(with: url)
        } else {
            cell.authorImageView.image = UIImage(named: "defaultImage")
        }
        
        // 리뷰어 이름 가져오기
        cell.authorName.text = selectedRatePostArray[indexPath.row]?.author.authorName
        
        // 맛있다, 좋아요, 별로 이미지와 라벨 표시
        switch selectedRatePostArray[indexPath.row]?.reviewRate {
        case 1:
            cell.reviewRate.image = UIImage(named: "BadFace")
            cell.reviewRateLabel.text = "별로"
        case 3:
            cell.reviewRate.image = UIImage(named: "SosoFace")
            cell.reviewRateLabel.text = "괜찮다"
        case 5:
            cell.reviewRate.image = UIImage(named: "GoodFace")
            cell.reviewRateLabel.text = "맛있다!"
        default:
            print("평가 이상")
        }

        // 리뷰 내용
        cell.reviewContent.text = selectedRatePostArray[indexPath.row]?.reviewContent

        // 리뷰 이미지
        let reviewImageUrl: String
        if let post = selectedRatePostArray[indexPath.row],
            let reviewImage = post.reviewImage,
            !reviewImage.isEmpty {
            reviewImageUrl = reviewImage[0].reviewImageUrl
        } else {
            reviewImageUrl = "defaultImage"
        }

        if let url = URL(string: reviewImageUrl) {
            cell.reviewContentImage.kf.setImage(with: url)
        } else if reviewImageUrl == "defaultImage" {
            cell.reviewContentImage.image = UIImage(named: "defaultImage")
        } else {
            cell.reviewContentImage.image = UIImage(named: "defaultImage")
        }
        return cell
    }
}
extension ReviewOnlyViewController: UITableViewDelegate {
    // 리뷰 테이블 뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    // 리뷰 터치시 액션
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 컬럼 데이터를 넘겨버림
        let destination = ReviewDetailViewController()
        destination.selectedColumnData = selectedColumnData
        destination.selectedPostData = selectedRatePostArray[indexPath.row]
        
        // 화면 전환 액션
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(destination, animated: false, completion: nil) // ----->>>> 화면 전환후 터치를 해야 본 화면으로 바뀜(상담 필요)
    }
}
