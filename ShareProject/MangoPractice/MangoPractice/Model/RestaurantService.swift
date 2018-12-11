//
//  RestaurantService.swift
//  MangoPractice
//
//  Created by jinsunkim on 30/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Alamofire

struct RestaurantService {
    let baseUrl: String = "https://api.fastplate.xyz/api"
    
    enum restaurantApi {
        case restaurantList
        case restaurantRetrive
        case restaurantCreate(name: String, address: String, phone: String, latitude: String, longitude: String)
        case restaurantUpdate
        case restaurantDelete
        
        var method: HTTPMethod {
            switch self {
            case .restaurantList,
                 .restaurantRetrive:
                return .get
            case .restaurantCreate:
                return .post
            case .restaurantUpdate:
                return .patch
            case .restaurantDelete:
                return .delete
            }
        }
        
        var path: String {
            switch self {
            case .restaurantList,
                 .restaurantCreate:
                return "/restaurants/list/"
            case .restaurantRetrive,
                 .restaurantUpdate,
                 .restaurantDelete:
                return "/restaurant/<pk>"
            }
        }
        
        var parameter: Parameters? {
            switch self {
            case let .restaurantCreate(name, address, phone, latitude, longitude):
                return [
                    "name": name,
                    "address": address,
                    "phone_num": phone,
                    "latitude": latitude,
                    "longitude": longitude
                ]
            case .restaurantList:
                return nil
            case .restaurantRetrive:
                return nil
            case .restaurantUpdate:
                return nil
            case .restaurantDelete:
                return nil
                
            }
            
        }
        
        
        
    }
    
    func restaurantCreate(type: restaurantApi, completionHandler: @escaping (_ response: Any) -> Void) {
        Alamofire
            .request(
                baseUrl + type.path,
                method: type.method,
                parameters: type.parameter)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    return completionHandler(data)
                case let .failure(error):
                    return completionHandler(error.localizedDescription)
                }
        }
    }
}
