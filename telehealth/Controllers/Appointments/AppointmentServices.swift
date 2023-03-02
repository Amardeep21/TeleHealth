//
//  AppointmentServices.swift
//  telehealth
//
//  Created by Apple on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class AppointmentServices {
    static let shared = { AppointmentServices() }()
    func appointMentBooking(isFree:Bool = false,parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        if(!isFree){
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: PSYCHOLOGIST_APPOINTMENT, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
        }else{
            APIClient.shared.requestApiWithParameter(methodType: .post, urlString: PSYCHOLOGIST_PAID_APPOINTMENT, parameters: parameters, success: { (code, login) in
                success(code, login)
            }) { (error) in
                failure(error)
            }
        }
    }
    
    func checkAppointmentAvailiblity(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: CHECK_SESSION_AVAILBLITY, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func getSessionData(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, AppointmentModel) -> (), failure: @escaping (String) -> ()) {
           APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
                  success(code, speciality)
              }) { (error) in
                  failure(error)
              }
          }

    func getAppointmentDetail(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, AppointmentModel) -> (), failure: @escaping (String) -> ()) {
              APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
                     success(code, speciality)
                 }) { (error) in
                     failure(error)
                 }
             }
    
    func createOrJoinRoom(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, CallModel) -> (), failure: @escaping (String) -> ()) {
                 APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
                        success(code, speciality)
                    }) { (error) in
                        failure(error)
                    }
                }
}
