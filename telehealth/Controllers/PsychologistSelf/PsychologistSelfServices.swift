//
//  PsychologistSelfServices.swift
//  telehealth
//
//  Created by Apple on 19/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class PsychologistSelfServices {
    static let shared = { PsychologistSelfServices() }()
    func addPsychologistInformation(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: PSYCHOLOGIST_DETAIL_ADD_API, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func addSession(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: PSYCHOLOGIST_SESSION, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
    
    func getSessions(parameters: [String: Any] = [:] ,success: @escaping (Int, WeeklySessionsModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .get, urlString: PSYCHOLOGIST_WEEKLY_SESSION, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
}
