//
//  UserDetail.swift
//  LTS-App
//
//  Created by iroid on 28/04/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import UIKit

class FacebookUserDetail:NSObject{
    var socialEmailId : String?
    var socialName : String?
    var socialId : String?
    var socialPic : String?
    var socialType : String?
    var socialGender : String?
    var socialBirthdate : String?
    var firstName: String?
   var lastName: String?
    init(userDataDictionary:NSDictionary) {
        
        socialName = (userDataDictionary["name"] as? String ?? "")
        firstName = userDataDictionary["first_name"] as? String
        lastName = userDataDictionary["last_name"] as? String
        print(firstName)
        print(lastName)
        socialEmailId = (userDataDictionary["email"] as? String ?? "")
        socialId = (userDataDictionary["id"] as? String ?? "")
        socialGender = (userDataDictionary["gender"] as? String ?? "")
        socialBirthdate = (userDataDictionary["birthday"] as? String ?? "")
        socialType = "facebook"
        let socialPictureDictionary = userDataDictionary["picture"] as! NSDictionary
        let socialDataDictionary = socialPictureDictionary["data"] as! NSDictionary
        print(socialPictureDictionary)
        print(socialDataDictionary)
        self.socialPic = ""
        if socialDataDictionary.count > 0 {
            if socialDataDictionary["url"] as? String == nil {
                self.socialPic = ""
            }else{
                self.socialPic = (socialDataDictionary["url"] as! String)
            }
        }
        
    }
}
