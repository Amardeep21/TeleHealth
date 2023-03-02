//
//  LockScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import AudioToolbox


class PinScreen: UIViewController {
    
    @IBOutlet weak var firstNumberView: UIView!
    @IBOutlet weak var secondNumberView: UIView!
    @IBOutlet weak var thirdNumberView: UIView!
    @IBOutlet weak var fourNumberView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createConfirmPinLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forgotPinButton: UIButton!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    //@IBOutlet weak var backButton: UIButton!
    
    var window: UIWindow?
    var pinNumber = ""
    var newPinNumber = ""
    var confirmNewPinNumber = ""
    var isFromAppdelegate = Bool()
    var isFromChangePasscode = Bool()
    var isPasswordChecked: Bool = false
    var isCheckUpdat:Bool = false
    var currentAppVersion = String()
    var appLink = ""
    var isFromLogOut:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
            stackView1.semanticContentAttribute = .forceLeftToRight
            stackView2.semanticContentAttribute = .forceLeftToRight
            stackView3.semanticContentAttribute = .forceLeftToRight
            stackView4.semanticContentAttribute = .forceLeftToRight
            stackView5.semanticContentAttribute = .forceLeftToRight
       
        appLink = "https://apps.apple.com/in/app/juthoor/id1537395449"
        currentAppVersion = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
        cancelButton.setImage(nil, for: .normal)
        forgotPinButton.isHidden = true
        if(isFromAppdelegate){
            createConfirmPinLabel.text = Utility.getLocalizdString(value: "ENTER_YOUR_PIN")
            forgotPinButton.isHidden = false
        }else if(isFromChangePasscode){
            createConfirmPinLabel.text = Utility.getLocalizdString(value: "ENTER_CURRENT_PIN")
            forgotPinButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
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
    
    @objc func applicationDidBecomeActive() {
        // handle event
        
        if(isFromLogOut == true){
            if(!Utility.isUserAlreadyLogin()){
                let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
            
            if let topVC = UIApplication.topViewController() {
                
                topVC.navigationController?.setViewControllers([control], animated: false)
            }
            }
        }
    }
    @IBAction func onNumbers(_ sender: UIButton) {
        pinNumber = pinNumber + (sender.titleLabel?.text ?? "")
        print(pinNumber)
        setPin()
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        pinNumber = String(pinNumber.dropLast())
        print(pinNumber)
        setPin()
    }
    
    @IBAction func onBack(_ sender: Any) {
        if(isFromChangePasscode){
            isPasswordChecked = false
            newPinNumber = ""
            pinNumber = ""
            backButton.isHidden = true
            createConfirmPinLabel.text = Utility.getLocalizdString(value: "CREATE_A_NEW_PIN")
            setPin()
        }else{
            pinNumber = ""
            backButton.isHidden = true
            createConfirmPinLabel.text = Utility.getLocalizdString(value: "CREATE_A_NEW_PIN")
            UserDefaults.standard.set(nil, forKey: PIN_SET)
            UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
            setPin()
        }
    }
    
    @IBAction func onForgotPin(_ sender: Any) {
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "LOG_OUT"), message: Utility.getLocalizdString(value: "IF_YOU_WANT_TO_LOGOUT"), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: Utility.getLocalizdString(value: "YES"), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.doLogout()
        }
        let cancelAction = UIAlertAction(title: Utility.getLocalizdString(value: "NO"), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:Logout Api Call
    func doLogout() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(LOGOUT_API)\(DEVICE_UNIQUE_IDETIFICATION)"
            ProfileServices.shared.logout(url: url,success: { (statusCode, logoutModel) in
                Utility.hideIndicator()
                SocketHelper.shared.disconnectSocket()
                UserDefaults().set("0", forKey: IS_LOGIN)
                UserDefaults.standard.set(nil, forKey: PIN_SET)
                UserDefaults.standard.set(nil, forKey: USER_DETAILS)
                UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
                self.dismiss(animated: true) { [self] in
                    if(!isAlreadyCheckedVersion){
                        isFromLogOut = true
                        self.getAppVersion()
                    }else{
                    let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
                    
                    if let topVC = UIApplication.topViewController() {
                        
                        topVC.navigationController?.setViewControllers([control], animated: false)
                    }
                    }
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
    
    func setPin(){
        if pinNumber.count == 0{
            setAnimationInCancelButton(alpha: 0, ImageName: "")
            firstNumberView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            secondNumberView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            thirdNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            fourNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if pinNumber.count == 1{
            setAnimationInCancelButton(alpha: 1, ImageName: "Cancel_icon")
            // cancelButton.setImage(#imageLiteral(resourceName: "Cancel_icon"), for: .normal)
            firstNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            secondNumberView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            thirdNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            fourNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if pinNumber.count == 2{
            firstNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            secondNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            thirdNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            fourNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if pinNumber.count == 3{
            firstNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            secondNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            thirdNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            fourNumberView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if pinNumber.count == 4{
            firstNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            secondNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            thirdNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            fourNumberView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            if(isFromAppdelegate){
                if(pinNumber != UserDefaults.standard.object(forKey: PIN_SET) as? String ?? ""){
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                    }
                    self.pinNumber = ""
                    self.setPin()
                    self.firstNumberView.shake()
                    self.secondNumberView.shake()
                    self.thirdNumberView.shake()
                    self.fourNumberView.shake()
                }else{
                    self.dismiss(animated: true) {
                        if(!isAlreadyCheckedVersion){
                        self.getAppVersion()
                        }
                    }
//                    return
                }
            }else if(isFromChangePasscode){
                if(!isPasswordChecked){
                    if(pinNumber != UserDefaults.standard.object(forKey: PIN_SET) as? String ?? ""){
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                        }
                        self.pinNumber = ""
                        self.setPin()
                        self.firstNumberView.shake()
                        self.secondNumberView.shake()
                        self.thirdNumberView.shake()
                        self.fourNumberView.shake()
                    }else{
                        pinNumber = ""
                        isPasswordChecked = true
                        self.setPin()
                        createConfirmPinLabel.text = Utility.getLocalizdString(value: "CREATE_A_NEW_PIN")
                    }
                }else{
                    if(newPinNumber == ""){
                        newPinNumber = pinNumber
                        pinNumber = ""
                        self.setPin()
                        createConfirmPinLabel.text = Utility.getLocalizdString(value: "CONFIRM_NEW_PIN")
                    }else{
                        if(newPinNumber == pinNumber){
                            UserDefaults.standard.set(pinNumber, forKey: CONFIRM_PIN_SET)
                            UserDefaults.standard.set(pinNumber, forKey: PIN_SET)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                            }
                            self.pinNumber = ""
                            self.setPin()
                            self.firstNumberView.shake()
                            self.secondNumberView.shake()
                            self.thirdNumberView.shake()
                            self.fourNumberView.shake()
                        }
                    }
                }
            }
            if((UserDefaults.standard.object(forKey: PIN_SET)) != nil){
                if((UserDefaults.standard.object(forKey: PIN_SET) as! String) == pinNumber){
                    UserDefaults.standard.set(pinNumber, forKey: CONFIRM_PIN_SET)
                    UserDefaults.standard.set(true, forKey: APP_SECURITY)
                    self.navigateToFurherScreen()
                }else{
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                    }
                    self.pinNumber = ""
                    self.setPin()
                    self.firstNumberView.shake()
                    self.secondNumberView.shake()
                    self.thirdNumberView.shake()
                    self.fourNumberView.shake()
                }
            }else{
                UserDefaults.standard.set(pinNumber, forKey: PIN_SET)
                pinNumber = ""
                self.setPin()
                createConfirmPinLabel.text = Utility.getLocalizdString(value: "CONFIRM_NEW_PIN")
                backButton.isHidden = false
            }
        }
    }
    
    func dismissViewControllers() {
        guard let vc = self.presentingViewController else { return }
        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    func setNavigation(){
        if(!isFromLogOut){
        if(!isFromAppdelegatePushNotifcation){
                   if(Utility.isUserAlreadyLogin()){
                       if((UserDefaults.standard.object(forKey: PIN_SET)) != nil && (UserDefaults.standard.object(forKey: CONFIRM_PIN_SET)) != nil){
                           if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                               do{
                                   if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                       UserDefaults.standard.set(loginDetails.data?.role, forKey: "UserType")
                                       if(loginDetails.data?.role == 1){
                                           uesrRole = 1
                                           if(loginDetails.data?.flag == 0){
                                            
                                            let storyBoard = UIStoryboard(name: "Question", bundle: nil)
                                            let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
                                            if let topVC = UIApplication.topViewController() {
                                                topVC.navigationController?.pushViewController(control, animated: true)
                                            }
                                            
                                               
                                             
                                           }else{
                                               let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                                               let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                                            if let topVC = UIApplication.topViewController() {
                                                topVC.navigationController?.pushViewController(control, animated: true)
                                            }
                                            
//                                               self.navigationController?.pushViewController(control, animated: true)
                                           }
                                       }else{
                                           uesrRole = 2
                                           if(loginDetails.data?.userInfo?.isDetailsAdded == 0){
                                               let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                                               let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                                            if let topVC = UIApplication.topViewController() {
                                                topVC.navigationController?.pushViewController(control, animated: true)
                                            }
                                            
//                                               self.navigationController?.pushViewController(control, animated: true)
                                           }else if(loginDetails.data?.userInfo?.isSessionsAdded == 0){
                                               //                                            let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                                               //                                            let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
                                               //                                            self.navigationController?.pushViewController(control, animated: true)
                                               let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
                                               let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
                                            if let topVC = UIApplication.topViewController() {
                                                topVC.navigationController?.pushViewController(control, animated: true)
                                            }
                                            
//                                               self.navigationController?.pushViewController(control, animated: true)
                                           }else{
                                               let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                                               let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                                            if let topVC = UIApplication.topViewController() {
                                                topVC.navigationController?.pushViewController(control, animated: true)
                                            }
                                            
//                                               self.navigationController?.pushViewController(control, animated: true)
                                           }
                                       }
                                   }
                                   else{
                                       let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                                       let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                                    if let topVC = UIApplication.topViewController() {
                                        topVC.navigationController?.pushViewController(control, animated: true)
                                    }
                                    
//                                       self.navigationController?.pushViewController(control, animated: true)
                                   }
                                   
                               }catch{}
                           }
                       }else{
                           
                           if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                               do{
                                   if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                       if(loginDetails.data?.isEmailVerified == false){
                                           let storyBoard1 = UIStoryboard(name: "Login", bundle: nil)
                                           let loginControl = storyBoard1.instantiateViewController(withIdentifier: "LoginScreen") as! LoginScreen
                                           let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
                                           let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
                                           control.email = String((loginDetails.data?.email)!)
                                           if var navstack = navigationController?.viewControllers{
                                               navstack.append(contentsOf: [loginControl,control])
                                               navigationController?.setViewControllers(navstack, animated: false)
                                           }
                                           //                                let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
                                           //                                let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
                                           
                                           //                                self.navigationController?.pushViewController(control, animated: true)
                                       }else{
                                           UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                                           UserDefaults.standard.set(nil, forKey: PIN_SET)
                                           let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                                           let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                                           self.navigationController?.pushViewController(control, animated: true)
                                       }
                                   }
                               }catch{}
                           }
                       }
                   }
                   else{
                       let storyBoard = UIStoryboard(name: "OnBoarding", bundle: nil)
                       let control = storyBoard.instantiateViewController(withIdentifier: "OnBoardingScreen") as! OnBoardingScreen
                       self.navigationController?.pushViewController(control, animated: true)
                   }
                   
               }else{
                   isFromAppdelegatePushNotifcation = false
               }
        
        }else{
            let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
//                        self.navigationController?.pushViewController(control, animated: true)
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.pushViewController(control, animated: true)
            }
        }
    }
    
