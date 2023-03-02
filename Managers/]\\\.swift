//
//  APIClient.swift
//  HolidaysMVVMC
//
//  Created by Zafar on 1/12/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

class APIClient {
    
    static let shared = {
        APIClient(baseURL: APIManager.shared.baseURL)
    }()
    
    var baseURL: URL?
    
    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
    }
    
    func get(urlString: String, parameters: [String: Any] = [:], success: @escaping (Int, NSData) -> (), failure: @escaping (String) -> ()) {
        
        var headerDic: HTTPHeaders = [:]
        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil )
        {
            headerDic = [
                ACCEPT:APLLICATION_JSON
            ]
        }
        else
        {
                    let userDetails  = UserDefaults.standard.object(forKey: USER_DETAILS) as? LoginModel
                    let accessToken = (userDetails?.data?.auth?.accessToken ?? "") as String
                    let authorization = "\(String(describing: userDetails?.data?.auth?.tokenType)) \(accessToken)"
                    if (accessToken != "")
                    {
                        headerDic = [
                            AUTHORIZATION:authorization,
                            ACCEPT:APLLICATION_JSON
                        ]
                    }else{
                        headerDic = [
                            AUTHORIZATION:authorization,
                            ACCEPT:APLLICATION_JSON
                        ]
                    }
                }
        
        guard let url = NSURL(string: urlString , relativeTo: self.baseURL as URL?) else {
            return
        }
        
        let urlString = url.absoluteString!
        
        _ = request(.get,
                    urlString,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headerDic)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                let statusCode = response.response?.statusCode
                success(statusCode!, response.data! as NSData)
            }, onError: { (error) in
                failure(error.localizedDescription)
            })
    }
    
    func post(urlString: String, parameters: [String: Any] = [:], success: @escaping (Int, NSData) -> (), failure: @escaping (String) -> ()) {
        
        
        var headerDic: HTTPHeaders = [:]
        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil)
        {
            headerDic = [
                ACCEPT:APLLICATION_JSON
            ]
        }
        else
        {
            var loginResponse = LoginModel()
            let data = UserDefaults.standard.object(forKey: USER_DETAILS) as! Data
            do{
                loginResponse = try JSONDecoder().decode(LoginModel.self, from: data as Data)
            }catch{
            }
            let userDetails  = UserDefaults.standard.object(forKey: USER_DETAILS) as? LoginModel
            let accessToken = (userDetails?.data?.auth?.accessToken ?? "") as String
            let authorization = "\(String(describing: userDetails?.data?.auth?.tokenType)) \(accessToken)"
            if (accessToken != "")
            {
                headerDic = [
                    AUTHORIZATION:authorization,
                    ACCEPT:APLLICATION_JSON
                ]
            }else{
                headerDic = [
                    AUTHORIZATION:authorization,
                    ACCEPT:APLLICATION_JSON
                ]
            }
        }
        
        guard let url = NSURL(string: urlString , relativeTo: self.baseURL as URL?) else {
            return
        }
        
        let urlString = url.absoluteString!
        
        _ = request(.post,
                    urlString,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headerDic)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                let statusCode = response.response?.statusCode
                success(statusCode!, response.data! as NSData)
            }, onError: { (error) in
                failure(error.localizedDescription)
            })
    }
    
}
