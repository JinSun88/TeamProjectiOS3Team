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
        case restaurantCreate(name: String, address: String, phone: String)
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
            case .restaurantList:
                return "/restaurants/list/"
            case .restaurantRetrive,
                 .restaurantUpdate,
                 .restaurantDelete:
                return "/restaurant/<pk>"
            case .restaurantCreate:
                return "/restaurant/list"
            }
        }
        
        var parameter: Parameters? {
            switch self {
            case let .restaurantCreate(name, address, phone):
                return [
                    "name": name,
                    "address": address,
                    "phone": phone
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
    
    func restaurantList(type: restaurantApi, completionHandler: @escaping (_ response: Any) -> Void) {
        Alamofire
            .request(baseUrl + type.path,
                     method: type.method
            )
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
