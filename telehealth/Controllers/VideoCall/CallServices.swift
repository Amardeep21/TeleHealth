//
//  CallServices.swift
//  telehealth
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class CallServices {
    static let shared = { CallServices() }()
    func endAppointment(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
              success(code, speciality)
          }) { (error) in
              failure(error)
          }
      }
}
