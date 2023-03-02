//
//  LoginModel.swift
//  telehealth
//
//  Created by Apple on 05/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import ObjectMapper

class LoginModel: NSObject,NSCoding, Mappable{
    init(json: NSDictionary) { // Dictionary object
        self.success = json["success"] as? Bool
        self.message = json["message"] as? String
        self.data = json["data"] as? UserInformation // Location of the JSON file
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.success = aDecoder.decodeObject(forKey: "success") as? Bool;
        self.message = aDecoder.decodeObject(forKey: "success") as? String;
        self.data = aDecoder.decodeObject(forKey: "data") as? UserInformation;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.success, forKey: "success");
        aCoder.encode(self.message, forKey: "success");
        aCoder.encode(self.data, forKey: "data");
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
    public var success: Bool?
    public var message: String?
    public var data: UserInformation?
}
class UserInformation: NSObject,NSCoding,Mappable {
    init(json: NSDictionary) { // Dictionary object
        self.id = json["id"] as? Int
        self.username = json["username"] as? String
        self.firstname = json["firstname"] as? String // Location of the JSON file
        self.lastname = json["lastname"] as? String
        self.firstnameAr = json["firstnameAr"] as? String // Location of the JSON file
        self.lastnameAr = json["lastnameAr"] as? String
        self.email = json["email"] as? String
        self.role = json["role"] as? Int
        self.flag = json["flag"] as? Int
        self.language = json["language"] as? String
        self.socialProvider = json["socialProvider"] as? Int
        self.profile = json["profile"] as? String
        self.isEmailVerified = json["isEmailVerified"] as? Bool
        self.auth =   json["auth"] as? AuthanticationInformation
        self.userInfo =   json["userInfo"] as? PsychologistUserInfromation
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int;
        self.username = aDecoder.decodeObject(forKey: "username") as? String;
        self.firstname = aDecoder.decodeObject(forKey: "firstname") as? String;
        self.lastname = aDecoder.decodeObject(forKey: "lastname") as? String;
        self.firstnameAr = aDecoder.decodeObject(forKey: "firstnameAr") as? String;
        self.lastnameAr = aDecoder.decodeObject(forKey: "lastnameAr") as? String;
        self.email = aDecoder.decodeObject(forKey: "email") as? String;
        self.role = aDecoder.decodeObject(forKey: "role") as? Int;
        self.flag = aDecoder.decodeObject(forKey: "flag") as? Int;
        self.language = aDecoder.decodeObject(forKey: "language") as? String;
        self.socialProvider = aDecoder.decodeObject(forKey: "socialProvider") as? Int;
        self.profile = aDecoder.decodeObject(forKey: "profile") as? String;
        self.isEmailVerified = aDecoder.decodeObject(forKey: "isEmailVerified") as? Bool;
        self.auth = aDecoder.decodeObject(forKey: "auth") as? AuthanticationInformation;
        self.userInfo = aDecoder.decodeObject(forKey: "userInfo") as? PsychologistUserInfromation;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.username, forKey: "username");
        aCoder.encode(self.firstname, forKey: "firstname");
        aCoder.encode(self.lastname, forKey: "lastname");
        aCoder.encode(self.firstnameAr, forKey: "firstnameAr");
        aCoder.encode(self.lastnameAr, forKey: "lastnameAr");
        aCoder.encode(self.email, forKey: "email");
        aCoder.encode(self.role, forKey: "role");
        aCoder.encode(self.flag, forKey: "flag");
        aCoder.encode(self.language, forKey: "language");
        aCoder.encode(self.socialProvider, forKey: "socialProvider");
        aCoder.encode(self.profile, forKey: "profile");
        aCoder.encode(self.isEmailVerified, forKey: "isEmailVerified");
        aCoder.encode(self.auth, forKey: "auth");
        aCoder.encode(self.userInfo, forKey: "userInfo");
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        firstnameAr <- map["firstnameAr"]
        lastnameAr <- map["lastnameAr"]
        email <- map["email"]
        role <- map["role"]
        flag <- map["flag"]
        language <- map["language"]
        socialProvider <- map["socialProvider"]
        profile <- map["profile"]
        isEmailVerified <- map["isEmailVerified"]
        auth <- map["auth"]
        userInfo <- map["userInfo"]
    }
    public var id: Int?
    public var username: String?
    public var firstname: String?
    public var lastname: String?
    public var firstnameAr: String?
    public var lastnameAr: String?
    public var email: String?
    public var role: Int?
    public var flag: Int?
    public var language: String?
    public var socialProvider: Int?
    public var profile: String?
    public var isEmailVerified: Bool?
    public var auth: AuthanticationInformation?
    public var userInfo: PsychologistUserInfromation?
}
class AuthanticationInformation: NSObject,NSCoding,Mappable{
    
