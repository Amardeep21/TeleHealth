//
//  NotificationModel.swift
//  telehealth
//
//  Created by Apple on 25/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationRootModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        meta <- map["meta"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[NotificationModel]?
    public var meta:MetaDataModel?
}

class NotificationModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        body <- map["body"]
        image <- map["image"]
        type <- map["type"]
        createdAt <- map["createdAt"]
        initialSession <- map["initialSession"]
    }
    public var id: Int?
    public var body: String?
    public var image: String?
    public var type: Int?
    public var createdAt: String?
    public var initialSession: InitialSession?
}

class InitialSession:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        consultantType <- map["consultantType"]
        consultationPrice <- map["consultationPrice"]
        name <- map["name"]
        profile <- map["profile"]
        psychologistId <- map["psychologistId"]
        requestId <- map["requestId"]
        services <- map["services"]
        session <- map["session"]
        status <- map["status"]
        userId <- map["userId"]
    }
    
    public var consultantType: Int?
    public var psychologistId: Int?
    public var consultationPrice: String?
    public var name: String?
    public var profile: String?
    public var type: Int?
    public var requestId: Int?
    public var services: String?
    public var session: String?
    public var userId :Int?
    public var status: String?
}
