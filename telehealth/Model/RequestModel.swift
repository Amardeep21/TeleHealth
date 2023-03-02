//
//  NotificationModel.swift
//  telehealth
//
//  Created by Apple on 25/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestMainModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        meta <- map["meta"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[RequestModel]?
    public var meta:MetaDataModel?
}

class RequestModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        requestId <- map["requestId"]
        userId <- map["userId"]
        username <- map["username"]
        profile <- map["profile"]
    }
    public var requestId: Int?
    public var userId: Int?
    public var username: String?
    public var profile: String?
}
