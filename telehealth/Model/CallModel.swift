//
//  CallModel.swift
//  telehealth
//
//  Created by Apple on 29/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class CallModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        
    }
    public var success: Bool?
    public var message: String?
    public var data:CallAuthModel?
}

class CallAuthModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        roomName <- map["roomName"]
        accessToken <- map["accessToken"]
    }
    public var roomName: String?
    public var accessToken: String?
}
