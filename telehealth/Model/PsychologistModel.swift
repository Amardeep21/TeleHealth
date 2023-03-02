//
//  PsychologistModel.swift
//  telehealth
//
//  Created by Apple on 18/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class PsychologistModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        meta <- map["meta"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[PsychologistsInformationModel]?
    public var meta:MetaDataModel?
}

class MetaDataModel : Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        current_page <- map["current_page"]
        count <- map["count"]
        prev_page_url <- map["prev_page_url"]
        next_page_url <- map["next_page_url"]
        has_more_pages <- map["has_more_pages"]
        isChatDeactivated <- map["isChatDeactivated"]
    }
    public var current_page: Int?
    public var count: Int?
    public var prev_page_url:String?
    public var next_page_url:String?
    public var has_more_pages: Bool?
      public var isChatDeactivated: Int?
}
class PsychologistDetailModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:PsychologistsDataModel?
}

class PsychologistsDataModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        consultationPrice <- map["consultationPrice"]
        education <- map["education"]
        coupleConsultationPrice <- map["coupleConsultationPrice"]
        familyConsultationPrice <- map["familyConsultationPrice"]
        experience <- map["experience"]
        languages <- map["languages"]
        yearOfExperience <- map["yearOfExperience"]
        speciality <- map["speciality"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profile <- map["profile"]
        id <- map["id"]
        aboutme <- map["aboutme"]
        services <- map["services"]
        gender <- map["gender"]
        specialityId <- map["specialityId"]
        chatConsultationPrice <- map["chatConsultationPrice"]
        funFact <- map["funFact"]
    }
    public var aboutme: String?
    public var consultationPrice: String?
    public var coupleConsultationPrice: String?
    public var familyConsultationPrice: String?
    public var education: String?
    public var experience: String?
    public var languages: String?
    public var yearOfExperience:String?
    public var speciality:[String]?
    public var firstname: String?
    public var  lastname: String?
    public var  profile: String?
    public var  services:[Int]?
    public var  funFact: String?
    public var  chatConsultationPrice: String?
    public var  id: Int?
    public var  gender: Int?
    public var  specialityId:[Int]?
}


