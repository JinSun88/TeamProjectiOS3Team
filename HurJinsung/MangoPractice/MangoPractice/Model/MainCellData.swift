//
//  mainCellData.swift
//  MangoPractice
//
//  Created by Bernard Hur on 21/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation
import UIKit

struct cellData {
    let pk: Int
    let ranking: Int
    let name: String
    let image: UIImage
    let location: String
    let viewFeedCount: String
    let gradePoint: Double
}

final class CellData {
    var arrayOfCellData: [cellData] = [
        cellData(pk:1, ranking: 1, name: "야스노야지로", image: #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.6),
        cellData(pk:2, ranking: 2, name: "우스블랑(1호점)", image: #imageLiteral(resourceName: "cooking-dinner-food-76093"), location: "용산/숙대", viewFeedCount: "👁‍🗨102531 🖋119 ", gradePoint: 4.3),
        cellData(pk:3, ranking: 3, name: "한입소반", image: #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), location: "용산/숙대", viewFeedCount: "👁‍🗨25478 🖋35 ", gradePoint: 4.3),
        cellData(pk:4, ranking: 4, name: "슬라이더버거", image: #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), location: "용산/숙대", viewFeedCount: "👁‍🗨31464 🖋12 ", gradePoint: 4.3),
        cellData(pk:5, ranking: 5, name: "화양연가", image: #imageLiteral(resourceName: "cooking-dinner-food-76093"), location: "용산/숙대", viewFeedCount: "👁‍🗨8421 🖋8 ", gradePoint: 4.3),
        cellData(pk:6, ranking: 6, name: "구복만두", image: #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2),
        cellData(pk:7, ranking: 7, name: "스티키리키", image: #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.2),
        cellData(pk:8, ranking: 8, name: "신내떡", image: #imageLiteral(resourceName: "cooking-dinner-food-76093"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1),
        cellData(pk:9, ranking: 9, name: "두화당", image: #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.1),
        cellData(pk:10, ranking: 10, name: "조대포", image: #imageLiteral(resourceName: "burrito-chicken-close-up-461198"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0),
        cellData(pk:11, ranking: 11, name: "사이공마켓(숙대점)", image: #imageLiteral(resourceName: "cooking-dinner-food-76093"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 4.0),
        cellData(pk:12, ranking: 12, name: "마시&바시", image: #imageLiteral(resourceName: "blur-breakfast-close-up-376464"), location: "용산/숙대", viewFeedCount: "👁‍🗨3747 🖋7 ", gradePoint: 3.9)]
}
