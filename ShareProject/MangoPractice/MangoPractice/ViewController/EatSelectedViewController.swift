//
//  EatSelectedViewController.swift
//  final
//
//  Created by yang on 03/12/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import UIKit

class EatSelectedViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dealNameView: UILabel!
    @IBOutlet weak var subNameView: UILabel!
    @IBOutlet weak var startEndLabel: UILabel!
    @IBOutlet weak var basePriceLabel: UILabel!
    @IBOutlet weak var discountRateLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var introduceResLabel: UILabel!
    @IBOutlet weak var introduceMenuLabel: UILabel!
    @IBOutlet weak var cautionLabel: UILabel!
    @IBOutlet weak var howToUseLabel: UILabel!
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var inquiryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var mainImages = UIImage()
    var dealName = String()
    var subName = String()
    var startDate = String()
    var endDate = String()
    var basePrice = Int()
    var discountRate = Int()
    var discountPrice = Int()
    var descriptions = String()
    var introduceRes = String()
    var introduceMenu = String()
    var caution = String()
    var howToUse = String()
    var refund = String()
    var inquiry = String()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelPush()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        returnBeforeView()
    }
    
    func returnBeforeView() {
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipedByUser(_:)))
        leftSwipeGesture.direction = .right
        self.view.addGestureRecognizer(leftSwipeGesture)
    }
    
    @objc func leftSwipedByUser(_ gesture: UISwipeGestureRecognizer) {

        dismiss(animated: true, completion: nil)

    }
    @IBAction func unwindToEatSelectedViewController(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func orderButtonDidSelected(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eatOrderViewController = storyboard.instantiateViewController(withIdentifier: "EatOrderViewController") as! EatOrderViewController

        eatOrderViewController.orderImage = self.mainImages
        eatOrderViewController.dealName = self.dealName
        eatOrderViewController.subName = self.subName
        eatOrderViewController.price = self.discountPrice
        eatOrderViewController.totalPrice = self.discountPrice
        
        present(eatOrderViewController, animated: true, completion: nil)
    }

    func labelPush() {
        
        self.mainImageView.image = mainImages
        self.dealNameView.text = dealName
        self.subNameView.text = subName
        self.startEndLabel.text = "사용기간: \(startDate) ~ \(endDate)"
        self.basePriceLabel.attributedText = "￦\(basePrice.withComma)".strikeThrough()
        self.discountRateLabel.text = "\(discountRate)%"
        self.discountPriceLabel.text = "￦\(discountPrice.withComma)"
        self.descriptionLabel.text = descriptions
        self.introduceResLabel.text = "● 식당 소개\n\n\(introduceRes)"
        self.introduceMenuLabel.text = "● 메뉴 소개\n\n\(introduceMenu)"
        self.cautionLabel.text = "❗️유의 사항 (꼭! 확인해주세요)\n\n\(caution)"
        self.howToUseLabel.text = "❗️사용 방법\n\n\(howToUse)"
        self.refundLabel.text = "❗️환불 규정\n\n\(refund)"
        self.inquiryLabel.text = "📮 문의\n\n\(inquiry)"
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
extension Int {
    var withComma: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: self as NSNumber)!
    }
}
