//
//  LoginServices.swift
//  telehealth
//
//  Created by Apple on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation

class LoginServices {
    static let shared = { LoginServices() }()
    func login(parameters: [String: Any] = [:], success: @escaping (Int, LoginModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: LOGIN_API, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func registerForPush(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: REGISTER_FOR_PUSH, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func socialLogin(parameters: [String: Any] = [:], success: @escaping (Int, LoginModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithParameter(methodType: .post, urlString: SOCIAL_LOGIN, parameters: parameters, success: { (code, login) in
              success(code, login)
          }) { (error) in
              failure(error)
          }
      }

    func socialRegister(parameters: [String: Any] = [:], success: @escaping (Int, LoginModel) -> (), failure: @escaping (String) -> ()) {
             APIClient.shared.requestApiWithParameter(methodType: .post, urlString: SOCIAL_REGISTER, parameters: parameters, success: { (code, login) in
                 success(code, login)
             }) { (error) in
                 failure(error)
             }
         }
    func forgotPassword(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: FORGOT_PASSWORD_API, parameters: parameters, success: { (code, forgotPassword) in
            success(code, forgotPassword)
        }) { (error) in
            failure(error)
        }
    }
    
    func sendVerificationEmail(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: SEND_VERIFICATION_EMAIL_API, parameters: parameters, success: { (code, forgotPassword) in
            success(code, forgotPassword)
        }) { (error) in
            failure(error)
        }
    }
    
    func alreadyVerified(parameters: [String: Any] = [:], success: @escaping (Int, LoginModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: ALREDY_VERIFIED_EMAIL, parameters: parameters, success: { (code, forgotPassword) in
            success(code, forgotPassword)
        }) { (error) in
            failure(error)
        }
    }
}
