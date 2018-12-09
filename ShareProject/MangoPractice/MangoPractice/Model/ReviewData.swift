//
//  ReviewData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 07/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit

struct ServerReviewStruct: Decodable {
    let count: Int  // 전체 리뷰 데이터수
    let next: String?  // 다음페이지가 있을 경우의 서버 url
    let previous: String?  // 전페이지가 있을 경우의 서버 url
    let results: [ReviewStruct]  // 실제 리뷰 데이터 구역
    
    struct ReviewStruct: Decodable {
        let reviewPk: Int
        let rate: Int?
        let author: AuthorStruct
        let content: String?
        
        struct AuthorStruct: Decodable {
            let authorPk: Int
            let authorName: String?
            
            enum CodingKeys: String, CodingKey {
                case authorPk = "pk"
                case authorName = "username"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case reviewPk = "pk"
            case author
            case rate
            case content
        }
    }
}

final class ReviewData {
    static let shared = ReviewData()
    var arrayOfReviewData: [ServerReviewStruct.ReviewStruct] = []
    
    func getDataFromServer() {
        let url = URL(string: "https://api.fastplate.xyz/api/posts/list/")!
        guard let data = try? Data(contentsOf: url) else { print("서버 에러"); return }
        let jsonDecoder = JSONDecoder()
        
        do {
            let arrayData = try jsonDecoder.decode(ServerReviewStruct.self, from: data)
            arrayOfReviewData = arrayData.results
        } catch {
            print("에러내용: \(error)")
        }
    }
}
