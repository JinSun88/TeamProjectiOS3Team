//
//  ReviewData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 07/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit

struct ServerRestaurantStruct: Decodable {
    let restaurantPk: Int  // 맛집 고유 번호
    let name: String  // 맛집 이름
    let rateGood: Int?  // 맛있다 갯수
    let rateNormal: Int? // 괜찮다 갯수
    let rateBad: Int? // 별로 갯수
    let postArray: [PostStruct]  // 실제 리뷰 데이터 구역
    
    struct PostStruct: Decodable {
        let reviewPk: Int // 리뷰 고유 번호
        let reviewContent: String // 리뷰 내용
        let reviewRate: Int // 맛있다 5, 괜찮다 3, 별도다 1
        let author: AuthorStruct // 리뷰어 정보
        
        struct AuthorStruct: Decodable {
            let authorPk: Int // 리뷰어 고유 번호
            let authorName: String?
            let authorImage: String? // 리뷰어 프로필 이미지
            
            enum CodingKeys: String, CodingKey {
                case authorPk = "pk"
                case authorName = "username"
                case authorImage = "img_profile"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case reviewPk = "pk"
            case reviewContent = "content"
            case reviewRate = "rate"
            case author
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case restaurantPk = "pk"
        case name
        case rateGood = "rate_good"
        case rateNormal = "rate_normal"
        case rateBad = "rate_bad"
        case postArray = "post_set"
    }
}

final class RestaurantData {
    static let shared = RestaurantData()
    var arrayOfRestaurantData: [ServerRestaurantStruct] = []

    func getDataFromServer(restaurantPk: Int) {
        let url = URL(string: "https://api.fastplate.xyz/api/posts/list/\(restaurantPk)")!
        guard let data = try? Data(contentsOf: url) else { print("서버 에러"); return }
        let jsonDecoder = JSONDecoder()

        do {
            let arrayData = try jsonDecoder.decode(ServerRestaurantStruct.self, from: data)
            arrayOfRestaurantData = [arrayData]
        } catch {
            print("에러내용: \(error)")
        }
    }
}
