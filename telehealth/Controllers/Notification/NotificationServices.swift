//
//  NotificationServices.swift
//  telehealth
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class NotificationServices {
static let shared = { NotificationServices() }()
func getNotifications(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, NotificationRootModel) -> (), failure: @escaping (String) -> ()) {
      APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
          success(code, speciality)
      }) { (error) in
          failure(error)
      }
  }
}
