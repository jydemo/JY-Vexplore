//
//  User.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class User {
    static let shared = User()
    var isLogin: Bool {
        return username != nil
    }
    var username: String?
    private init() {
       // username = UserDefaults.standard
    }
}
