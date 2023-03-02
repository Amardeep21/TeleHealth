//
//  HomeServices.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class HomeServices {
    static let shared = { HomeServices() }()
    func getHomeData(parameters: [String: Any] = [:],url:String, success: @escaping (Int, HomeModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
    
    func getPsychologist(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, PsychologistModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
    
    func getPsychologistProfile(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, PsychologistDetailModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
              success(code, speciality)
          }) { (error) in
              failure(error)
          }
      }
    
    func getSpeciality(parameters: [String: Any] = [:] ,success: @escaping (Int, SpecialityModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: SPECIALITY, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
    
    func getLanguage(parameters: [String: Any] = [:] ,success: @escaping (Int, LanguageModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: ONLYLANGUAGES, parameters: parameters, success: { (code, speciality) in
              success(code, speciality)
          }) { (error) in
              failure(error)
          }
      }
}
