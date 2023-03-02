//
//  ViewController.swift
//  telehealth
//
//  Created by iroid on 28/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer = Timer()
    var currentAppVersion = String()
    var appLink = ""
    var isCheckUpdat:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        appLink = "https://apps.apple.com/in/app/juthoor/id1537395449"
        currentAppVersion = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
        getAppVersion()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(initializedDetails), userInfo: nil, repeats: false)
//        NotificationCenter.default.removeObserver(self,
////                                                  name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
//            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // this line need
       
    }
    
    @objc func applicationDidBecomeActive() {
        // handle event
        
        if(isCheckUpdat == true){
        getAppVersion()
        }
    }

    
    // MARK: - Methods
    @objc func initializedDetails(){
        
//        setNavigation()
       
    }
    
    func setNavigation(){
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
                                               //                                            let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                                               //                                            let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
                                               //                                            self.navigationController?.pushViewController(control, animated: true)
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
                                   else{
                                       let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                                       let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                                       self.navigationController?.pushViewController(control, animated: true)
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
    }
    func forceAppUpdateVersionAlert(){
        let alert = UIAlertController(title: Utility.getLocalizdString(value: "UPDATE_REQUIRED"), message: Utility.getLocalizdString(value: "NEW_UPDATE_MSG"), preferredStyle: UIAlertController.Style.alert)
           
           
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "UPDATE"),
                                         style: UIAlertAction.Style.destructive,
                                         handler: { [self](_: UIAlertAction!) in
                                           //Sign out action
                                            isCheckUpdat = true
                                           let myUrl = self.appLink
                                           if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                           }
                                           
                                           // or outside scope use this
                                           guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                                               return
                                           }
                                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }))
           self.present(alert, animated: true, completion: nil)
       }
    func updateAlertController() {
        let alert = UIAlertController(title: Utility.getLocalizdString(value: "UPDATE_REQUIRED"), message: Utility.getLocalizdString(value: "NEW_UPDATE_MSG"), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: UIAlertAction.Style.default, handler: { _ in
//                    self.initializedDetails()
            self.setNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "UPDATE"),
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.isCheckUpdat = true
                                        let myUrl = self.appLink
                                        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                        
                                        // or outside scope use this
                                        guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                                            return
                                        }
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
                            self.setNavigation()
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
}
