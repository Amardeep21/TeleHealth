//
//  ChatServices.swift
//  telehealth
//
//  Created by Apple on 11/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
class ChatServices {
    static let shared = { ChatServices() }()
    func getChatList(parameters: [String: Any] = [:],url: String ,success: @escaping (Int, GetChatSuceesModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithParameter(methodType: .post, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
    
    func getChat(parameters: [String: Any] = [:],url: String, success: @escaping (Int, GetChatModel) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestApiWithoutParameter(methodType: .get, urlString: url, parameters: parameters, success: { (code, speciality) in
            success(code, speciality)
        }) { (error) in
            failure(error)
        }
    }
}
