//
//  PsychologistsHomeService.swift
//  telehealth
//
//  Created by iroid on 20/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import Foundation
class PsychologistsHomeService {
    static let shared = { PsychologistsHomeService() }()
    func getHomeData(parameters: [String: Any] = [:],url:String, success: @escaping (Int, PsychologistsHomeModel) -> (), failure: @escaping (String) -> ()) {
    
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
    
    
    func getStatus(parameters: [String: Any] = [:],url:String, success: @escaping (Int, StatusRootModel) -> (), failure: @escaping (String) -> ()) {
    
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
//    func getPsychologist(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, PsychologistModel) -> (), failure: @escaping (String) -> ()) {
//        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
//            success(code, speciality)
//        }) { (error) in
//            failure(error)
//        }
//    }
//
//    func getPsychologistProfile(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, PsychologistDetailModel) -> (), failure: @escaping (String) -> ()) {
//          APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
//              success(code, speciality)
//          }) { (error) in
//              failure(error)
//          }
//      }
//
//    func getSpeciality(parameters: [String: Any] = [:] ,success: @escaping (Int, SpecialityModel) -> (), failure: @escaping (String) -> ()) {
//        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: SPECIALITY, parameters: parameters, success: { (code, speciality) in
//            success(code, speciality)
//        }) { (error) in
//            failure(error)
//        }
//    }
}
