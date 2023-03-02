//
//  SettingOptionModel.swift
//  telehealth
//
//  Created by Apple on 11/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper
struct SettingOptionModel {
    var imageName : String?
    var title :  String?
    var isShowMessageCount: Bool?
    var isShowLaguage: Bool?
    var isFirstLineShow: Bool?
    var index: Int?
    var isBottomLine:Bool?
    
}
class SwitchMainModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        
        data <- map["data"]
        message <- map["message"]
       
    }
  
    public var data: SwitchModel?
    public var message: String?
}

class SwitchModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        blogReminder <- map["blogReminder"]
        chatReminder <- map["chatReminder"]
        pinSecurity <- map["pinSecurity"]
        sessionReminder <- map["sessionReminder"]
    }
   
     public var blogReminder: Int?
     public var chatReminder: Int?
     public var pinSecurity: Int?
     public var sessionReminder: Int?
    
}
