//
//  SignUpScreen.swift
//  telehealth
//
//  Created by iroid on 30/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import GoogleSignIn
import ActiveLabel

class SignUpScreen: UIViewController {
    
    //MARK: UITextField Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    //MARK: UIImageView Outlets
    @IBOutlet weak var passwordVisibleOrNotVisibleImage: UIImageView!
    @IBOutlet weak var userNameView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signupButton: dateSportButton!
    @IBOutlet weak var orContinuteWithLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordVisibleOrUnVisableImageView: UIImageView!
    @IBOutlet weak var agreementLabel: ActiveLabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var alreadyLoginWithLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emargencyLabel: ActiveLabel!
    //MARK: social login variable
    var socialEmailId:String?
    var socialFirstName:String?
    var socialLastName:String?
    var socialUserName:String?
    var socialId:String?
    var socialPic = ""
    var socialType:String?
    var socialGender = ""
    var socialBirthdate = ""
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        signupLabel.alpha = 0.0
        userNameView.alpha = 0.0
        emailView.alpha = 0.0
        passwordView.alpha = 0.0
        signupButton.alpha = 0.0
        orContinuteWithLabel.alpha = 0.0
        signupLabel.alpha = 0.0
        leftLineLabel.alpha = 0.0
        rightLineLabel.alpha = 0.0
        facebookButton.alpha = 0.0
        googleButton.alpha = 0.0
        appleButton.alpha = 0.0
        alreadyLoginWithLabel.alpha = 0.0
        checkBoxView.alpha = 0.0
        loginLabel.alpha = 0.0
        confirmPasswordView.alpha = 0.0
        signupLabel.fadeIn(duration: 0.25, delay: 0.25) { (Bool) in
            self.userNameView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                self.emailView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                    self.passwordView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                        self.confirmPasswordView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                            self.checkBoxView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                self.signupButton.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                    self.orContinuteWithLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                        self.leftLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                            self.rightLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                self.facebookButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                    self.googleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                        self.appleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                            self.alreadyLoginWithLabel.fadeIn(duration: 0.3, delay: 0.1) { (Bool) in
                                                                self.loginLabel.fadeIn(duration: 0.3, delay: 0.1) { (Bool) in
                                                              //      UIApplication.shared.endIgnoringInteractionEvents()
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSignUp(_ sender: UIButton) {
        if userNameTextField.text == ""{
             Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_USERNAME"))
            return
        }else if emailTextField.text == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_YOUR_EMAIL"))
            return
        }else if !emailTextField.text.isEmailValid(){
                 Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_VALID_MAIL"))
         
            return
        }else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_PASSWORD"))
            return
        }else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_CONFIRM_PASSWORD"))
         return
        }else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PASSWORD&CONFIRM_PASSWORD_MUST"))
         return
     }  else if(!agreementButton.isSelected){
          Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ACCCEPT_AGREEMENT"))
            return
        }
        doSignUp()
    }
    @IBAction func onFacebook(_ sender: UIButton) {
         let facebookLoginManager = FacebookLoginManager()
               facebookLoginManager.delegate = self
               facebookLoginManager.handleFacebookLoginButtonTap(viewController: self)
    }
    
    @IBAction func onApple(_ sender: UIButton) {
    }
    
    @IBAction func onGoogle(_ sender: UIButton) {
        let googleManager = GoogleLoginManager()
        googleManager.delegate = self
        googleManager.handleGoogleLoginButtonTap(viewController: self)
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onPasswordVisibleOrUnVisible(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            passwordTextField.isSecureTextEntry = true
            passwordVisibleOrNotVisibleImage.image = UIImage(named: "password_not_visible.png")
            
        }else{
            sender.isSelected = true
            passwordTextField.isSecureTextEntry = false
            passwordVisibleOrNotVisibleImage.image = UIImage(named: "password_visible.png")
        }
    }

    @IBAction func onConfirmPasswordVisableOrUnVisible(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordVisibleOrUnVisableImageView.image = UIImage(named: "password_not_visible.png")
            
        }else{
            sender.isSelected = true
            confirmPasswordTextField.isSecureTextEntry = false
            confirmPasswordVisibleOrUnVisableImageView.image = UIImage(named: "password_visible.png")
        }
    }
    
    @IBAction func onAgreeTermsAndCondition(_ sender: Any) {
        self.agreementButton.isSelected = !agreementButton.isSelected
    }
    
    func doSignUp() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [ROLE:"1",
                              USERNAME:userNameTextField.text!,
                              EMAIL:emailTextField.text!,
                              PASSWORD:passwordTextField.text!,
                              TIMEZONE:localTimeZoneIdentifier
                ] as [String : Any]
            SignUpServices.shared.patientSignUp(parameters: parameters, success: { (statusCode, signUpModel) in
                Utility.hideIndicator()
                UserDefaults().set("1", forKey: IS_LOGIN)
                do{
                    let data = try NSKeyedArchiver.archivedData(withRootObject: signUpModel, requiringSecureCoding: false)
                    UserDefaults.standard.set(data, forKey: USER_DETAILS)
                }catch{
                    print(error)
                }
                self.signUpSuccessAlert(msg: signUpModel.message!)
                
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }
    }
    
    func initalizedDetails(){
        emailTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "EMAIL"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "PASSWORD"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "USERNAME"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "CONFIRM_PASSWORD"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        self.agreementButton.isSelected = false
        self.agreementButton.setImage(UIImage(named: "checkbox_fill.png") , for: .selected)
        self.agreementButton.setImage(UIImage(named: "checkbox.png"), for: .normal)
        
          agreementLabel.text = Utility.getLocalizdString(value: "AGREE_TERMS_POLICY")
//        الاستخدام وسياسة
        var customType = ActiveType.custom(pattern: "\\sTerms & Conditions\\b")
        var customType2 = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
        if(Utility.getCurrentLanguage() == "ar"){
           customType = ActiveType.custom(pattern: "\\sشروط الاستخدام\\b") //Looks for "are"
            customType2 = ActiveType.custom(pattern: "\\sوسياسة الخصوصية\\b") //Looks for "it"
        }else{
            customType = ActiveType.custom(pattern: "\\sTerms & Conditions\\b") //Looks for "are"
            customType2 = ActiveType.custom(pattern: "\\sPrivacy Policy\\b") //Looks for "it"
        }
                


                agreementLabel.enabledTypes.append(customType)
                agreementLabel.enabledTypes.append(customType2)
               


                agreementLabel.customize { label in
                    label.text = Utility.getLocalizdString(value: "AGREE_TERMS_POLICY")
                    label.numberOfLines = 0
                    label.lineSpacing = 4
                    
                    label.textColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
        //            label.URLSelectedColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 1)

                  

                    //Custom types

                    label.customColor[customType] = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                    label.customSelectedColor[customType] = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                    label.customColor[customType2] = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                    label.customSelectedColor[customType2] = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                    
                    label.configureLinkAttribute = { (type, attributes, isSelected) in
                        var atts = attributes
                        switch type {
                        case .custom:
                            atts[NSAttributedString.Key.font] = isSelected ? UIFont(name: "Quicksand-Bold", size: 13) : UIFont(name: "Quicksand-Bold", size: 13)
                        default: ()
                        }
                        
                        return atts
                    }

                    label.handleCustomTap(for: customType) { _ in
                     
                        let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
                                                        let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                        control.titleType = Utility.getLocalizdString(value: "TERMS_AND_CONDITION")
                                              
                        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                            control.url = ARABIC_TERMS_URL_CLIENT
                        }
                        else{
                            control.url = TERMS_URL_CLIENT
                        }
                                                        self.navigationController?.pushViewController(control, animated: true)
                    }
                    
                    label.handleCustomTap(for: customType2) { _ in
                       
                        let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
                                  let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                        control.titleType =  Utility.getLocalizdString(value: "PRIVACY_POLICY")
                        control.url = PRIVACY_URL_CLIENT
                        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                            control.url = ARABIC_PRIVACY_URL_CLIENT
                        }else{
                            control.url = PRIVACY_URL_CLIENT
                        }
                                  self.navigationController?.pushViewController(control, animated: true)
                        
                    }

                }

