//
//  mainCellData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct ServerStruct: Decodable {
    let count: Int  // 전체 맛집 데이터수
    let next: String?  // 다음페이지가 있을 경우의 서버 url
    let previous: String?  // 전페이지가 있을 경우의 서버 url
    let results: [CellDataStruct]  // 실제 맛집 데이터 구역
    
    struct CellDataStruct: Decodable {
        let pk: Int // 1
        let name: String // "와하카"
        let address: String? // "성수동2가 299-225"
        let phoneNum: String? // "02-462-7292"
        let foodType: String? // "남미 음식"
        let priceLevel: String? // "만원 미만"
        let parking: String? // "주차공간없음"
        let businessHour: String? // "화-토: 11:30 - 23:00\r\n일: 12:00 - 22:00",
        let breakTime: String? // "15:00 - 17:00",
        let lastOrder: String? // "화-토: 22:00, 일: 21:00",
        let holiday: String? // "월"
        let website: String? // ""
        let viewNum: Int? // 0
        let reviewNum: Int? // 0
        let wantNum: Int? // 0
        let createdAt: String? // "2018-11-29T12:12:37.792797+09:00"
        let modifiedAt: String? // "2018-11-29T12:12:37.792819+09:00"
        let latitude: Double? // 127.05436622
        let longitude: Double? // 37.54785459
        let gradePoint: String? // -> 현재없음
        let youTubeUrl: String? // -> 현재없음
        let rateGood: Int?  // 맛있다 갯수
        let rateNormal: Int? // 괜찮다 갯수
        let rateBad: Int? // 별로 갯수
        let menuText: String? // 메뉴
        let postArray: [PostStruct]
        
        struct PostStruct: Decodable {
            let reviewPk: Int // 리뷰 고유 번호
            let reviewContent: String // 리뷰 내용
            let reviewRate: Int // 맛있다 5, 괜찮다 3, 별도다 1
            let author: AuthorStruct // 리뷰어 정보
            let reviewImage: [ReviewImageStruct]?
            
            struct AuthorStruct: Decodable {
                let authorPk: Int // 리뷰어 고유 번호
                let authorName: String?
                let authorImage: String? // 리뷰어 프로필 이미지
                
                enum CodingKeys: String, CodingKey {
                    case authorPk = "pk"
                    case authorName = "full_name"
                    case authorImage = "img_profile"
                }
            }
            
            struct ReviewImageStruct: Decodable {
                let reviewImagePk: Int // 리뷰이미지 고유번호
                let reviewImageUrl: String // 리뷰 이미지 url
                
                enum CodingKeys: String, CodingKey {
                    case reviewImagePk = "pk"
                    case reviewImageUrl = "image"
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case reviewPk = "pk"
                case reviewContent = "content"
                case reviewRate = "rate"
                case author
                case reviewImage = "postimage_posts"
            }
        }
        
        
        enum CodingKeys: String, CodingKey {
            case pk
            case name
            case address
            case phoneNum = "phone_num"
            case foodType = "food_type"
            case priceLevel = "price_level"
            case parking
            case businessHour = "Business_hour"
            case breakTime = "break_time"
            case lastOrder = "last_order"
            case holiday
            case website
            case viewNum = "view_num"
            case reviewNum = "review_num"
            case wantNum = "want_num"
            case createdAt = "created_at"
            case modifiedAt = "modified_at"
            case latitude
            case longitude
            case gradePoint = "rate_average"
            case youTubeUrl = "youtube"
            case rateGood = "rate_good"
            case rateNormal = "rate_normal"
            case rateBad = "rate_bad"
            case postArray = "post_set"
            case menuText = "menu_text"
        }
    }
}

final class CellData {
    static let shared = CellData()
    var arrayOfCellData: [ServerStruct.CellDataStruct] = []
    var nextPageUrl: String? = ""
    
    // 서버에서 데이터 가져오는 펑션
    func getDataFromServer() {
        let url = URL(string: "https://api.fastplate.xyz/api/restaurants/list/")!
        guard let data = try? Data(contentsOf: url) else { print("서버 에러"); return }  // 서버통신 안될시 리턴됨(초기화면 깡통됨)
        let jsonDecoder = JSONDecoder()
        do {
            let arrayData = try jsonDecoder.decode(ServerStruct.self, from: data)
            arrayOfCellData = arrayData.results
            nextPageUrl = arrayData.next
        } catch {
            print("에러내용: \(error)")
        }
    }
    
