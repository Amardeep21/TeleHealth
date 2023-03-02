//
//  APIManager.swift
//  HolidaysMVVMC
//
//  Created by Shahrukh on 1/12/20.
//  Copyright © 2020 Shahrukh. All rights reserved.
//

import Foundation

class APIManager {
    
    static let shared = { APIManager() }()
  // Productiion
    lazy var baseURL: String = {
        return "https://juthoor.co/api/v1/"
    }()
//    Development
//    lazy var baseURL: String = {
//        return "http://13.233.208.36/telehealth/api/v1/"
//    }()
//    
    lazy var apiKey: String = {
        return "PASTE YOUR API KEY HERE"
    }()
    
}
