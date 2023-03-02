//
//  appVersionModel.swift
//  telehealth
//
//  Created by iroid on 27/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class AppVersionModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        
    }
    public var success: Bool?
    public var message: String?
    public var data:FlagModel?
}

class FlagModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        flag <- map["flag"]
        
    }
    public var flag: Int?
}
