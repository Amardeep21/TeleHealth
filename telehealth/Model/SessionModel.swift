//
//  SessionModel.swift
//  telehealth
//
//  Created by iroid on 20/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper
class PsychologistSessionAvailabilityModel: Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        isNextSessionAvailable <- map["isNextSessionAvailable"]
        isPreviousSessionAvailable  <- map["isPreviousSessionAvailable"]
        services <- map["services"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[AvailableSessionsData]?
    public var isNextSessionAvailable:Bool?
    public var isPreviousSessionAvailable:Bool?
    public var services:[Int]?
}
class AvailableSessionsData:Mappable{
    
    required init?(map: Map) {}
    
    init(session:String,isAvailable:Bool,isBooked:Bool,isFree:Bool = false,type:Int = 0) {
        self.session = session
        self.isAvailable = isAvailable
        self.isBooked = isBooked
        self.isFree = isFree
        self.type = type
    }
    
    func setSession(session:String){
        self.session = session
    }
    
    func mapping(map: Map) {
        session <- map["session"]
        isAvailable <- map["isAvailable"]
        isBooked <- map["isBooked"]
        isFree <- map["isFree"]
        type <- map["type"]
      
    }
    public var session: String?
    public var isAvailable: Bool?
    public var isBooked: Bool?
    public var isFree:Bool?
    public var type:Int?
    public var rearrangedSelected: Bool = false
    
}

class WeeklySessionsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
       
        
    }
    
    public var success: Bool?
    public var message: String?
    public var data:WeekSessions?
  
}

class WeekSessions:Mappable{
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        Mon <- map["Mon"]
        Sat <- map["Sat"]
        Sun <- map["Sun"]
        Thu <- map["Thu"]
        Tue <- map["Tue"]
        Fri <- map["Fri"]
        Wed <- map["Wed"]
    }
    
    public var Fri:[AvailableSessionsData]?
    public var Mon:[AvailableSessionsData]?
    public var Sat:[AvailableSessionsData]?
    public var Sun:[AvailableSessionsData]?
    public var Thu:[AvailableSessionsData]?
    public var Tue:[AvailableSessionsData]?
    public var Wed:[AvailableSessionsData]?
}

class MonthlySlotsRootModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[MonthlySlotsModel]?
}

class MonthlySlotsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        date <- map["date"]
        isSlotAdded <- map["isSlotAdded"]
    }
    public var date: String?
    public var isSlotAdded: Bool?
}