    func getNextPageDataFromServer(_ collectionView: UICollectionView) {
        // 데이터 페이지네이션 대응 펑션(스크롤 끝에서 데이터 추가받고 리로드 데이터)
        guard let url = URL(string: nextPageUrl ?? "") else
        {
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let arrayData = try jsonDecoder.decode(ServerStruct.self, from: data)
                
                for i in 0..<arrayData.results.count {
                    self.arrayOfCellData.append(arrayData.results[i])
                }
                self.nextPageUrl = arrayData.next
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            } catch {
                print("에러내용: \(error)")
            }}.resume()
    }
    
    func getUserDataFromServer() {
        
        let url = "https://api.fastplate.xyz/api/members/auth-token/facebook/"
        
        let params: Parameters = [
            "access_token": UserDefaults.standard.string(forKey: "authToken") ?? "" ,
            "facebook_user_id": UserDefaults.standard.string(forKey: "authFBid") ?? ""
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    let result = try! JSONDecoder().decode(LoginData.self, from: value)
                    
                    UserData.shared.userCellData = result
                    print("UserData.shared.userCellData", UserData.shared.userCellData ?? "no userData")
                    
                    // 위에 처리(result 가져오기)가 끝나면 노티피케이션을 띄우겠습니다.//
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserData"), object: nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
}

// 개발 초반 하드코딩 데이터 입니다
struct CellDataStructOrigin {
    let pk: Int
    let ranking: Int
    let name: String
    let image: [UIImage]
    let location: String
    let viewFeedCount: String
    let gradePoint: Double
    let youTubeUrl: String?
    let address: String
    let latitude: Double
    let longitude: Double
    let telNumber: String
    
    init(pk: Int, ranking: Int, name: String, image: [UIImage], location: String, viewFeedCount: String, gradePoint: Double, youTubeUrl: String? = nil, address: String, latitude: Double, longitude: Double, telNumber: String) {
        self.pk = pk
        self.ranking = ranking
        self.name = name
        self.image = image
        self.location = location
        self.viewFeedCount = viewFeedCount
        self.gradePoint = gradePoint
        self.youTubeUrl = youTubeUrl
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.telNumber = telNumber
    }
}
final class CellDataOrigin {
    var arrayOfCellData: [CellDataStructOrigin] = [
        CellDataStructOrigin(pk:111, ranking: 1, name: "야스노야지로", image: [ #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "banner-1686943_1280"), #imageLiteral(resourceName: "DropDownArrow"), #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "sunset-1645103_1280"), #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.6, youTubeUrl: "https://www.youtube.com/watch?v=jJt2Wunh5d4", address: "서울시 용산구 원효로1가 57-9", latitude: 37.531299, longitude: 126.971395, telNumber: "01029277728"),
        CellDataStructOrigin(pk:222, ranking: 2, name: "우스블랑(1호점)", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093"), #imageLiteral(resourceName: "sunset-1645103_1280"), #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨102531 🖋119 ", gradePoint: 4.3, youTubeUrl: "https://www.youtube.com/watch?v=ddn-18UBScQ", address: "서울시 용산구 효창동 5-51", latitude: 37.541632, longitude: 126.962401, telNumber: "01029277728"),
        CellDataStructOrigin(pk:333, ranking: 3, name: "한입소반", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "banner-1686943_1280"), #imageLiteral(resourceName: "DropDownArrow")], location: "용산/숙대", viewFeedCount: "👁‍🗨25478 🖋35 ", gradePoint: 4.3, address: "서울특별시 용산구 청파동3가 15-5번지", latitude: 37.544989, longitude: 126.970328, telNumber: "01029277728"),
        CellDataStructOrigin(pk:444, ranking: 4, name: "슬라이더버거", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨31464 🖋12 ", gradePoint: 4.3, address: "서울시 용산구 후암동 139-5", latitude: 37.548726, longitude: 126.975898, telNumber: "01029277728"),
        CellDataStructOrigin(pk:555, ranking: 5, name: "화양연가", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨8421 🖋8 ", gradePoint: 4.3, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStructOrigin(pk:666, ranking: 6, name: "구복만두", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2, address: "서울특별시 용산구 남영동 3-4", latitude: 37.545355, longitude: 126.973181, telNumber: "01029277728"),
        CellDataStructOrigin(pk:777, ranking: 7, name: "스티키리키", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2, address: "서울특별시 용산구 남영동 두텁바위로1길 28", latitude: 37.545860, longitude: 126.973912, telNumber: "01029277728"),
        CellDataStructOrigin(pk:888, ranking: 8, name: "신내떡", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1, address: "서울특별시 청파동3가 청파동3가 24-73번지", latitude: 37.544667, longitude: 126.969960, telNumber: "01029277728"),
        CellDataStructOrigin(pk:999, ranking: 9, name: "두화당", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStructOrigin(pk:101010, ranking: 10, name: "조대포", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStructOrigin(pk:111111, ranking: 11, name: "사이공마켓(숙대점)", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStructOrigin(pk:121212, ranking: 12, name: "마시&바시", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 3.9, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728")]
}

//    func fetchData(completionHander: @escaping ([CellDataStruct]) -> Void) {  // 알라모 사용한 데이터 비동기식 처리(feat.조교님)
//
//        let url = URL(string: "https://api.fastplate.xyz/api/restaurants/list/")!
//        Alamofire
//            .request(url)
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    let jsonDecoder = JSONDecoder()
//                    let dateFomatter = DateFormatter()
//                    dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
//                    jsonDecoder.dateDecodingStrategy = .formatted(dateFomatter)
//                    let arrayData = try! jsonDecoder.decode([CellDataStruct].self, from: data)
//                    //
//                    completionHander(arrayData)
//                case .failure(let error):
//                    print(error)
//                }
//        }
//    }
