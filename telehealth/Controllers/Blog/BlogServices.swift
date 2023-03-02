//
//  BlogServices.swift
//  telehealth
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class BlogServices {
    static let shared = { BlogServices() }()
    func getBlogData(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, BlogListModel) -> (), failure: @escaping (String) -> ()) {
          APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
              success(code, speciality)
          }) { (error) in
              failure(error)
          }
      }
    func getBlogDetail(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, BlogDetailModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
}
