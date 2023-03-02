//
//  SpecialityModel.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:HomeAllDetailsModel?
}

class HomeAllDetailsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        speciality <- map["speciality"]
        psychologists <- map["psychologists"]
        blogs <- map["blogs"]
        upcomingSession <- map["upcomingSessions"]
        unreadNotification <- map["unreadNotification"]
    }
    public var speciality: [SpecialityInformationModel]?
    public var psychologists: [PsychologistsInformationModel]?
    public var blogs:BlogsModel?
    public var upcomingSession:UpcomingSessionModel?
    public var unreadNotification:Int?
}

class SpecialityInformationModel: Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        speciality <- map["speciality"]
        icon <- map["icon"]
        isSelected <- map["isSelected"]
    }
    public var id: Int?
    public var speciality: String?
    public var icon:String?
    public var isSelected: Bool? = false
}

class PsychologistsInformationModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        map.shouldIncludeNilValues = true
        id <- map["id"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profile <- map["profile"]
        speciality <- map["speciality"]
        education <- map["education"]
        yearOfExperience <- map["yearOfExperience"]
         languages <- map["languages"]
        chatConsultationPrice <- map["chatConsultationPrice"]
        AudioVideoMinConsultationPrice <- map["AudioVideoMinConsultationPrice"]
    }
    public var id: Int?
    public var firstname: String?
    public var lastname:String?
    public var profile:String?
    public var speciality:NSArray?
    public var education:String?
     public var yearOfExperience:String?
      public var languages:String?
    public var chatConsultationPrice:String?
    public var AudioVideoMinConsultationPrice:String?
}

class BlogsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        media <- map["media"]
        image_large <- map["image_large"]
        mediaType <- map["mediaType"]
        duration <- map["duration"]
        description <- map["description"]
        publishAt <- map["publishAt"]
        video <- map["video"]
        authorname <- map["authorname"]
        
    }
    public var id: Int?
    public var title: String?
    public var media:String?
    public var image_large:String?
    public var mediaType: Int?
    public var duration:String?
    public var description:String?
    public var publishAt:String?
    public var video:String?
    public var authorname:String?
 
}

class UpcomingSessionModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        map.shouldIncludeNilValues = true
        psychologistId <- map["psychologistId"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profile <- map["profile"]
        session <- map["session"]
        services <- map["services"]
        appointmentDate <- map["appointmentDate"]
        sessionId <- map["sessionId"]
    }
    public var psychologistId: Int?
    public var firstname: String?
    public var lastname:String?
    public var profile:String?
    public var session:String?
    public var appointmentDate:String?
    public var services:Int?
    public var sessionId:Int?
}
class BlogListModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        meta <- map["meta"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[BlogsModel]?
    public var meta:MetaDataModel?
}

class BlogDetailModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        
    }
    public var success: Bool?
    public var message: String?
    public var data:BlogsModel?
}
