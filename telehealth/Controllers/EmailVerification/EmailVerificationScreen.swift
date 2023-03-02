//
//  EmailVerificationScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import ActiveLabel

class EmailVerificationScreen: UIViewController {
    //MARK: UILabel Outlate
    @IBOutlet weak var emailWithMessageLabel: UILabel!
    
    //MARK: UIButton Outlate
    @IBOutlet weak var resendEmailButton: dateSportButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var clickHereLabel: ActiveLabel!
    //MARK: Variable Declration
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func onBack(_ sender: Any) {
        self.backToLoginScreen()
    }
    
    @IBAction func onResendEmail(_ sender: Any) {
        self.onResend()
    }
    
    //MARK: Methods
     func initializedDetails(){
        emailWithMessageLabel.text = "\(Utility.getLocalizdString(value: "WE_JUST_SENT")) \n\(email)"
        
        var customType = ActiveType.custom(pattern: "\\sclick\\b") //Looks for "are"
        var customType2 = ActiveType.custom(pattern: "\\shere\\b") //Looks for "it"

        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE)
        {
            customType = ActiveType.custom(pattern: "\\sتسجيل\\b") //Looks for "are"
            customType2 = ActiveType.custom(pattern: "\\sدخول\\b") //Looks for "it"
        }
        clickHereLabel.enabledTypes.append(customType)
        clickHereLabel.enabledTypes.append(customType2)
       


        clickHereLabel.customize { label in
            label.text = "\(Utility.getLocalizdString(value: "ALREADY_VERIFIED_EMAIL"))"
            label.numberOfLines = 0
            label.lineSpacing = 4
            
            label.textColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
//            label.URLSelectedColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 1)

          

            //Custom types

            label.customColor[customType] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
            label.customSelectedColor[customType] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
            label.customColor[customType2] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
            label.customSelectedColor[customType2] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
            
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
              
                default: ()
                }
                
                return atts
            }

            label.handleCustomTap(for: customType) { _ in
                self.onAlreadyVerified()
            }
            
            label.handleCustomTap(for: customType2) { _ in
                self.onAlreadyVerified()
            }

        }

        clickHereLabel.frame = CGRect(x: 20, y: 40, width: view.frame.width - 40, height: 300)
        view.addSubview(clickHereLabel)
       
    }
    
    
    func backToLoginScreen()  {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginScreen.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func disableButtonStyle(){
        self.resendEmailButton.isUserInteractionEnabled = false
        self.resendEmailButton.backgroundColor = UIColor.clear
        self.resendEmailButton.borderWidth = 1
        self.resendEmailButton.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.resendEmailButton.setTitle(Utility.getLocalizdString(value: "EMAIL_RESENT"), for: .normal)
        self.resendEmailButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    func onAlreadyVerified(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [:] as [String : Any]
            LoginServices.shared.alreadyVerified(parameters: parameters, success: { (statusCode, verifiedEmailModel) in
                Utility.hideIndicator()
                if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                    do{
                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                            if(verifiedEmailModel.data?.isEmailVerified == true){
                                do{
                                    loginDetails.data?.isEmailVerified = true
                                                                           let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                    UserDefaults.standard.set(data, forKey: USER_DETAILS)
                                    UserDefaults.standard.set(loginDetails.data?.role, forKey: "UserType")

                                     self.navigateFurtherScreen(loginModel: loginDetails)
                                }catch{
                                }
                           
                            }else{
                                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: verifiedEmailModel.message!, preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: .default, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                            }
                        }
                    }catch{}
                }
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
//    func registerForPushNotification(){
//        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
//            let parameters = ["token" :UserDefaults.standard.object(forKey: FCM_TOKEN) ?? "",
//                              "type" : "iOS",
//                              DEVICE_ID:DEVICE_UNIQUE_IDETIFICATION,
//                ] as [String : Any]
//            LoginServices.shared.registerForPush(parameters: parameters, success: { (statusCode, commanModel) in
//                Utility.hideIndicator()
//                print(commanModel.message)
//    //            self.navigateFurtherScreen(loginModel: loginModel)
//            }) { (error) in
//                Utility.hideIndicator()
//    //            Utility.showAlert(vc: self, message: error)
//            }
//        }else{
//            Utility.hideIndicator()
//    //        Utility.showNoInternetConnectionAlertDialog(vc: self)
//        }
//    }
//
    func navigateFurtherScreen(loginModel: LoginModel){
        uesrRole = loginModel.data?.role as! Int
        if(loginModel.data?.role == 1){
        if(loginModel.data?.isEmailVerified == false){
            let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
            control.email = String((loginModel.data?.email)!)
            self.navigationController?.pushViewController(control, animated: true)
        }
        else{
            UserDefaults().set("1", forKey: IS_LOGIN)
            do{
                let data = try NSKeyedArchiver.archivedData(withRootObject: loginModel, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: USER_DETAILS)
            }catch{
                print(error)
            }
            if((UserDefaults.standard.object(forKey: PIN_SET)) != nil && (UserDefaults.standard.object(forKey: CONFIRM_PIN_SET)) != nil){
                if(loginModel.data?.flag == 0){
                    let storyBoard = UIStoryboard(name: "Question", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }else{
                    let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }
            }
            else{
                UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                UserDefaults.standard.set(nil, forKey: PIN_SET)
                let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
        }
        }else{
            
            if(loginModel.data?.isEmailVerified == false){
                let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
                control.email = String((loginModel.data?.email)!)
                self.navigationController?.pushViewController(control, animated: true)
            }
            else{
                UserDefaults().set("1", forKey: IS_LOGIN)
                do{
                    let data = try NSKeyedArchiver.archivedData(withRootObject: loginModel, requiringSecureCoding: false)
                    UserDefaults.standard.set(data, forKey: USER_DETAILS)
                }catch{
                    print(error)
                }
                if((UserDefaults.standard.object(forKey: PIN_SET)) != nil && (UserDefaults.standard.object(forKey: CONFIRM_PIN_SET)) != nil){
                        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                        let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                        self.navigationController?.pushViewController(control, animated: true)
                }
                else{
                    UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                    UserDefaults.standard.set(nil, forKey: PIN_SET)
                    let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }
            }
           
        }
    }
    
    func onResend(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [EMAIL : email
                ] as [String : Any]
            LoginServices.shared.sendVerificationEmail(parameters: parameters, success: { (statusCode, forgotPasswordModel) in
                Utility.hideIndicator()
                self.disableButtonStyle()
                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: forgotPasswordModel.message!, preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
