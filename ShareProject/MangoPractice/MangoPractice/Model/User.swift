//
//  User.swift
//  MangoPractice
//
//  Created by jinsunkim on 19/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import Foundation

final class User {
    static var shared = User()
    
    var token: String?
    var userName: String?
}

