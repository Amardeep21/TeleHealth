//
//  ErrorManager.swift
//  telehealth
//
//  Created by Shahrukh on 05/08/20.
//  Copyright © 2020 Shahrukh. All rights reserved.
//

import Foundation

public enum MyError: Error {
    case apiNotFound
    case internalServerError
    case methodNotFound
    case Unauthorized
    case bedRequest
    case inValideInsertData
    case loggedAccessError
    case tooManyAttempts
}
extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiNotFound:
            return NSLocalizedString("API not found.", comment: "My error")
        case .internalServerError:
            return NSLocalizedString("Internal Server Error.", comment: "My error")
        case .methodNotFound:
            return NSLocalizedString("Method Not Allowed", comment: "My error")
        case .Unauthorized:
            return NSLocalizedString("Unauthorized", comment: "My error")
        case .bedRequest:
            return NSLocalizedString("Unauthorized", comment: "My error")
        case .inValideInsertData:
            return NSLocalizedString("The value is invalid", comment: "My error")
        case .loggedAccessError:
        return NSLocalizedString("Logged in but access to requested area is forbidden", comment: "My error")
        case .tooManyAttempts:
        return NSLocalizedString("too many attempts wait some time", comment: "My error")
        }
    }
}
