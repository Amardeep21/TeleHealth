//
//  FeedbackService.swift
//  telehealth
//
//  Created by iroid on 04/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class FeedbackService {
    static let shared = { FeedbackService() }()
    func setFeedback(parameters: [String: Any] = [:], success: @escaping (Int, CommanModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: REVIEW, parameters: parameters, success: { (code, login) in
            success(code, login)
        }) { (error) in
            failure(error)
        }
    }
}
