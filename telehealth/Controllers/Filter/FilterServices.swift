//
//  FilterServices.swift
//  telehealth
//
//  Created by iroid on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class FilterServices {
static let shared = { FilterServices() }()
func getLanguage(parameters: [String: Any] = [:], success: @escaping (Int, LanguageModel) -> (), failure: @escaping (String) -> ()) {
    APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: LANGUAGES, parameters: parameters, success: { (code, speciality) in
        success(code, speciality)
    }) { (error) in
        failure(error)
    }
}
}
