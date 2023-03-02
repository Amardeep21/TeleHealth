//
//  RequestServices.swift
//  telehealth
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class RequestServices {
static let shared = { RequestServices() }()
func getRequest(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, RequestMainModel) -> (), failure: @escaping (String) -> ()) {
      APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, success: { (code, speciality) in
          success(code, speciality)
      }) { (error) in
          failure(error)
      }
  }
    
    func requestFreeSession(parameters: [String: Any] = [:],url:String, success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func cancelFreeSession(parameters: [String: Any] = [:],url:String, success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
}
