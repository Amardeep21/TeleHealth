//
//  PsychologistsSignUpModel.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import ObjectMapper

class CityModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data:CountryDataInformation?

}


class CountryDataInformation: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        data <- map["data"]
        
    }
    public var data:[CountryInformation]?
}

class CountryInformation: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        sortName <- map["sortname"]
        phoneCode <- map["phonecode"]
        flag <- map["flag"]
    }
    public var id: Int?
    public var name: String?
    public var sortName: String?
    public var phoneCode: String?
    public var flag: String?
}