    func forceAppUpdateVersionAlert(){
        let alert = UIAlertController(title: "Update Required", message: "A new update is required to continue using the app. We have improved the app with better user experience, including fixes required.", preferredStyle: UIAlertController.Style.alert)
           
           
           alert.addAction(UIAlertAction(title: "Update",
                                         style: UIAlertAction.Style.destructive,
                                         handler: { [self](_: UIAlertAction!) in
                                           //Sign out action
                                            isCheckUpdat = true
                                           let myUrl = self.appLink
                                           if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                           }
                                            isAlreadyCheckedVersion = false
                                           // or outside scope use this
                                           guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                                               return
                                           }
                                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }))
//           pvc!.present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
       }
    
    func updateAlertController() {
        let alert = UIAlertController(title: "Update Required", message: "A new update is required to continue using the app. We have improved the app with better user experience, including fixes required.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
//                    self.initializedDetails()
            isAlreadyCheckedVersion = true
            self.setNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: "Update",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.isCheckUpdat = true
                                        let myUrl = self.appLink
                                        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                        isAlreadyCheckedVersion = false
                                        // or outside scope use this
                                        guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                                            return
                                        }
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
//        pvc!.present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK:post giveRating list Api Call
     func getAppVersion() {
         if Utility.isInternetAvailable(){
             Utility.showIndicator()
             if Utility.isInternetAvailable(){
                 Utility.showIndicator()
                 let url = "\(CHECK_UPDATE)"
                 let parameters = [APP_VERSION:currentAppVersion,
                                   TYPE:"iOS"
                     ] as [String : Any]
                print(parameters)
                CheckIUpdateService.shared.checkAppUpdate(parameters: parameters, url: url, success: { (statusCode, commanModel) in
                     Utility.hideIndicator()
                    let flag = commanModel.data?.flag
                    print(flag)
                 
                    if flag == 0{
                        isAlreadyCheckedVersion = true
//                            self.setNavigation()
                    }else if flag == 1{
                        self.forceAppUpdateVersionAlert()
                    }else if flag == 2{
                        self.updateAlertController()
                    }
                }) { (error) in
                    Utility.hideIndicator()
                    Utility.showAlert(vc: self, message: error)
                }
                 
             }
         }else{
             Utility.hideIndicator()
             Utility.showNoInternetConnectionAlertDialog(vc: self)
         }
     }
    
    func navigateToFurherScreen(){
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    UserDefaults.standard.set(loginDetails.data?.role, forKey: "UserType")
                    if(loginDetails.data?.role == 1){
                        uesrRole = 1
                        if(loginDetails.data?.flag == 0){
                            let storyBoard = UIStoryboard(name: "Question", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
                            self.navigationController?.pushViewController(control, animated: true)
                        }else{
                            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                            self.navigationController?.pushViewController(control, animated: true)
                        }
                    }else{
                        uesrRole = 2
                        if(loginDetails.data?.userInfo?.isDetailsAdded == 0){
                            let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                            self.navigationController?.pushViewController(control, animated: true)
                        }else if(loginDetails.data?.userInfo?.isSessionsAdded == 0){
                            
                            //                            let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                            //                            let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
                            //                            self.navigationController?.pushViewController(control, animated: true)
                            let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
                            self.navigationController?.pushViewController(control, animated: true)
                        }else{
                            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                            self.navigationController?.pushViewController(control, animated: true)
                        }
                    }
                }
            }catch{}
        }
    }
    
    func setAnimationInCancelButton(alpha:Int,ImageName:String){
        UIView.animate(withDuration: 0.3, animations: {
            self.cancelButton.alpha = CGFloat(alpha)
        }) { (finished) in
            self.cancelButton.setImage(UIImage(named: ImageName), for: .normal)
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.2
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
