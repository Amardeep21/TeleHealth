//
//  PsychologistsHomeModel.swift
//  telehealth
//
//  Created by iroid on 20/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class PsychologistsHomeModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:PsychologistsHomeDetailsModel?
}

class PsychologistsHomeDetailsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        bookedSessions <- map["bookedSessions"]
        blogs <- map["blogs"]
        remainingSessions <- map["remainingSessions"]
        totalSessions <- map["totalSessions"]
        unreadNotification <- map["unreadNotification"]
    }
    public var bookedSessions: [BookedSessionsModel]?
    public var blogs:BlogsModel?
     public var remainingSessions:Int?
    public var totalSessions:Int?
    public var unreadNotification:Int?
    
}

class BookedSessionsModel: Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        userId <- map["userId"]
        username <- map["username"]
        profile <- map["profile"]
        services <- map["services"]
        appointmentDate <- map["appointmentDate"]
        session <- map["session"]
        sessionId <- map["sessionId"]
    }
    public var userId: Int?
    public var username: String?
    public var profile:String?
    public var services:Int?
    public var appointmentDate:String?
    public var session:String?
    public var sessionId:Int?
    
}
