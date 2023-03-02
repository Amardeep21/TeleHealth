//
//  TestFairyLog.swift
//  YetiVisit360
//
//  Created by iroid on 10/08/18.
//  Copyright © 2018 iroid. All rights reserved.
//

import Foundation


//public func print(_ format: String, _ args: CVarArg...) {
//    let message = String(format: format, arguments:args)
//    print(message);
//    TFLogv(message, getVaList([]))
//}

public func print(_ items: Any...) {
    #if DEBUG
        Swift.print(items[0])
    #endif
}
