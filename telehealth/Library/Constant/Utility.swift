//
//  Utility.swift
//  Iroid
//
//  Created by iroid on 30/03/18.
//  Copyright © 2018 iroidiroid. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import CoreLocation

class Utility: NSObject {
    
    class func showAlert(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: (Utility.getLocalizdString(value: "OK")), style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showActionAlert(vc: UIViewController,message: String)
    {
        
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: (Utility.getLocalizdString(value: "OK")), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showNoInternetConnectionAlertDialog(vc: UIViewController) {
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: "It seems you are not connected to the internet. Kindly connect and try again", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: (Utility.getLocalizdString(value: "OK")), style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertSomethingWentWrong(vc: UIViewController) {
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: "Oops! Something went wrong. Kindly try again later", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: (Utility.getLocalizdString(value: "OK")), style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func getCurrentUserName() -> String {
        if UserDefaults.standard.object(forKey: USER_DETAILS) == nil {
            return ""
        }else{
            let userDictionary = (UserDefaults.standard.object(forKey: USER_DETAILS) as? NSDictionary)!
            if userDictionary.object(forKey: USERNAME) == nil {
                return ""
            }
            return userDictionary.object(forKey: USERNAME) as! String
        }
    }
    class func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    class func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
  
    class func checkForEmptyString(valueString: String) -> Bool {
        if valueString.isEmpty {
            return true
        }else{
            return false
        }
    }
    
    class func getCurrentUserId() -> String {
        let userDictionary = (UserDefaults.standard.object(forKey: USER_DETAILS) as? NSDictionary)!
        return userDictionary.object(forKey: USER_IDD) as! String
        //        return "1"
    }
    
    //    class func getCurrentUserProfilePicture() -> String {
    //        let userDictionary = (UserDefaults.standard.object(forKey: USER_DETAILS) as? NSMutableDictionary)!
    //        return userDictionary.object(forKey: PROFILE_PIC) as! String
    //    }
    
    class func showIndicator() {
        //         AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    class func hideIndicator() {
        //        AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SwiftLoader.hide()
    }
    class func showIndecatorForProduct() {
        //         AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SwiftLoaderForTransaction.show(title: "Loading...", animated: true)
    }
    class func hideIndicatorForProduct() {
           //        AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = true
           DispatchQueue.main.async {
               UIApplication.shared.isNetworkActivityIndicatorVisible = false

           }
        
           SwiftLoaderForTransaction.hide()
       }
    //MARK: reachability
    class func isInternetAvailable() -> Bool
    {
        var  isAvailable : Bool
        isAvailable = true
        let reachability = Reachability()!
        if(reachability.connection == .none)
        {
            isAvailable = false
        }
        else
        {
            isAvailable = true
        }
        
        return isAvailable
        
    }
    
    class func isUserAlreadyLogin() -> Bool
    {
        var  isLogin : Bool
        isLogin = false
        if (UserDefaults.standard.object(forKey: IS_LOGIN) != nil) {
            let isUserLogin = (UserDefaults.standard.object(forKey: IS_LOGIN) as? String)!
            if (isUserLogin=="1") {
                isLogin = true
            }
        }
        return isLogin
        
    }
    
    class func getUserTokenKey() -> String {
        let userDictionary = (UserDefaults.standard.object(forKey: USER_DETAILS) as? NSDictionary)!
        
        return userDictionary.object(forKey: ACCESS_TOKEN) as! String
    }
    
    
    func AddSubViewtoParentView(parentview: UIView! , subview: UIView!)
    {
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
        
    }
    class func removeNullsFromDictionary(origin:[String:AnyObject]) -> NSMutableDictionary{
        var destination:NSMutableDictionary = [:]
        for key in origin.keys {
            if origin[key] != nil && !(origin[key] is NSNull)
            {
                if origin[key] is [String:AnyObject]
                {
                    destination[key] = self.removeNullsFromDictionary(origin: origin[key] as! [String:AnyObject]) as AnyObject
                } else if origin[key] is [AnyObject]
                {
                    let orgArray = origin[key] as! [AnyObject]
                    var destArray: [AnyObject] = []
                    for item in orgArray {
                        if item is [String:AnyObject]
                        {
                            destArray.append(self.removeNullsFromDictionary(origin: item as! [String:AnyObject]) as AnyObject)
                        } else
                        {
                            destArray.append(item)
                        }
                    }
                    destination[key] = destArray as AnyObject
                }
                else {
                    destination[key] = origin[key]
                    if key == "description" {
                        destination[key] = "" as AnyObject
                    }
                }
            } else {
                
                destination[key] = "" as AnyObject
            }
        }
        return destination
    }
    class func decorateTags(_ stringWithTags: String?) -> NSMutableAttributedString? {
        var error: Error? = nil
        //For "Vijay #Apple Dev"
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: "#(\\w+)", options: [])
        } catch {
        }
        //For "Vijay @Apple Dev"
        //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
        let matches = regex?.matches(in: stringWithTags ?? "", options: [], range: NSRange(location: 0, length: stringWithTags?.count ?? 0))
        var attString = NSMutableAttributedString(string: stringWithTags ?? "")
        
        let stringLength = stringWithTags?.count ?? 0
        for match in matches! {
            let wordRange = match.range(at: 0)
            let word = (stringWithTags as NSString?)?.substring(with: wordRange)
        
            let foregroundColor = Utility.getUIcolorfromHex(hex: "5527BD")
            attString.addAttribute(.foregroundColor, value: foregroundColor, range: wordRange)
            
            print("Found tag \(word ?? "")")
        }
        return attString
    }
    
    class func getUIcolorfromHex(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    
  
    
    //    class func getCompressImageData(_ originalImage: UIImage?) -> Data?
    //    {
    //        let imageData = originalImage?.lowestQualityJPEGNSData
    //        print(imageData)
    //        return imageData as! Data
    //    }
    class func getCompressImageData(_ originalImage: UIImage?) -> Data? {
        // UIImage *largeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        let largeImage: UIImage? = originalImage
        
        var compressionRatio: Double = 1
        var resizeAttempts: Int = 3
//        var imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
        var imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        print(String(format: "Starting Size: %lu", UInt(imgData?.count ?? 0)))
        
        if (imgData?.count)! > 1000000 {
            resizeAttempts = 4
        } else if (imgData?.count)! > 400000 && (imgData?.count)! <= 1000000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 100000 && (imgData?.count)! <= 400000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 40000 && (imgData?.count)! <= 100000 {
            resizeAttempts = 1
        } else if (imgData?.count)! > 10000 && (imgData?.count)! <= 40000 {
            resizeAttempts = 1
        }
        
        print("resizeAttempts \(resizeAttempts)")
        
        while resizeAttempts > 0 {
            resizeAttempts -= 1
            print("Image was bigger than 400000 Bytes. Resizing.")
            print(String(format: "%i Attempts Remaining", resizeAttempts))
            compressionRatio = compressionRatio * 0.6
            print("compressionRatio \(compressionRatio)")
            print(String(format: "Current Size: %lu", UInt(imgData?.count ?? 0)))
//            imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
            imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
            print(String(format: "New Size: %lu", UInt(imgData?.count ?? 0)))
        }
        
        //Set image by comprssed version
        let savedImage = UIImage(data: imgData!)
        
        //Check how big the image is now its been compressed and put into the UIImageView
        // *** I made Change here, you were again storing it with Highest Resolution ***
        
//        var endData = UIImageJPEGRepresentation(savedImage!, CGFloat(compressionRatio))
        var endData = savedImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        //NSData *endData = UIImagePNGRepresentation(savedImage);
        
        print(String(format: "Ending Size: %lu", UInt(endData?.count ?? 0)))
        
        return endData
    }
    
    class func setImage(_ imageUrl: String!, imageView: UIImageView!) {
        if imageUrl != nil && !(imageUrl == "") {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            imageView.sd_setShowActivityIndicatorView(true)
//            imageView.sd_setIndicatorStyle(.gray)
            imageView!.sd_setImage(with: URL(string: imageUrl! ), placeholderImage: UIImage(named: "place_holder_image"))
        }
        else
        {
            imageView?.image = UIImage(named: "place_holder_image")
        }
    }
    
    class func silentModeSoundOn(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
        }
    }
    class func setMonth(strMonth: String) -> String
    {
        let strMonth=strMonth.lowercased();
        var strSpanishMonth = "" ;
        if strMonth == ("january") || strMonth == "enero" {
            strSpanishMonth="Enero"
        }
        else if strMonth == "february" || strMonth == "febrero" {
            strSpanishMonth="Febrero"
        }
        else if strMonth == "march" || strMonth == "marzo" {
            strSpanishMonth="Marzo"
        }
        else if strMonth == "april" || strMonth == "abril" {
            strSpanishMonth="Abril"
        }
        else if strMonth == "may" || strMonth == "mayo" {
            strSpanishMonth="Mayo"
        }
        else if strMonth == "june" || strMonth == "junio" {
            strSpanishMonth="Junio"
        }
        else if strMonth == "july" || strMonth == "julio" {
            strSpanishMonth="Junio"
        }
        else if strMonth == "august" || strMonth == "agosto" {
            strSpanishMonth="Agosto"
        }
        else if strMonth == "september" || strMonth == "septiembre" {
            strSpanishMonth="Septiembre"
        }
        else if strMonth == "october" || strMonth == "octubre" {
            strSpanishMonth="Octubre"
        }
        else if strMonth == "november" || strMonth == "noviembre" {
            strSpanishMonth="Noviembre"
        }
        else {
            strSpanishMonth = "Diciembre";
        }
        return strSpanishMonth;
    }
    
    class func setDay(strDay: String) -> String
    {
        let strDay=strDay.lowercased();
        var strEnglishDay = "" ;
        if strDay == "monday" {
            strEnglishDay="Monday"
        }
        else if strDay == "tuesday" {
            strEnglishDay="Tuesday"
        }
        else if strDay == "wednesday" {
            strEnglishDay="Wednesday"
        }
        else if strDay == "thursday" {
            strEnglishDay="Thursday"
        }
        else if strDay == "friday" {
            strEnglishDay="Friday"
        }
        else if strDay == "saturday" {
            strEnglishDay="Saturday"
        }
        else {
            strEnglishDay="Sunday"
        }
        return strEnglishDay;
    }
    
    class func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = SERVER_DATE_FORMATE
        inputFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        inputFormatter.locale = Locale(identifier: "en")
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en")
            outputFormatter.dateFormat = format
            outputFormatter.timeZone = NSTimeZone.local
            
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    class func addSuperScriptToLabel(label: UILabel, superScriptCount count: Int, fontSize size: CGFloat) {
        let font:UIFont? = UIFont(name: label.font!.fontName, size:size)
        let fontSuper:UIFont? = UIFont(name: label.font!.fontName, size:size/1.5)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: label.text!, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:((label.text?.count)!-count),length:count))
        label.attributedText = attString
    }
    
