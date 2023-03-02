//
//  LanguageModel.swift
//  telehealth
//
//  Created by iroid on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper
class LanguageModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:[LanguageData]?
}

class LanguageData:Mappable{
    required init?(map: Map) {}
    
    init(name:String,isSelected:Bool = true) {
        self.name = name
        self.isSelected = isSelected
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        isSelected <- map["isSelected"]
        
    }
    public var name: String?
    public var isSelected: Bool? = false
}
