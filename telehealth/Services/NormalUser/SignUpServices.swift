//
//  SignUpServices.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class SignUpServices {
static let shared = { SignUpServices() }()
func patientSignUp(parameters: [String: Any] = [:], success: @escaping (Int, LoginModel) -> (), failure: @escaping (String) -> ()) {
    APIClient.shared.requestApiWithParameter(methodType: .post, urlString: REGISTER, parameters: parameters, success: { (code, login) in
        success(code, login)
    }) { (error) in
        failure(error)
    }
}
}
