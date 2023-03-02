//
//  AppointmentsServices.swift
//  telehealth
//
//  Created by iroid on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class AppointmentsServices {
    static let shared = { AppointmentsServices() }()
    func getHomeData(parameters: [String: Any] = [:], success: @escaping (Int, HomeModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: HOME, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
}
