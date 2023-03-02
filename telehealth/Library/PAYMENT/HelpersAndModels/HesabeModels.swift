//
//  HesabeModels.swift
//  HesabeSwiftDemo
//
//  Created by Mohammed Salman on 29/03/20.
//  Copyright © 2020 Mohammed Salman. All rights reserved.
//

import Foundation

struct PaymentRequest: Codable {
    
    private var merchantCode: String
    private var responseUrl: String
    private var failureUrl: String
    private var paymentType: String
    private var version: String = "2.0"
    var amount: String
    var orderReferenceNumber: String?
    var variable1: String?
    var variable2: String?
    var variable3: String?
//    var variable4: String?
//    var variable5: String?
    
    init?(amount: String, payment type: String = "0") {
        
        guard !MERCHANT_CODE.isEmpty && MERCHANT_CODE.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else
        {
            debugPrint("Hesabe Error: Failed to set merchant code.")
            return nil
        }
        
        guard !type.isEmpty && type.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && type >= "0" && type <= "2" else {
            debugPrint("Hesabe Error: Failed to set payment type")
            return nil
        }
        
        guard !amount.isEmpty && amount >= "0" else {
            debugPrint("Hesabe Error: The payment amount is not valid")
            return nil
        }
        
        self.merchantCode = MERCHANT_CODE
        self.responseUrl  = RESPONSE_URL
        self.failureUrl  = FAILURE_URL
        self.amount = amount
        self.paymentType  = type
    }
    
    enum CodingKeys: String, CodingKey {
        case merchantCode, amount, responseUrl, paymentType, version, failureUrl
    }
}

struct PaymentToken: Codable {
    var status: Bool
    var code: Int
    var message: String
    var response: HesabeToken
    
    enum CodingKeys: String, CodingKey {
        case status, code, message, response
    }
    
    struct HesabeToken: Codable {
        var data: String
        
        enum CodingKeys: String, CodingKey {
            case data
        }
    }
}

struct PaymentResponse: Codable {
    var status: Bool
    var code: Int
    var message: String
    var response: ResponseDetail
    
    enum CodingKeys: String, CodingKey {
        case status, code, message, response
    }
    
    struct ResponseDetail: Codable {
        var resultCode: String
        var amount: Float
        var paymentToken: String
        var paymentId: String?
        var paidOn: String?
        var variable1: String?
        var variable2: String?
        var variable3: String?
        var variable4: String?
        var variable5: String?
        var method: Int
        var administrativeCharge: String
        
        enum CodingKeys: String, CodingKey {
            case resultCode, amount, paymentToken, paymentId, paidOn, variable1, variable2, variable3, variable4, variable5, method, administrativeCharge
        }
    }
}

