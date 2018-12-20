//
//  PostData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 19/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct PostData: Decodable {
    let postPk: Int
    let restaurant: Int
    let rate: Int
    let content: String

    enum  CodingKeys: String, CodingKey {
        case postPk = "pk"
        case restaurant
        case rate
        case content
    }
}

struct want2goData: Decodable {
    let pk: Int
    let restaurant: Int
}

struct checkInData: Decodable {
    let pk: Int
    let restaurant: Int
}
