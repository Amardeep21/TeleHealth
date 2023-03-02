//
//  CheckIUpdateService.swift
//  telehealth
//
//  Created by iroid on 27/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class CheckIUpdateService {
static let shared = { CheckIUpdateService() }()
func checkAppUpdate(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, AppVersionModel) -> (), failure: @escaping (String) -> ()) {
      APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
          success(code, speciality)
      }) { (error) in
          failure(error)
      }
  }
}
