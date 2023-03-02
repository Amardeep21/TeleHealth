//
//  SessionServices.swift
//  telehealth
//
//  Created by Apple on 20/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation

class SessionServices {
    static let shared = { SessionServices() }()
  
    func getAvailabilitySession(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, PsychologistSessionAvailabilityModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, sessionAvailability) in
                  success(code, sessionAvailability)
              }) { (error) in
                  failure(error)
              }
          }
    
    func getAvailabilityMonthlySession(parameters: [String: Any] = [:],success: @escaping (Int, MonthlySlotsRootModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: MONTHLY_SLOTS_AVAILBLITY, parameters: parameters, success: { (code, sessionAvailability) in
                  success(code, sessionAvailability)
              }) { (error) in
                  failure(error)
              }
          }
    
    func updateSession(parameters: [String: Any] = [:], success: @escaping (Int, PsychologistSessionAvailabilityModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: UPDATE_SESSION, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func cencelSession(parameters: [String: Any] = [:],url: String, success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    
    func rescheduleSession(parameters: [String: Any] = [:],url: String, success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
           APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, login) in
               success(code, login)
           }) { (error) in
               failure(error)
           }
       }
    }

