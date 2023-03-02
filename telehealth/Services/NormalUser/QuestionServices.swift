//
//  QuestionServices.swift
//  telehealth
//
//  Created by Apple on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class QuestionServices {
    static let shared = { QuestionServices() }()
    func sendQuestionAnswers(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: QUESTION_API, parameters: parameters, success: { (code, forgotPassword) in
            success(code, forgotPassword)
        }) { (error) in
            failure(error)
        }
    }
    func getQuestions(parameters: [String: Any] = [:], success: @escaping (Int, QuestionRootModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: QUESTIONS, parameters: parameters, success: { (code, forgotPassword) in
            success(code, forgotPassword)
        }) { (error) in
            failure(error)
        }
    }
}
