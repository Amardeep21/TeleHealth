//
//  QuestionModel.swift
//  telehealth
//
//  Created by Apple on 05/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper


class QuestionRootModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        
    }
    public var success: Bool?
    public var message: String?
    public var data:LanguagesModel?
}

class LanguagesModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        ar <- map["ar"]
        en <- map["en"]
    }
    public var ar: [ArabicQuestionModel]?
    public var en: [EnglishQuestionModel]?
}


class EnglishQuestionModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        options <- map["options"]
        question <- map["question"]
        type <- map["type"]
        value <- map["value"]
    }
    public var options: [OptionsModel]?
    public var question: String?
    public var type: Int?
    public var value: String?
    
}

class ArabicQuestionModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        options <- map["options"]
        question <- map["question"]
        type <- map["type"]
        value <- map["value"]
    }
    public var options: [OptionsModel]?
    public var question: String?
    public var type: Int?
    public var value: String?
}

class OptionsModel:Mappable{
    required init?(map: Map) {}
    func mapping(map: Map) {
        option <- map["option"]
        value <- map["value"]
    }
    public var option: String?
    public var value: Bool?
}
