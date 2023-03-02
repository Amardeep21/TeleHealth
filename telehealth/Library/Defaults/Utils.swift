//
//  Utils.swift
//  Caddie
//
//  Created by iroid on 4/5/18.
//  Copyright © 2018 iroid. All rights reserved.
//

import Foundation
import UIKit



class Utils{
    
class func setLocalizedValuesforView(_ view: UIView, andSubViews isSubViews: Bool) {
    
    var lang = ""
    // if ([lang isEqualToString:@""]) {
    lang = NSLocale.preferredLanguages.first ?? ""
    // }
    if (lang.count ) > 2 {
        lang = (lang as? NSString)?.substring(to: 2) ?? ""
    }
    
    if (view is UILabel) {
        let label = view as? UILabel
        let title: String? = label?.text
        label?.text = getLocalizdString(title!, language: lang)
    }
    else if (view is UIButton) {
        let button = view as? UIButton
        let title: String? = button?.titleLabel?.text
        button?.setTitle(getLocalizdString(title!, language: lang), for: .normal)
    }
    else if (view is UITextField) {
        let textField = view as? UITextField
        var title: String? = textField?.text
        if (title == "") {
            title = textField?.placeholder
            textField?.placeholder = getLocalizdString(title!, language: lang)
            return
        }
        textField?.text = getLocalizdString(title!, language: lang)
    }
    else if (view is UITextView) {
        let textView = view as? UITextView
        let title: String = (textView?.text)!
        textView?.text = getLocalizdString(title, language: lang)
    }else if (view is UITextField) {
        
    }
    if isSubViews {
        for sview: UIView in view.subviews {
            setLocalizedValuesforView(sview, andSubViews: true)
        }
    }
}

class func getLocalizdString(_ value: String, language: String) -> String {
    var lang = language
    if (lang == "") {
        lang = NSLocale.preferredLanguages.first ?? ""
    }
    if (lang.count ) > 2 {
        lang = (lang as? NSString)?.substring(to: 2) ?? ""
    }
    let path: String? = Bundle.main.path(forResource: lang, ofType: "lproj")
    let languageBundle = Bundle(path: path!)
    let str = languageBundle?.localizedString(forKey: value, value: value, table: nil)
    return str ?? ""
}
    

}
