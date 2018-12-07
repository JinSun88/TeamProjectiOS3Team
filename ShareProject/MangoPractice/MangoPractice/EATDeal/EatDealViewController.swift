//
//  TopListViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 19/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

typealias TopListViewController = [PurpleTopListViewController]

struct PurpleTopListViewController: Codable {
    let pk: Int
    let name: String
    let address: Address
    let addressDetail, phoneNum, foodType, priceLevel: String
    let parking: Parking
    let businessHour, breakTime, lastOrder: String
    let holiday: Holiday
    let website: Website
    let viewNum, reviewNum, wantNum: Int
    let createdAt, modifiedAt: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case pk, name, address
        case addressDetail = "address_detail"
        case phoneNum = "phone_num"
        case foodType = "food_type"
        case priceLevel = "price_level"
        case parking
        case businessHour = "Business_hour"
        case breakTime = "break_time"
        case lastOrder = "last_order"
        case holiday, website
        case viewNum = "view_num"
        case reviewNum = "review_num"
        case wantNum = "want_num"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case latitude, longitude
    }
}

enum Address: String, Codable {
    case 서울시성동구 = "서울시 성동구"
}

enum Holiday: String, Codable {
    case empty = ""
    case 월 = "월"
    case 일 = "일"
}

enum Parking: String, Codable {
    case 무료주차가능 = "무료주차 가능"
    case 주차공간없음 = "주차공간없음"
}

enum Website: String, Codable {
    case empty = ""
}




class EatDealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let urlString = "https://api.fastplate.xyz/api/restaurants/list/"
    
    var pk = [Int]()
    var name = [String]()
    var address = [String]()
    var adressDetail = [String]()
    var phoneNum = [String]()
    var foodType = [String]()
    var priceLevel = [String]()
    var parking = [String]()
    var businessHour = [String]()
    var breakTime = [String]()
    var lastOrder = [String]()
    var holiday = [String]()
    var website = [String]()
    var viewNum = [Int]()
    var reviewNum = [Int]()
    var wantNum = [Int]()
    var createdAt = [String]()
    var modifiedAt = [String]()
    var latitude = [Double]()
    var longitude = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getData()   -->> [진성] 서버 구조 달라지면 앱다운 되서 일단 주석 처리 했습니다
        
    }
    
    
    func getData() {
        
        let url = URL(string: urlString)!
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let jsonData = try! JSONDecoder().decode([PurpleTopListViewController].self, from: data)
            
            for i in jsonData.makeIterator() {
                self.pk.append(i.pk)
                self.name.append(i.name)
                self.address.append(i.address.rawValue)
                self.adressDetail.append(i.addressDetail)
                self.phoneNum.append(i.phoneNum)
                self.foodType.append(i.foodType)
                self.priceLevel.append(i.priceLevel)
                self.parking.append(i.parking.rawValue)
                self.businessHour.append(i.businessHour)
                self.breakTime.append(i.breakTime)
                self.lastOrder.append(i.lastOrder)
                self.holiday.append(i.holiday.rawValue)
                self.website.append(i.website.rawValue)
                self.viewNum.append(i.viewNum)
                self.reviewNum.append(i.reviewNum)
                self.wantNum.append(i.wantNum)
                self.createdAt.append(i.createdAt)
                self.modifiedAt.append(i.modifiedAt)
                self.latitude.append(i.latitude)
                self.longitude.append(i.longitude)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "eatDealCell", for: indexPath) as! EatDealTableViewCell
        
        cell.mainLabel.text = self.name[indexPath.row]
        cell.subLabel.text = self.foodType[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
