//
//  mainCellData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit

struct CellDataStruct {
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
    // 위치값 (네이버 or Apple)
    // 내가 즐겨찾기한 데이터(가고싶다) 인지 아닌지 (Bool값)
    // 내가 등록한 데이터인지 아닌지
}

final class CellData {
    var arrayOfCellData: [CellDataStruct] = [
        CellDataStruct(pk:111, ranking: 1, name: "야스노야지로", image: [ #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "banner-1686943_1280"), #imageLiteral(resourceName: "DropDownArrow"), #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "sunset-1645103_1280"), #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.6, youTubeUrl: "https://www.youtube.com/watch?v=jJt2Wunh5d4", address: "서울시 용산구 원효로1가 57-9", latitude: 37.531299, longitude: 126.971395, telNumber: "01029277728"),
        CellDataStruct(pk:222, ranking: 2, name: "우스블랑(1호점)", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093"), #imageLiteral(resourceName: "sunset-1645103_1280"), #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨102531 🖋119 ", gradePoint: 4.3, youTubeUrl: "https://www.youtube.com/watch?v=ddn-18UBScQ", address: "서울시 용산구 효창동 5-51", latitude: 37.541632, longitude: 126.962401, telNumber: "01029277728"),
        CellDataStruct(pk:333, ranking: 3, name: "한입소반", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), #imageLiteral(resourceName: "banner-1686943_1280"), #imageLiteral(resourceName: "DropDownArrow")], location: "용산/숙대", viewFeedCount: "👁‍🗨25478 🖋35 ", gradePoint: 4.3, address: "서울특별시 용산구 청파동3가 15-5번지", latitude: 37.544989, longitude: 126.970328, telNumber: "01029277728"),
        CellDataStruct(pk:444, ranking: 4, name: "슬라이더버거", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨31464 🖋12 ", gradePoint: 4.3, address: "서울시 용산구 후암동 139-5", latitude: 37.548726, longitude: 126.975898, telNumber: "01029277728"),
        CellDataStruct(pk:555, ranking: 5, name: "화양연가", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨8421 🖋8 ", gradePoint: 4.3, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStruct(pk:666, ranking: 6, name: "구복만두", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2, address: "서울특별시 용산구 남영동 3-4", latitude: 37.545355, longitude: 126.973181, telNumber: "01029277728"),
        CellDataStruct(pk:777, ranking: 7, name: "스티키리키", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2, address: "서울특별시 용산구 남영동 두텁바위로1길 28", latitude: 37.545860, longitude: 126.973912, telNumber: "01029277728"),
        CellDataStruct(pk:888, ranking: 8, name: "신내떡", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1, address: "서울특별시 청파동3가 청파동3가 24-73번지", latitude: 37.544667, longitude: 126.969960, telNumber: "01029277728"),
        CellDataStruct(pk:999, ranking: 9, name: "두화당", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStruct(pk:101010, ranking: 10, name: "조대포", image:[ #imageLiteral(resourceName: "burrito-chicken-close-up-461198")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStruct(pk:111111, ranking: 11, name: "사이공마켓(숙대점)", image:[ #imageLiteral(resourceName: "cooking-dinner-food-76093")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728"),
        CellDataStruct(pk:121212, ranking: 12, name: "마시&바시", image:[ #imageLiteral(resourceName: "blur-breakfast-close-up-376464")], location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 3.9, address: "서울특별시 용산구 남영동 89-5", latitude: 37.541800, longitude: 126.973332, telNumber: "01029277728")]
}
