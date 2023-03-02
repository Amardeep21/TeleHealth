//
//  LogoutModel.swift
//  telehealth
//
//  Created by Apple on 07/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class CommanModel: Mappable {
    required init?(map: Map) {}
        func mapping(map: Map) {
               success <- map["success"]
                message <- map["message"]
                data <- map["data"]
           }
         public var success: Bool?
         public var message: String?
         public var data: DataInformation?
}

class StatusRootModel: Mappable {
    required init?(map: Map) {}
        func mapping(map: Map) {
               success <- map["success"]
                message <- map["message"]
                data <- map["data"]
           }
         public var success: Bool?
         public var message: String?
         public var data: StatusModel?
}
class StatusModel: Mappable {
    required init?(map: Map) {}
        func mapping(map: Map) {
            isArabicProfileCompleted <- map["isArabicProfileCompleted"]
            isEnglishProfileCompleted <- map["isEnglishProfileCompleted"]
           }
         public var isArabicProfileCompleted: Bool?
         public var isEnglishProfileCompleted: Bool?
}

class DataInformation: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
           flag <- map["flag"]
       }
     public var flag: Int?
}

class CountRootModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data: CountModel?
}

class CountModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        chat_count <- map["chat_count"]
        unreadNotification <- map["unreadNotification"]
         sessionReminder <- map["sessionReminder"]
        blogReminder <- map["blogReminder"]
        chatReminder <- map["chatReminder"]
        requestCount <- map["requestCount"]
        user  <- map["user"]
    }
    public var chat_count: Int?
    public var unreadNotification: Int?
    public var sessionReminder: Int?
     public var blogReminder: Int?
    public var  chatReminder: Int?
    public var requestCount: Int?
    public var user: UserInformation?
}
