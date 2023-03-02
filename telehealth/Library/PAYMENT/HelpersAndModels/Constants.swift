//
//  Constants.swift
//  HesabeSwiftDemo
//
//  Created by Mohammed Salman on 15/04/20.
//  Copyright © 2020 Mohammed Salman. All rights reserved.
//

import Foundation

// Get these URL from `https://developer.hesabe.com/` -> Environments
// Replace `https://sandbox.hesabe.com` with Test URL or Production URL.

//Production
let CHECKOUT_URL = "https://api.hesabe.com/checkout"
let PAYMENT_URL = "https://api.hesabe.com/payment?data="

// Get below values from Merchant Panel, Profile section
let ACCESS_CODE = "9cb42cb6-d73a-4b32-b3c3-ed2c8b171784"
let MERCHANT_KEY = "jAvkVmK6XN3e8LyZ0A1lqL5ZBd0zbwWx"
let MERCHANT_IV = "XN3e8LyZ0A1lqL5Z"
let MERCHANT_CODE = "27350920"




//Development
//let CHECKOUT_URL = "https://sandbox.hesabe.com/checkout"
//let PAYMENT_URL = "https://sandbox.hesabe.com/payment?data="
//
//let ACCESS_CODE = "2a3789f5-edd1-416d-a472-4357794d6a8c"
//let MERCHANT_KEY = "OGzgrmqyDEnlALQRNvzPv8NJ4BwWM019"
//let MERCHANT_IV = "DEnlALQRNvzPv8NJ"
//let MERCHANT_CODE = "1351719857300"



// This URL are defined by you to get the response from Payment Gateway
let RESPONSE_URL = PAYMENT_CALL_BACK_URL
let FAILURE_URL = PAYMENT_CALL_BACK_URL

