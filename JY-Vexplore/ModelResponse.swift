//
//  ModelResponse.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/25.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

class CommonResponse {
    var success = false
    var message = [String]()
    init(success: Bool, message: [String] = [String]()) {
        self.success = success
        self.message = message
    }
    
    
    
    
    
}

class ValueResponse<T>: CommonResponse {

    var value: T?
    init(value: T? = nil, success: Bool, message: [String] = [String]()) {
        super.init(success: success, message: message)
        self.value = value
    }
    
    
    
    
    
    
    
}
