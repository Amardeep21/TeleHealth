//
//  ProfileServices.swift
//  telehealth
//
//  Created by Apple on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class ProfileServices {
    static let shared = { ProfileServices() }()
    func logout(parameters: [String: Any] = [:],url:String, success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, logout) in
            success(code, logout)
        }) { (error) in
            failure(error)
        }
    }
    
    func getCount(parameters: [String: Any] = [:], success: @escaping (Int, CountRootModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: GET_INFORMATION, parameters: parameters, success: { (code, logout) in
              success(code, logout)
          }) { (error) in
              failure(error)
          }
      }
    
   func setting(parameters: [String: Any] = [:], success: @escaping (Int, SwitchMainModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: SETTINGS, parameters: parameters, success: { (code, changePassword) in
            success(code, changePassword)
        }) { (error) in
            failure(error)
        }
    }
    
    func changePassword(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: CHANGE_PASSWORD_API, parameters: parameters, success: { (code, changePassword) in
            success(code, changePassword)
        }) { (error) in
            failure(error)
        }
    }
    
    func deleteAccount(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .delete, urlString: USER_API, parameters: parameters, success: { (code, logout) in
            success(code, logout)
        }) { (error) in
            failure(error)
        }
    }
}
