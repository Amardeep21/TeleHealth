//
//  AppointmentModel.swift
//  telehealth
//
//  Created by iroid on 22/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper
class AppointmentModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        detailData <- map["data"]
        meta <- map["meta"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[AppointmentDataModel]?
    public var detailData:AppointmentDataModel?
    public var meta:MetaDataModel?
}

class AppointmentDataModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        appointmentDate <- map["appointmentDate"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profile <- map["profile"]
        psychologistId <- map["psychologistId"]
        services <- map["services"]
        session <- map["session"]
        username <- map["username"]
        sessionId <- map["sessionId"]
        psychologistId <- map["psychologistId"]
        role <- map["role"]
        consultationPrice <- map["consultationPrice"]
        gender <- map["gender"]
        isCounsellingBefore <- map["isCounsellingBefore"]
        counsellingType <- map["counsellingType"]
        relationship <- map["relationship"]
        isCanceled <- map["isCanceled"]
        reason <- map["reason"]
        userId <- map["userId"]
        consultantType <- map["consultantType"]
        questions <- map["questions"]
        type <- map["type"]
    }
    public var appointmentDate: String?
    public var firstname: String?
    public var lastname: String?
    public var profile: String?
    public var psychologistId:Int?
    public var type: Int?
    public var services:Int?
    public var session: String?
    public var username: String?
    public var sessionId:Int?
    public var role:Int?
    public var consultationPrice:String?
    public var gender:Int?
    public var isCounsellingBefore:Int?
    public var counsellingType:Int?
    public var relationship: Int?
    public var userId: Int?
    public var isCanceled: Bool?
    public var reason: String?
    public var consultantType: Int?
    public var questions: LanguagesModel?
}
