//
//  PsychologistsServices.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class PsychologistsServices {
    static let shared = { PsychologistsServices() }()
    func getCountry(parameters: [String: Any] = [:], success: @escaping (Int, CityModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: COUNTRY_API, parameters: parameters, success: { (code, logout) in
            success(code, logout)
        }) { (error) in
            failure(error)
        }
    }
}
