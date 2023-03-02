////
////  RequestManager.swift
////  Iroid
////
////  Created by iroid on 30/03/18.
////  Copyright © 2018 iroidiroid. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//
//protocol RequestManagerDelegate {
//    func onResult(result:NSMutableDictionary)
//    func onFault(error:NSError)
//}
//
//
//class RequestManager: NSObject {
//    
//    var commandName: String!
//    
//    var tag: String!
//    
//    var delegate: RequestManagerDelegate?
//    var refreshTokencheckMethod = false
//    var refreshTokencheckMethodCall = 0
//    func CallPostURL(url: String, parameters params: NSDictionary)
//    {
//        var newString : String
//        newString = commandName
//        var headerDic:HTTPHeaders?
//        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil )
//        {
//            headerDic = [
//                ACCEPT:APLLICATION_JSON
//            ]
//        }
//        else
//        {
//            let accessTokenDictionary  = (UserDefaults.standard.object(forKey: AccessTokenn) as? NSDictionary)!
//            let accessToken = accessTokenDictionary[ACCESS_TOKEN] as! String
//            let authorization = "\(ACCESS_KEY) \(accessToken)"
//            if (accessToken != "")
//            {
//                headerDic = [
//                    AUTHORIZATION:authorization,
//                    ACCEPT:APLLICATION_JSON
//                ]
//            }else{
//                headerDic = [
//                    AUTHORIZATION:authorization,
//                    ACCEPT:APLLICATION_JSON
//                ]
//            }
//        }
//        print(headerDic)
//        print(params)
//        let setUrl = "\(BASE_URL)\(newString)"
//        print(setUrl)
//        
//        AF.request(setUrl, method: .post, parameters: (params as! Parameters) ,encoding: URLEncoding.default, headers: headerDic).responseJSON {
//            response in
//            switch response.result {
//            case .success(let value):
//                if response.response != nil
//                {
//                    
//                    print(String(data: value as! Data, encoding: .utf8)!)
//                    print(response.response?.statusCode)
//                    
//                     let responseObject = value as! NSDictionary
//                        let result : NSMutableDictionary = responseObject.mutableCopy() as! NSMutableDictionary
//                        print(result)
//                        switch response.response?.statusCode {
//                        case 401:
//                            self.refreshTokencheckMethodCall = 1
//                            self.refreshTokencheckMethod = POST_METHOD_CALL
//                            self.NewAccessTockenCallGetURL(url: BASE_URL, parameters: params)
//                            return
//                        case 403:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                            }
//                            if (self.tag != nil) {
//                                result[TAG] = self.tag
//                            }
//                            self.delegate?.onResult(result: result)
//                            break
//                        case 404:
//                            self.delegate?.onFault(error:MyError.apiNotFound as NSError)
//                        case 405:
//                            self.delegate?.onFault(error:MyError.methodNotFound as NSError)
//                            case 429:
//                                                       self.delegate?.onFault(error: MyError.tooManyAttempts as NSError)
//                        case 422:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                            }
//                            if (self.tag != nil) {
//                                result[TAG] = self.tag
//                            }
//                            self.delegate?.onResult(result: result)
//                            break
//                        case 500:
//                            self.delegate?.onFault(error:MyError.internalServerError as NSError)
//                        case 200:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                            }
//                            if (self.tag != nil) {
//                                result[TAG] = self.tag
//                            }
//                            self.delegate?.onResult(result: result)
//                            break
//                        // ...........
//                        default:
//                            print(value)
//                        }
//                        
//                   
//                }
//                
//                break
//            case .failure(let error):
//                self.delegate?.onFault(error: error as NSError)
//            }
//        }
//        
//    }
//    
//    
//    func CallGetURL(url: String , parameters params: NSDictionary)
//    {
//        var headerDic:HTTPHeaders?
//        var accessTokenDictionary = NSDictionary()
//        
//        
//        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil )
//        {
//            headerDic = [
//                
//                ACCEPT:APLLICATION_JSON
//            ]
//        }else{
//            if let AccessTokenValue = (UserDefaults.standard.object(forKey: AccessTokenn) as? NSDictionary){
//                accessTokenDictionary = AccessTokenValue
//            }
//            let accessToken = accessTokenDictionary[ACCESS_TOKEN] as! String
//            let authorization = "\(ACCESS_KEY) \(accessToken)"
//            if (accessToken != "")
//            {
//                headerDic = [
//                    AUTHORIZATION:authorization,
//                    ACCEPT:APLLICATION_JSON
//                ]
//            }else{
//                headerDic = [
//                    AUTHORIZATION:authorization,
//                    ACCEPT:APLLICATION_JSON
//                ]
//            }
//        }
//        print(headerDic)
//        print(params)
//        
//        let setUrl = "\(url)\(commandName!)"
//        print(setUrl)
//        AF.request(setUrl, method: .get, parameters: params as? Parameters ,encoding: URLEncoding(destination: .queryString), headers: headerDic).responseJSON {
//            response in
//            switch response.result {
//            case .success(let value):
//                if response.response != nil
//                {
//                    print(response.response?.statusCode)
//                    
//                        let responseObject = value as! NSDictionary
//                        let result : NSMutableDictionary = responseObject.mutableCopy() as! NSMutableDictionary
//                        switch response.response?.statusCode {
//                            
//                        case 401:
//                            self.refreshTokencheckMethodCall = 2
//                            self.refreshTokencheckMethod = GET_METHOD_CALL
//                            self.NewAccessTockenCallGetURL(url: BASE_URL, parameters: params)
//                            return
//                        case 404:
//                            self.delegate?.onFault(error:MyError.apiNotFound as NSError)
//                        case 405:
//                            self.delegate?.onFault(error:MyError.methodNotFound as NSError)
//                        case 500:
//                            self.delegate?.onFault(error:MyError.internalServerError as NSError)
//                        case 429:
//                            self.delegate?.onFault(error: MyError.tooManyAttempts as NSError)
//                        case 422:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                            }
//                            if (self.tag != nil) {
//                                result[TAG] = self.tag
//                            }
//                            self.delegate?.onResult(result: result)
//                            break
//                        case 200:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                                self.delegate?.onResult(result: result)
//                            }
//                            break
//                        // ...........
//                        default:
//                            print(value)
//                        }
//                  
//                }
//                break
//            case .failure(let error):
//                self.delegate?.onFault(error: error as NSError)
//            }
//        }
//    }
//    
//    
//    func CallPutURL(url: String , parameters params: NSDictionary)
//    {
//        var headerDic:HTTPHeaders?
//        let accessTokenDictionary  = (UserDefaults.standard.object(forKey: AccessTokenn) as? NSDictionary)!
//        let accessToken = accessTokenDictionary[ACCESS_TOKEN] as! String
//        let authorization = "\(ACCESS_KEY) \(accessToken)"
//        if (accessToken != "")
//        {
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }else{
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }
//        
//      print(headerDic)
//        print(params)
//        let setUrl = "\(url)\(commandName!)"
//        print(setUrl)
//        
//       AF.request(setUrl, method: .put, parameters: params as? Parameters ,encoding: URLEncoding.default, headers: headerDic).responseJSON {
//            response in
//            switch response.result {
//            case .success(let value):
//                if response.response != nil
//                {
//                    print(response.response?.statusCode)
//                    
//                        let responseObject = value as! NSDictionary
//                        let result : NSMutableDictionary = responseObject.mutableCopy() as! NSMutableDictionary
//                        print(result)
//                        switch response.response?.statusCode {
//                        case 401:
//                            self.refreshTokencheckMethodCall = 3
//                            self.refreshTokencheckMethod = POST_METHOD_CALL
//                            self.NewAccessTockenCallGetURL(url: BASE_URL, parameters: params)
//                            return
//                        case 404:
//                            self.delegate?.onFault(error:MyError.apiNotFound as NSError)
//                        case 405:
//                            self.delegate?.onFault(error:MyError.methodNotFound as NSError)
//                        case 422:
//                            self.delegate?.onFault(error:MyError.inValideInsertData as NSError)
//                        case 500:
//                            self.delegate?.onFault(error:MyError.internalServerError as NSError)
//                        case 429:
//                            self.delegate?.onFault(error: MyError.tooManyAttempts as NSError)
//                        case 200:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName+PUT
//                                self.delegate?.onResult(result: result)
//                            }
//                            break
//                        // ...........
//                        default:
//                            print(value)
//                            
//                        }
//                   
//                }
//                break
//            case .failure(let error):
//                self.delegate?.onFault(error: error as NSError)
//            }
//        }
//    }
//    
//    
//    func CallDeleteURL(url: String , parameters params: NSDictionary)
//    {
//       var headerDic:HTTPHeaders?
//        let accessTokenDictionary  = (UserDefaults.standard.object(forKey: AccessTokenn) as? NSDictionary)!
//        let accessToken = accessTokenDictionary[ACCESS_TOKEN] as! String
//        let authorization = "\(ACCESS_KEY) \(accessToken)"
//        if (accessToken != "")
//        {
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }else{
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }
//        print(headerDic)
//        print(params)
//        let setUrl = "\(url)\(commandName!)"
//        print(setUrl)
//        AF.request(setUrl, method: .delete, parameters: params as? Parameters ,encoding: URLEncoding.default, headers: headerDic).responseJSON {
//            response in
//            switch response.result {
//           case .success(let value):
//                if response.response != nil
//                {
//                    print(response.response?.statusCode)
//                    
//                        let responseObject = value as! NSDictionary
//                        let result : NSMutableDictionary = responseObject.mutableCopy() as! NSMutableDictionary
//                        print(result)
//                        switch response.response?.statusCode {
//                        case 401:
//                            self.refreshTokencheckMethodCall = 4
//                            self.refreshTokencheckMethod = POST_METHOD_CALL
//                            self.NewAccessTockenCallGetURL(url: BASE_URL, parameters: params)
//                            return
//                        //                            self.delegate?.onFault(error:MyError.Unauthorized as NSError)
//                        case 404:
//                            self.delegate?.onFault(error:MyError.apiNotFound as NSError)
//                        case 405:
//                            self.delegate?.onFault(error:MyError.methodNotFound as NSError)
//                        case 422:
//                            self.delegate?.onFault(error:MyError.inValideInsertData as NSError)
//                        case 500:
//                            self.delegate?.onFault(error:MyError.internalServerError as NSError)
//                        case 429:
//                            self.delegate?.onFault(error: MyError.tooManyAttempts as NSError)
//                        case 200:
//                            if (self.commandName != nil) {
//                                result[COMMAND] = self.commandName
//                                self.delegate?.onResult(result: result)
//                            }
//                            break
//                        // ...........
//                        default:
//                            print(value)
//                            
//                      
//                    }
//                }
//                break
//            case .failure(let error):
//                self.delegate?.onFault(error: error as NSError)
//            }
//        }
//    }
//    
//    func NewAccessTockenCallGetURL(url: String , parameters params: NSDictionary)
//    {
//        
//        
//       var headerDic:HTTPHeaders?
//        let accessTokenDictionary  = (UserDefaults.standard.object(forKey: AccessTokenn) as? NSDictionary)!
//        let accessToken = accessTokenDictionary[ACCESS_TOKEN] as! String
//        let authorization = "\(ACCESS_KEY) \(accessToken)"
//        if (accessToken != "")
//        {
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }else{
//            headerDic = [
//                AUTHORIZATION:authorization,
//                ACCEPT:APLLICATION_JSON
//            ]
//        }
//        
//        let refreshTokenString =  accessTokenDictionary[REFRESH_TOKEN] as! String
//        let newAccessTokenDictionary = [REFRESSH_TOKENN:refreshTokenString] as NSDictionary
//        
//        let setUrl1 = "\(url)\(API.REFRESH_TOKEN)"
//        
//       AF.request(setUrl1, method: .post, parameters: (newAccessTokenDictionary as! Parameters) ,encoding: URLEncoding.default, headers: headerDic).responseJSON {
//            response in
//            switch response.result {
//            case .success(let value):
//                if response.response != nil
//                {
//                    print(response.response?.statusCode)
//                  
//                        let responseObject = value as! NSDictionary
//                        let result : NSMutableDictionary = responseObject.mutableCopy() as! NSMutableDictionary
//                        var resultDic = NSMutableDictionary()
//                        if let value = (result[DATA] as? NSDictionary) {
//                            print(value)
//                            resultDic = (result[DATA] as! NSDictionary).mutableCopy() as! NSMutableDictionary
//                        }else{
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOG_OUT_NOTIFICATION), object: nil, userInfo: nil)
//                            return
//                        }
//                        
//                        UserDefaults().set(resultDic, forKey:AccessTokenn)
//                        if self.refreshTokencheckMethodCall == 1{
//                            self.CallPostURL(url: BASE_URL, parameters: params)
//                        }else if self.refreshTokencheckMethodCall == 2{
//                            self.CallGetURL(url: BASE_URL, parameters: params)
//                        }else if self.refreshTokencheckMethodCall == 3{
//                            self.CallPutURL(url: BASE_URL, parameters: params)
//                        }else if self.refreshTokencheckMethodCall == 4{
//                            self.CallDeleteURL(url: BASE_URL, parameters: params)
//                        }
//                    }
//               
//                
//                break
//            case .failure(let error):
//                self.delegate?.onFault(error: error as NSError)
//            }
//        }
//        
//    }
//    
//    func json(from object:Any) -> String? {
//        
//        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
//            return nil
//        }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
//    
//    
//}
