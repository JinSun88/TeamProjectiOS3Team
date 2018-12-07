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
        let author: [AuthorStruct]
        
        struct AuthorStruct: Decodable {
            let authorPk: Int
            let authorName: String
            
            enum CodingKeys: String, CodingKey {
                case authorPk = "pk"
                case authorName = "username"
            }
        }
        let rate: Int
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case reviewPk = "pk"
            case author
            case rate
            case content
        }
    }
}

//final class CellData {
//    static let shared = CellData()
//    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
//
//    // 서버에서 데이터 가져오는 펑션
//    func getDataFromServer() {
//        let url = URL(string: "https://api.fastplate.xyz/api/restaurants/list/")!
//        guard let data = try? Data(contentsOf: url) else { print("서버 에러"); return }  // 서버통신 안될시 리턴됨(초기화면 깡통됨)
//        let jsonDecoder = JSONDecoder()
//
//        // 서버에서 들어오는 형식이 다르면 catch로 빠집니다(앱다운 회피)
//        do {
//            let arrayData = try jsonDecoder.decode(ServerStruct.self, from: data)
//            arrayOfCellData = arrayData.results
//        } catch {
//            print("에러내용: \(error)")
//        }
//    }
//}
