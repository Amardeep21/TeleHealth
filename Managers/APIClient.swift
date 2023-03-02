//
//  APIClient.swift
//
//  Created by Shahrukh on 1/12/20.
//  Copyright © 2020 Shahrukh. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class APIClient {
    static let shared = {
        APIClient(baseURL: APIManager.shared.baseURL)
    }()
    
    var baseURL: URL?
    
    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
    }
    
    func getHeader() -> HTTPHeaders {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        var headerDic: HTTPHeaders = [:]
        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil)
        {
            headerDic = [
                ACCEPT:APLLICATION_JSON,
                TIMEZONE:localTimeZoneIdentifier,
                "Content-Language":Utility.getCurrentLanguage()
            ]
        }
        else
        {
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginResponse = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        let accessToken = (loginResponse.data?.auth?.accessToken ?? "") as String
                        let authorization = "\(loginResponse.data?.auth?.tokenType! ?? "") \(accessToken)"
                        if (accessToken != "")
                        {
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }else{
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }
                    }
                }catch{}
            }
        }
        print(headerDic)
        return headerDic
    }
    
    
    func requestApiWithoutParameter<T: BaseMappable>(methodType: HTTPMethod,urlString: String, parameters: [String: Any] = [:], success: @escaping (Int, T) -> (), failure: @escaping (String) -> ()) {
        let headerDic = self.getHeader()
        print(headerDic)
        guard let url = NSURL(string: urlString , relativeTo: self.baseURL as URL?) else {
            return
        }
        print(url)
        let urlString = url.absoluteString!
        
        _ = request(methodType,
                    urlString,
                    headers: headerDic)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                let statusCode = response.response?.statusCode
                if(200..<300 ~= response.response!.statusCode){
                    let statusCode = response.response?.statusCode
                    do{
                        let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                       // let resultDic = Utility.removeNullsFromDictionary(origin: json! as [String : AnyObject])as NSDictionary
                        print(json)
                        let model = Mapper<T>().map(JSON: json!)
                        success(statusCode!, model!)
                    }catch{
                    }
                }else if(statusCode == 401){
//                    let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
//                                     if let errorResponse = json as? [String: Any] {
//                                         if let message = errorResponse["message"] as? String {
//                                             failure(message)
//                                         }
//                                     }
                    self.backToChooseScreen()
                    
                }else{
                    let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                    if let errorResponse = json as? [String: Any] {
                        if let message = errorResponse["message"] as? String {
                            failure(message)
                        }
                    }
                }
            }, onError: { (error) in
                failure(error.localizedDescription)
            })
    }
    
    func requestApiWithParameter<T: BaseMappable>(methodType: HTTPMethod,urlString: String, parameters: [String: Any] = [:], success: @escaping (Int, T) -> (), failure: @escaping (String) -> ()) {
        let headerDic = self.getHeader()
        
        
        guard let url = NSURL(string: urlString , relativeTo: self.baseURL as URL?) else {
            return
        }
        
        let urlString = url.absoluteString!
        
        _ = request(methodType,
                    urlString,
                    parameters: parameters,
                    headers: headerDic)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                let statusCode = response.response?.statusCode
                if(200..<300 ~= response.response!.statusCode){
                    let statusCode = response.response?.statusCode
                    do{
                        let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                        print(json)
                        let model = Mapper<T>().map(JSON: json!)
                        success(statusCode!, model!)
                    }catch{
                    }
                }else if(statusCode == 401){
                    self.backToChooseScreen()
                }else{
                    let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                    if let errorResponse = json as? [String: Any] {
                        if let message = errorResponse["message"] as? String {
                            failure(message)
                        }
                    }
                }
            }, onError: { (error) in
                failure(error.localizedDescription)
            })
    }
    
    func backToChooseScreen(){
        UserDefaults().set("0", forKey: IS_LOGIN)
        UserDefaults.standard.set(nil, forKey: PIN_SET)
        UserDefaults.standard.set(nil, forKey: USER_DETAILS)
        UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
        SocketHelper.shared.disconnectSocket()
        let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
        control.isFromApi = true
        if let topVC = UIApplication.topViewController() {
            topVC.navigationController?.setViewControllers([control], animated: false)
        }
    }
}
//    func refreshToken(success: @escaping (Int) -> (), failure: @escaping (String) -> ()) {
//
//        var parameters: [String: Any] = [:]
//        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
//        var headerDic: HTTPHeaders = [:]
//        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
//            do{
//                if let loginResponse = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
//                    let refreshToken = (loginResponse.data?.auth?.refreshToken ?? "") as String
//                    parameters = ["refreshToken":refreshToken]
//                }
//            }catch{}
//
//         headerDic = [
//            ACCEPT:APLLICATION_JSON,
//            TIMEZONE:localTimeZoneIdentifier
//        ]
//
//        guard let url = NSURL(string: "refresh/token" , relativeTo: self.baseURL as URL?) else {
//            return
//        }
//
//        let urlString = url.absoluteString!
//
//        _ = request(.post,
//                    urlString,
//                    parameters: parameters,
//                    headers: headerDic)
//            .validate(contentType: ["application/json"])
//            .responseJSON()
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (response) in
//                let statusCode = response.response?.statusCode
//                if(200..<300 ~= response.response!.statusCode){
//                    let statusCode = response.response?.statusCode
//                    do{
//                        let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
//                        print(json)
//
//                    }catch{
//                    }
//                }else{
//                    let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
//                    if let errorResponse = json as? [String: Any] {
//                        if let message = errorResponse["message"] as? String {
//                            failure(message)
//                        }
//                    }
//                }
//            }, onError: { (error) in
//                failure(error.localizedDescription)
//            })
//    }
//
//}


