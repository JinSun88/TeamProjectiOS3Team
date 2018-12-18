//
//  data.swift
//  final
//
//  Created by yang on 03/12/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import Foundation
import UIKit

struct EatDealData: Codable {
    let count: Int
    let next, previous: String?
    let results: [Result]
}

struct Result: Codable {
    let restaurant: Int
    let dealName, subName, startDate, endDate: String
    let basePrice, discountRate, discountPrice: Int
    let introduceRes, introduceMenu, caution, howToUse: String
    let refund, inquiry: String
    let eatdealimages: [Eatdealimage]
    
    
    enum CodingKeys: String, CodingKey {
        case restaurant
        case dealName = "deal_name"
        case subName = "sub_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case basePrice = "base_price"
        case discountRate = "discount_rate"
        case discountPrice = "discount_price"
        case introduceRes = "introduce_res"
        case introduceMenu = "introduce_menu"
        case caution
        case howToUse = "how_to_use"
        case refund, inquiry, eatdealimages
    }
    
}

struct Eatdealimage: Codable {
    let pk: Int
    let image: String
}