    init(json: NSDictionary) { // Dictionary object
        self.tokenType = json["tokenType"] as? String
        self.accessToken = json["accessToken"] as? String
        self.refreshToken = json["refreshToken"] as? String
        self.expiresIn = json["expiresIn"] as? Int
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tokenType = aDecoder.decodeObject(forKey: "tokenType") as? String;
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String;
        self.refreshToken = aDecoder.decodeObject(forKey: "refreshToken") as? String;
        self.expiresIn = aDecoder.decodeObject(forKey: "expiresIn") as? Int;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tokenType, forKey: "tokenType");
        aCoder.encode(self.accessToken, forKey: "accessToken");
        aCoder.encode(self.refreshToken, forKey: "refreshToken");
        aCoder.encode(self.expiresIn, forKey: "expiresIn");
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        tokenType <- map["tokenType"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
        expiresIn <- map["expiresIn"]
    }
    public var tokenType: String?
    public var accessToken: String?
    public var refreshToken: String?
    public var expiresIn: Int?
}

class PsychologistUserInfromation: NSObject,NSCoding,Mappable {
    init(json: NSDictionary) { // Dictionary object
        self.licenseNumber = json["licenseNumber"] as? String
        self.mobile = json["mobile"] as? String // Location of the JSON file
        self.phonecode = json["phonecode"] as? String
        self.country = json["country"] as? Country
        self.certificates = json["certificates"] as? [Certificate]
        self.isDetailsAdded = json["isDetailsAdded"] as? Int
        self.isSessionsAdded = json["isSessionsAdded"] as? Int
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.licenseNumber = aDecoder.decodeObject(forKey: "licenseNumber") as? String;
        self.mobile = aDecoder.decodeObject(forKey: "mobile") as? String;
        self.phonecode = aDecoder.decodeObject(forKey: "phonecode") as? String;
        self.country = aDecoder.decodeObject(forKey: "country") as? Country;
        self.certificates = aDecoder.decodeObject(forKey: "certificates") as? [Certificate];
        self.isDetailsAdded = aDecoder.decodeObject(forKey: "isDetailsAdded") as? Int;
        self.isSessionsAdded = aDecoder.decodeObject(forKey: "isSessionsAdded") as? Int;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.licenseNumber, forKey: "licenseNumber");
        aCoder.encode(self.mobile, forKey: "mobile");
        aCoder.encode(self.phonecode, forKey: "phonecode");
        aCoder.encode(self.country, forKey: "country");
        aCoder.encode(self.certificates, forKey: "certificates");
        aCoder.encode(self.isDetailsAdded, forKey: "isDetailsAdded");
        aCoder.encode(self.isSessionsAdded, forKey: "isSessionsAdded");
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        licenseNumber <- map["licenseNumber"]
        mobile <- map["mobile"]
        phonecode <- map["phonecode"]
        country <- map["country"]
        certificates <- map["certificates"]
        isDetailsAdded <- map["isDetailsAdded"]
        isSessionsAdded <- map["isSessionsAdded"]
    }
    
    public var licenseNumber: String?
    public var mobile: String?
    public var phonecode: String?
    public var country: Country?
    public var certificates: [Certificate]?
    public var isDetailsAdded: Int?
    public var isSessionsAdded: Int?
}
class Country: NSObject,NSCoding, Mappable{
    init(json: NSDictionary) { // Dictionary object
        self.id = json["id"] as? Int
        self.sortname = json["sortname"] as? String
        self.name = json["name"] as? String // Location of the JSON file
        self.phonecode = json["phonecode"] as? String // Location of the JSON file
        self.flag = json["flag"] as? String // Location of the JSON file
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int;
        self.sortname = aDecoder.decodeObject(forKey: "sortname") as? String;
        self.name = aDecoder.decodeObject(forKey: "name") as? String;
        self.phonecode = aDecoder.decodeObject(forKey: "phonecode") as? String;
        self.flag = aDecoder.decodeObject(forKey: "flag") as? String;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.sortname, forKey: "sortname");
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.phonecode, forKey: "phonecode");
        aCoder.encode(self.flag, forKey: "flag");
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        sortname <- map["message"]
        name <- map["name"]
        phonecode <- map["phonecode"]
        flag <- map["flag"]
    }
    public var id: Int?
    public var sortname: String?
    public var name: String?
    public var phonecode: String?
    public var flag: String?
}


class Certificate: NSObject,NSCoding, Mappable{
    init(json: NSDictionary) { // Dictionary object
        self.title = json["title"] as? String
        self.certificate = json["certificate"] as? String // Location of the JSON file
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String;
        self.certificate = aDecoder.decodeObject(forKey: "certificate") as? String;
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title");
        aCoder.encode(self.certificate, forKey: "certificate");
        
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        title <- map["title"]
        certificate <- map["certificate"]
        
    }
    public var title: String?
    public var certificate: String?
}