//                agreementLabel.frame = CGRect(x: 20, y: 40, width: view.frame.width - 40, height: 300)
//                view.addSubview(agreementLabel)
        
        emargencyLabel.text = Utility.getLocalizdString(value: "IF_YOU_ARE_IN_EMERGENCY")
        
              var custom = ActiveType.custom(pattern: "\\scall emergency services\\b") //Looks for "are"
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            custom = ActiveType.custom(pattern: "\\scall emergency services\\b")
        }


        emargencyLabel.enabledTypes.append(custom)
             


        emargencyLabel.customize { label in
                  label.text = Utility.getLocalizdString(value: "IF_YOU_ARE_IN_EMERGENCY")
                  label.numberOfLines = 0
                  label.lineSpacing = 4
                  
                  label.textColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
      //            label.URLSelectedColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 1)

                

                  //Custom types

                  label.customColor[custom] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
                  label.customSelectedColor[custom] = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
                
                  
                  label.configureLinkAttribute = { (type, attributes, isSelected) in
                      var atts = attributes
                      switch type {
                    
                      default: ()
                      }
                      
                      return atts
                  }

                  label.handleCustomTap(for: custom) { _ in
                   
                    if let url = URL(string: "tel://112"), UIApplication.shared.canOpenURL(url) {
                               if #available(iOS 10, *) {
                                   UIApplication.shared.open(url)
                               } else {
                                   UIApplication.shared.openURL(url)
                               }
                           }
                  }
                  


              }
        if(Utility.getCurrentLanguage() == "ar"){
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
            confirmPasswordTextField.textAlignment = .right
            userNameTextField.textAlignment = .right
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
            confirmPasswordTextField.textAlignment = .left
            userNameTextField.textAlignment = .left
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    @IBAction func callEmergency(_ sender: Any) {
        if let url = URL(string: "tel://112"), UIApplication.shared.canOpenURL(url) {
                   if #available(iOS 10, *) {
                       UIApplication.shared.open(url)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
               }
    }
    
    func navigateFurtherScreen(loginModel: LoginModel){
        uesrRole = loginModel.data?.role as! Int
        UserDefaults().set("1", forKey: IS_LOGIN)
                   do{
                       let data = try NSKeyedArchiver.archivedData(withRootObject: loginModel, requiringSecureCoding: false)
                       UserDefaults.standard.set(data, forKey: USER_DETAILS)
                   }catch{
                       print(error)
                   }
        if(loginModel.data?.role == 1){
        if(loginModel.data?.isEmailVerified == false){
            let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
            control.email = String((loginModel.data?.email)!)
            self.navigationController?.pushViewController(control, animated: true)
        }
        else{
           
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
                    if(loginModel.data?.userInfo?.isDetailsAdded == 0){
                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                        self.navigationController?.pushViewController(control, animated: true)
                    }else if(loginModel.data?.userInfo?.isSessionsAdded == 0){
//                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
//                        let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
//                        self.navigationController?.pushViewController(control, animated: true)
                        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
                                                   let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
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
           
        }
    }
    
        //MARK: Social Login Api Call
    func doSocialLogin() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                let parameters = [ROLE:"1",
                                  USERNAME:socialUserName!,
                                  EMAIL:socialEmailId!,
                                  SOCIAL_ID:socialId!,
                                  PROFILE:socialPic,
                                  SOCIAL_PROVIDER:socialType!,
                                   TIMEZONE:localTimeZoneIdentifier
                    ] as [String : Any]
              //  SOCIAL_REGISTER0
                LoginServices.shared.socialRegister(parameters: parameters, success: { (statusCode, logiModel) in
                    Utility.hideIndicator()
                    
                    
                    if logiModel.success!{
                        self.navigateFurtherScreen(loginModel: logiModel)
                    }else{
                        Utility.showAlert(vc: self, message: logiModel.message!)
                    }
                    
//                    UserDefaults().set("1", forKey: IS_LOGIN)
//                    do{
//                        let data = try NSKeyedArchiver.archivedData(withRootObject: logiModel, requiringSecureCoding: false)
//                        UserDefaults.standard.set(data, forKey: USER_DETAILS)
//                    }catch{
//                        print(error)
//                    }
//                    let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
//                    self.navigationController?.pushViewController(control, animated: true)
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
    //MARK: SignUp Success Alert
    func signUpSuccessAlert(msg:String) {
        let alert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: UIAlertAction.Style.default, handler: { _ in
            let storyBoard = UIStoryboard(name: "EmailVerification", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "EmailVerificationScreen") as! EmailVerificationScreen
            control.email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.navigationController?.pushViewController(control, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: FacebookLoginManagerDelegate
extension SignUpScreen:FacebookLoginManagerDelegate{
    func onFacebookLoginSuccess(user: FacebookUserDetail) {
        print(user.socialName!)
        self.socialId = user.socialId!
        self.socialUserName = user.socialName!
        self.socialFirstName = user.firstName!
        self.socialLastName = user.lastName!
        self.socialEmailId = user.socialEmailId!
        self.socialPic = user.socialPic!
        self.socialType = user.socialType!
        doSocialLogin()
    }
    func onFacebookLoginFailure(error: NSError) {
        print(error.description)
    }
}

extension SignUpScreen: googleLoginManagerDelegate{
    func onGoogleLoginSuccess(user: GIDGoogleUser) {
        print(user)
        socialId = user.userID
        self.socialUserName = user.profile.name
        self.socialFirstName = user.profile.givenName
        self.socialLastName = user.profile.familyName
        socialEmailId = user.profile.email
        socialPic = user.profile.imageURL(withDimension: 200)!.absoluteString
        socialType = "google"
        doSocialLogin()
    }
    func onGoogleLoginFailure(error: NSError) {
        print(error.description)
        
    }
}