    //    class func getNumberOfItemInCart() -> String? {
    //
    //        if(UserDefaults.standard.object(forKey: CART_PRODUCTS) != nil ){
    //            let cartArray = UserDefaults.standard.object(forKey: CART_PRODUCTS) as! NSArray
    //           return String(cartArray.count)
    //
    //        }
    //        return "0"
    //    }
    //
    class func getCurrentLocalTime(format: String) -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: now)
    }
    
    class func makeBlueBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 1, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width , height: 1)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    class func makeGrayBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: 1)
        border.borderWidth = textField.frame.size.width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    class func makeClearBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: 1)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    class func getTime(index: Int) -> String{
        switch (index) {
        case (0):
            let string = Utility.localToUTC(date: SEVENAM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (1):
            let string = Utility.localToUTC(date: EIGHTAM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (2):
            let string = Utility.localToUTC(date: NINEAM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (3):
            let string = Utility.localToUTC(date: TENAM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (4):
            let string = Utility.localToUTC(date: ELEVENAM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (5):
            let string = Utility.localToUTC(date: TWELVEPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (6):
            let string = Utility.localToUTC(date: ONEPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (7):
            let string = Utility.localToUTC(date: TWOPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (8):
            let string = Utility.localToUTC(date: THREEPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (9):
            let string = Utility.localToUTC(date: FOURPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (10):
            let string = Utility.localToUTC(date: FIVEPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (11):
            let string = Utility.localToUTC(date: SIXPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (12):
            let string = Utility.localToUTC(date: SEVENPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (13):
            let string = Utility.localToUTC(date: EIGHTPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (14):
            let string = Utility.localToUTC(date: NINEPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (15):
            let string = Utility.localToUTC(date: TENPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        case (16):
            let string = Utility.localToUTC(date: ELEVENPM, fromFormat: "hh:mma", toFormat: "HH:mm")
            return string
        default:
            return ""
        }
    }
    
    class func convertIntoJSONString(arrayObject: [AvailableSessionsData]) -> String? {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
    
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    class func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormat
            dateFormatter.calendar = NSCalendar.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: "en")

            let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = toFormat
            if(dt == nil){
                       return ""
                   }
            return dateFormatter.string(from: dt!)
        }else{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: "en")
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        if(dt == nil){
                   return ""
               }
        return dateFormatter.string(from: dt!)
        }
    }
    
//    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
//
//           let dateFormatter = DateFormatter()
//           dateFormatter.dateFormat = fromFormat
//           dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//
//           let dt = dateFormatter.date(from: date)
//           dateFormatter.timeZone = NSTimeZone.local
//           dateFormatter.dateFormat = toFormat
//           dateFormatter.amSymbol = "AM"
//           dateFormatter.pmSymbol = "PM"
//        if(dt == nil){
//            return ""
//        }
//           return dateFormatter.string(from: dt!)
//
//       }
    
    

    
    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
      
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = fromFormat
           dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
           
           let dt = dateFormatter.date(from: date)
           dateFormatter.timeZone = NSTimeZone.local
//        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
//            dateFormatter.locale = Locale(identifier: "ar_DZ")
//        }else{
//            dateFormatter.locale = Locale(identifier: "en")
//        }
        dateFormatter.locale = Locale(identifier: "en")
           dateFormatter.dateFormat = toFormat
           dateFormatter.amSymbol = "AM"
           dateFormatter.pmSymbol = "PM"
        if(dt == nil){
            return ""
        }
           return dateFormatter.string(from: dt!)
     
       }
    class func  dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = HHMMA//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized
        return "\(mydt)"
    }
    
    class func findDateDiffArabic(time1Str: String, time2Str: String,selectedDate: String,checkOneHour: Bool = false,dateFormate: String = "") -> Bool {
         let timeformatter = DateFormatter()
        timeformatter.locale = Locale(identifier: "en")
        if(dateFormate == ""){
        timeformatter.dateFormat = HHMMA
        }else{
            timeformatter.dateFormat = dateFormate
        }
            timeformatter.locale = Locale(identifier: "en")
        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return false }
        
        //You can directly use from here if you have two dates
        
        let interval = time1.timeIntervalSince(time2)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        var dateComparion = String()
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = YYYY_MM_DD
        guard let dateSelected = dateFormatter.date(from: selectedDate) else { return false }
        let dateFormatterGet = DateFormatter()
            dateFormatterGet.locale = Locale(identifier: "en")

        dateFormatterGet.dateFormat = YYYY_MM_DD
    
        
        let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
        guard let currentSelectedDate = dateFormatter.date(from: currentDate) else { return false }
        let result = currentSelectedDate.compare(dateSelected)
        switch result {
        case .orderedAscending     :
            print("date 1 is earlier than date 2")
            return true
            
        case .orderedDescending    :
            print("date 1 is later than date 2")
            return false
        case .orderedSame          :
            print("two dates are the same")
            if(!checkOneHour){
            if(intervalInt >= 1){
                return true
            }
            else{
                return false
            }
            }else{
                if(hour > 1.00 || -1 ... 1 ~= hour){
                    return true
                }
                else{
                    return false
                }
            }
            //            return true
        }
        
         
        
    }
    class func findDateDiff(time1Str: String, time2Str: String,selectedDate: String,checkOneHour: Bool = false,dateFormate: String = "") -> Bool {
         let timeformatter = DateFormatter()
        if(dateFormate == ""){
        timeformatter.dateFormat = HHMMA
        }else{
            timeformatter.dateFormat = dateFormate
        }
            timeformatter.locale = Locale(identifier: "en")

        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return false }
        
        //You can directly use from here if you have two dates
        
        let interval = time1.timeIntervalSince(time2)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        var dateComparion = String()
        let dateFormatter = DateFormatter()
        //if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            dateFormatter.locale = Locale(identifier: "en")

        //}
        dateFormatter.dateFormat = YYYY_MM_DD
        guard let dateSelected = dateFormatter.date(from: selectedDate) else { return false }
        let dateFormatterGet = DateFormatter()
       // if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            dateFormatterGet.locale = Locale(identifier: "en")

      //  }
        dateFormatterGet.dateFormat = YYYY_MM_DD
    
        
        let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
        guard let currentSelectedDate = dateFormatter.date(from: currentDate) else { return false }
        let result = currentSelectedDate.compare(dateSelected)
        switch result {
        case .orderedAscending     :
            print("date 1 is earlier than date 2")
            return true
            
        case .orderedDescending    :
            print("date 1 is later than date 2")
            return false
        case .orderedSame          :
            print("two dates are the same")
            if(!checkOneHour){
            if(intervalInt >= 1){
                return true
            }
            else{
                return false
            }
            }else{
                if(hour > 1.00 || -1 ... 1 ~= hour){
                    return true
                }
                else{
                    return false
                }
            }
            //            return true
        }
        
         
        
    }
    class func getCurrentTime() -> String{
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            let now = Date()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = HHMMA
            let dateString = formatter.string(from: now)
            
            return dateString
        }else{
        let now = Date()
        let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = HHMMA
        let dateString = formatter.string(from: now)
        return dateString
        }
    }
    class func getTimeInterval(fromDate timeImterval: Int) -> String? {
        var timeIntervalString = ""
        var timeDifference: Int = timeImterval / 86400
        timeIntervalString = "\(timeDifference)d"
        print("timeIntervalString \(timeIntervalString)")
        if timeDifference < 1 {
            timeDifference = timeImterval / 3600
            timeIntervalString = "\(timeDifference)h"
            print("timeIntervalString \(timeIntervalString)")
            if timeDifference < 1 {
                timeDifference = timeImterval / 60
                timeIntervalString = "\(timeDifference)m"
                print("timeIntervalString \(timeIntervalString)")
                if timeDifference < 1 {
                    timeIntervalString = "\(timeImterval)s"
                    print("timeIntervalString \(timeIntervalString)")
                }
            }
        }
        print("timeIntervalString \(timeIntervalString)")
        return timeIntervalString
    }
    class func getSameDate(as itemString: String?, havingDateFormatter dateFormatter: DateFormatter?) -> Date? {
        let twentyFour = NSLocale(localeIdentifier: "en_GB")
        dateFormatter?.locale = twentyFour as Locale
        let dateString = getGlobalTimeAsDate(fromDate: itemString, andWithFormat: dateFormatter)
        return dateString
    }
    class func getGlobalTimeAsDate(fromDate date: String?, andWithFormat dateFormatter: DateFormatter?) -> Date? {
        dateFormatter?.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return dateFormatter?.date(from: date ?? "")
    }
    class func videoSnapshot(url: NSString) -> UIImage? {
        
        //let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let vidURL = NSURL(string: url as String)
        let asset = AVURLAsset(url: vidURL! as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    class func getEncodeString(strig: String) -> String {
        let utf8str = strig.data(using: String.Encoding.utf8)
        let base64Encoded = utf8str?.base64EncodedData()
        
        let base64Decoded = NSString(data: base64Encoded!, encoding: String.Encoding.utf8.rawValue)
        
        return base64Decoded! as String
    }
    
    class func getDecodedString(encodedString: String) -> String {
        if(Data(base64Encoded: encodedString) != nil)
        {
            let decodedData = Data(base64Encoded: encodedString)!
            let decodedString = String(data:decodedData, encoding: .utf8)!
            
            return decodedString
        }
        return encodedString
    }
    
    class func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "($1)$2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    class func isValidZipCode(zipCode:String) -> Bool
    {
        //        let zipCodeRegExArray = ["^\\d{5}([\\-]?\\d{4})?$","^(GIR|[A-Z]\\d[A-Z\\d]??|[A-Z]{2}\\d[A-Z\\d]??)[ ]??(\\d[A-Z]{2})$","\\b((?:0[1-46-9]\\d{3})|(?:[1-357-9]\\d{4})|(?:[4][0-24-9]\\d{3})|(?:[6][013-9]\\d{3}))\\b","^([ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJKLMNPRSTVWXYZ])\\{0,1}(\\d[ABCEGHJKLMNPRSTVWXYZ]\\d)$","^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$","^(V-|I-)?[0-9]{5}$","^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$","^[1-9][0-9]{3}\\s?([a-zA-Z]{2})?$","^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$","^([D|d][K|k]( |-))?[1-9]{1}[0-9]{3}$","^(s-|S-){0,1}[0-9]{3}\\s?[0-9]{2}$","^[1-9]{1}[0-9]{3}$","^\\d{6}$","^2899$"]
        let zipCodeRegExArray = ["^GIR[ ]?0AA|((AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}))|BFPO[ ]?\\d{1,4}$","^JE\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^GY\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^IM\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^\\d{5}([ \\-]\\d{4})?$","^[ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ ]?\\d[ABCEGHJ-NPRSTV-Z]\\d$","^\\d{5}$","^\\d{3}-\\d{4}$","^\\d{2}[ ]?\\d{3}$","^\\d{4}$","^\\d{5}$","^\\d{4}$","^\\d{4}[ ]?[A-Z]{2}$","^\\d{3}[ ]?\\d{2}$","^\\d{5}[\\-]?\\d{3}$","^\\d{4}([\\-]\\d{3})?$","^22\\d{3}$","^\\d{3}[\\-]\\d{3}$","^\\d{6}$","^\\d{3}(\\d{2})?$","^\\d{7}$","^\\d{4,5}|\\d{3}-\\d{4}$","^\\d{3}[ ]?\\d{2}$","^([A-Z]\\d{4}[A-Z]|(?:[A-Z]{2})?\\d{6})?$","^\\d{3}$","^\\d{3}[ ]?\\d{2}$","^39\\d{2}$","^(?:\\d{5})?$","^(\\d{4}([ ]?\\d{4})?)?$","^(948[5-9])|(949[0-7])$","^[A-Z]{3}[ ]?\\d{2,4}$","^(\\d{3}[A-Z]{2}\\d{3})?$","^980\\d{2}$","^((\\d{4}-)?\\d{3}-\\d{3}(-\\d{1})?)?$","^(\\d{6})?$","^(PC )?\\d{3}$","^\\d{2}-\\d{3}$","^00[679]\\d{2}([ \\-]\\d{4})?$","^4789\\d$","^\\d{3}[ ]?\\d{2}$","^00120$","^96799$","^6799$","^8\\d{4}$","^6798$","FIQQ 1ZZ","2899","(9694[1-4])([ \\-]\\d{4})?","9[78]3\\d{2}","9[78][01]\\d{2}","SIQQ 1ZZ","969[123]\\d([ \\-]\\d{4})?","969[67]\\d([ \\-]\\d{4})?","9695[012]([ \\-]\\d{4})?","9[78]2\\d{2}","988\\d{2}","008(([0-4]\\d)|(5[01]))([ \\-]\\d{4})?","987\\d{2}","9[78]5\\d{2}","PCRN 1ZZ","96940","9[78]4\\d{2}","(ASCN|STHL) 1ZZ","[HLMS]\\d{3}","TKCA 1ZZ","986\\d{2}","976\\d{2}"]
        var pinPredicate = NSPredicate()
        var result = Bool()
        for index in 0..<zipCodeRegExArray.count
        {
            pinPredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegExArray[index])
            if(pinPredicate.evaluate(with: zipCode) == true)
            {
                result = true
                break
            }
            else
            {
                result = false
            }
        }
        //        result = pinPredicate.evaluate(with: zipCode) as Bool
        return result
        
    }
   
    
//    //added by jainee
    class func getAddressFromLatLon() -> String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        var addressString : String = ""
        let lat: Double = Double("\(currentLatitude)")!
        let lon: Double = Double("\(currentLongitude)")!
        if (lat != 0 && lon != 0){
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        //                    print(pm.country!)
                        //                    print(pm.locality!)
                        //                    print(pm.subLocality!)
                        //                    print(pm.thoroughfare!)
                        //                    print(pm.postalCode!)
                        //                    print(pm.subThoroughfare!)
                        //                    if pm.subLocality != nil {
                        //                        addressString = addressString + pm.subLocality! + ", "
                        //                    }
                        //                    if pm.thoroughfare != nil {
                        //                        addressString = addressString + pm.thoroughfare! + ", "
                        //                    }
                        //                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                        //                    }
                        //                    if pm.country != nil {
                        //                        addressString = addressString + pm.country! + ", "
                        //                    }
                        //                    if pm.postalCode != nil {
                        //                        addressString = addressString + pm.postalCode! + " "
                        //                    }
                        print(addressString)
                        
                    }
            })
        }
        return addressString
    }
//    class func setStatusBarBackgroundColor(color: UIColor) {
//        
//        guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
//        
//        statusBar.backgroundColor = color
//    }
    
    class func isValidPassword(Input:String) -> Bool {
        let RegExpression = "^(?=.*[#$@!%&*?])[A-Za-z[0-9]#$@!%&*?]{9,}+$"
        let result = NSPredicate(format:"SELF MATCHES %@", RegExpression)
        return result.evaluate(with: Input)
    }
    class func removeLocalData() {
        let prefs = UserDefaults.standard
        // keyValue = prefs.string(forKey:USER_DETAILS)
        UserDefaults().set("0", forKey: IS_LOGIN)
        prefs.removeObject(forKey:USER_DETAILS)
//        prefs.removeObject(forKey:RANK_THRESH_HOLD_ARRAY)
//        prefs.removeObject(forKey:CATEGORY_RESTRICTION_ARRAY)
//        prefs.removeObject(forKey:AVOID_AMAZON_SELLER_ARRAY)
//        prefs.removeObject(forKey:IS_AVOID_AMAZON_SELLER)
//        prefs.removeObject(forKey:NET_PROFIT_CALCULATION_DICTIONARY)
//        prefs.removeObject(forKey:VIBRATION_INDICATORS_C)
//        prefs.removeObject(forKey:SOUND_INDICATORS_C)
//        prefs.removeObject(forKey:BUY_BOX_C)
//        prefs.removeObject(forKey:SHAKE_PHONE_C)
//        prefs.removeObject(forKey:CURRENT_PHONE_SHAKE_C)
//        prefs.removeObject(forKey:DEFAULT_BUY_COST_C)
//        prefs.removeObject(forKey:DISAREGARD_AMAZON_SELLER)
//        prefs.removeObject(forKey:RATING_C)
//        prefs.removeObject(forKey:NET_PROFIT_C)
//        prefs.removeObject(forKey:AVOID_BRAND_ARRAY)
//        prefs.removeObject(forKey:AVOID_ASIN_ID_ARRAY)
//        prefs.removeObject(forKey:PRICE_USED_C)
//        prefs.removeObject(forKey:PRICE_USED_FBA_C)
    }
    
    
    
    class func getTimeValue(_ currentValue: Int) -> String? {
        var updatedValue = ""
        if currentValue < 60 {
            if currentValue == 1 {
                updatedValue = "\(currentValue) second"
            } else {
                updatedValue = "\(currentValue) seconds"
            }
        } else if currentValue >= 60 && currentValue < 3600 {
            let minute: Int = currentValue / 60
            if minute == 1 {
                updatedValue = "\(minute) minute"
            } else {
                updatedValue = "\(minute) minutes"
            }
        } else if currentValue >= 3600 && currentValue < 86400 {
            let hour: Int = currentValue / 3600
            if hour == 1 {
                updatedValue = "\(hour) hour"
            } else {
                updatedValue = "\(hour) hours"
            }
        } else if currentValue >= 86400 && currentValue < 604800 {
            let days: Int = currentValue / 86400
            if days == 1 {
                updatedValue = "\(days) day"
            } else {
                updatedValue = "\(days) days"
            }
        } else if currentValue >= 604800 && currentValue < 2592000 {
            let weeks: Int = currentValue / 604800
            if weeks == 1 {
                updatedValue = "\(weeks) week"
            } else {
                updatedValue = "\(weeks) weeks"
            }
        } else {
            let month: Int = currentValue / 2592000
            if month == 1 {
                updatedValue = "\(month) month"
            } else {
                updatedValue = "\(month) months"
            }
        }
        return updatedValue
    }
    
    class func stringDatetoStringDateWithDifferentFormate(dateString: String,fromDateFormatter:String,toDateFormatter: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormatter
        let myDate = dateFormatter.date(from: dateString)!
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = toDateFormatter
        let somedateString = dateFormatter.string(from: myDate)
        return somedateString
    }
    
    class func getCurrentLanguage() -> String{
            let userdef = UserDefaults.standard
            let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
            let current = langArray.firstObject as! String
            return current
        }
      class func setLanguage(langStr:String){
             let defaults = UserDefaults.standard
             defaults.set([langStr], forKey: "AppleLanguages")
             defaults.synchronize()
             Bundle.setLanguage(langStr)
         }
    
    class func setLocalizedValuesforView(parentview: UIView ,isSubViews : Bool)
    {
        if parentview is UILabel {
            let label = parentview as! UILabel
            let titleLabel = label.text
            if titleLabel != nil {
                label.text = self.getLocalizdString(value: titleLabel!)
            }
        }
        else if parentview is UIButton {
            let button = parentview as! UIButton
            let titleLabel = button.title(for:.normal)
            if titleLabel != nil {
                button.setTitle(self.getLocalizdString(value: titleLabel!), for: .normal)
            }
        }
        else if parentview is UITextField {
            let textfield = parentview as! UITextField
            let titleLabel = textfield.text!
            if(titleLabel == "")
            {
                let placeholdetText = textfield.placeholder
                if(placeholdetText != nil)
                {
                    textfield.placeholder = self.getLocalizdString(value:placeholdetText!)
                }
                
                return
            }
            textfield.text = self.getLocalizdString(value:titleLabel)
        }
        else if parentview is UITextView {
            let textview = parentview as! UITextView
            let titleLabel = textview.text!
            textview.text = self.getLocalizdString(value:titleLabel)
        }
        if(isSubViews)
        {
            for view in parentview.subviews {
                self.setLocalizedValuesforView(parentview:view, isSubViews: true)
            }
        }
    }
    class func getLocalizdString(value: String) -> String
       {
           var str = ""
           let language = self.getCurrentLanguage()
           let path = Bundle.main.path(forResource: language, ofType: "lproj")
           if(path != nil)
           {
               let languageBundle = Bundle(path:path!)
               str = NSLocalizedString(value, tableName: nil, bundle: languageBundle!, value: value, comment: "")
           }
           return str
       }
}
var bundleKey: UInt8 = 0
class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIImage
{
//    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
//    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
//    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
//    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
//    var lowestQualityJPEGNSData: NSData
//    {
//        return UIImageJPEGRepresentation(self, 0.0)! as NSData
//    }
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.5)! as NSData}
    var lowestQualityJPEGNSData: NSData
    {
        return self.jpegData(compressionQuality: 0.0)! as NSData
    }
}

extension Optional where Wrapped == String {
    func isEmailValid() -> Bool{
        guard let email = self else { return false }
        let emailPattern = "[A-Za-z-0-9.-_]+@[A-Za-z0-9]+\\.[A-Za-z]{2,3}"
        do{
            let regex = try NSRegularExpression(pattern: emailPattern, options: .caseInsensitive)
            let foundPatters = regex.numberOfMatches(in: email, options: .anchored, range: NSRange(location: 0, length: email.count))
            if foundPatters > 0 {
                return true
            }
        }catch{
            //error
        }
        return false
    }
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
extension URL {
       var attributes: [FileAttributeKey : Any]? {
           do {
               return try FileManager.default.attributesOfItem(atPath: path)
           } catch let error as NSError {
               print("FileAttribute error: \(error)")
           }
           return nil
       }

       var fileSize: Int {
           return attributes?[.size] as? Int ?? Int(0)
       }

       var fileSizeString: String {
           return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
       }

       var creationDate: Date? {
           return attributes?[.creationDate] as? Date
       }
   }
extension Int {
    func asString() -> String {
        return String(format: "%d", self)
    }
    
    func asFloat() -> Float {
        return NSNumber(value: self).floatValue
    }
    
    func asCGFloat() -> CGFloat {
        return CGFloat(asFloat())
    }
}


