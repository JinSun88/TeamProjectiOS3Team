//
//  LoginData.swift
//  MangoPractice
//
//  Created by jinsunkim on 19/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct LoginData: Decodable {
    let token: String
    let user: UserData
    
    struct UserData: Decodable {
        let fullName: String
        let userImage: String?
        let pk: Int
        let userName: String
        let wannaGo: [wannaGoStruct]?
        let checkIn: [checkInStruct]?
        
        struct checkInStruct: Decodable {
            let pk: Int
            let restaurant: Int
        }
        
        struct wannaGoStruct: Decodable {
            let pk: Int
            let restaurant: Int
        }
        
        enum  CodingKeys: String, CodingKey {
            case fullName = "full_name"
            case userImage = "img_profile"
            case pk
            case userName = "username"
            case wannaGo = "wannago_set"
            case checkIn = "checkin_set"
        }
    }
}

final class UserData {
    static let shared = UserData()
    var userCellData: LoginData?
    
    
    
}

