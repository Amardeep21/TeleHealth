//
//  LoginScreen.swift
//  telehealth
//
//  Created by iroid on 30/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleSignIn
import ActiveLabel

class LoginScreen: UIViewController {
    
    //MARK: UITextField Outlets 
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var signupButton: UILabel!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var orContinuteWithLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UILabel!
    @IBOutlet weak var rightPasswordEyeButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var juthoorLabel: UILabel!
    //MARK:  UIImageView Outlets
    @IBOutlet weak var passwordVisibleOrNotVisibleImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emergencyLabel: ActiveLabel!
    //MARK:  UIButton Outlets
    @IBOutlet weak var loginButton: dateSportButton!
    
    @IBOutlet weak var mainView: UIScrollView!
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
    var disposeBag = DisposeBag()
    var role = ""
     var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.initializedDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.shared.beginIgnoringInteractionEvents()

        self.welcomeView.alpha = 0.0
        self.emailView.alpha = 0.0
        self.passwordView.alpha = 0.0
        self.forgotPasswordButton.alpha = 0.0
        self.loginButton.alpha = 0.0
        self.leftLineLabel.alpha = 0.0
        self.rightLineLabel.alpha = 0.0
        self.orContinuteWithLabel.alpha = 0.0
        self.facebookButton.alpha = 0.0
        self.googleButton.alpha = 0.0
        self.appleButton.alpha = 0.0
        self.dontHaveAccountLabel.alpha = 0.0
        self.signupButton.alpha = 0.0
        welcomeView.fadeIn(duration: 0.25, delay: 0.25) { (Bool) in
            self.emailView.fadeIn(duration: 0.3, delay: 0) { (Bool) in
                self.passwordView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                    self.forgotPasswordButton.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                        self.loginButton.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                            self.orContinuteWithLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                self.leftLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                    self.rightLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                        self.facebookButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                            self.googleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                self.appleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                    self.dontHaveAccountLabel.fadeIn(duration: 0.3, delay: 0.1) { (Bool) in
                                                        self.signupButton.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
//                                                            UIApplication.shared.endIgnoringInteractionEvents()
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
        self.resetTextField()
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Button Actions
    @IBAction func onLogin(_ sender: UIButton) {
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_YOUR_EMAIL"))
            return
        }else if !emailTextField.text.isEmailValid(){
              Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_VALID_MAIL"))
            return
        }
        else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
              Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_PASSWORD"))
            return
        }
        self.doLogin()
    }
    
    @IBAction func callEmergencyNumber(_ sender: Any) {
     if let url = URL(string: "tel://112"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
    
    @IBAction func onHideAndShowPassword(_ sender: UIButton) {
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        if(role == "1"){
            let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else{
            let storyBoard = UIStoryboard(name: "PsychologistsSignUp", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsSignUpScreen") as! PsychologistsSignUpScreen
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
    
    @IBAction func onForgotPassword(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordScreen") as! ForgotPasswordScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    func addBoldText(fullString: NSString, boldPartOfString: NSString, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartOfString as String))
        return boldString
    }
    
    // MARK: - Methods
    func initializedDetails(){
        
       
        emailTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "EMAIL"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "PASSWORD"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])

//        rightPasswordEyeButtonConstraint.constant = 0
        if(Utility.getCurrentLanguage() == "ar"){
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
            juthoorLabel.textAlignment = .right
            welcomeLabel.textAlignment = .left
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
            juthoorLabel.textAlignment = .left
            welcomeLabel.textAlignment = .right
        }
        emergencyLabel.text = Utility.getLocalizdString(value: "IF_YOU_ARE_IN_EMERGENCY")
              let custom = ActiveType.custom(pattern: "\\scall emergency services\\b") //Looks for "are"
             
       


        emergencyLabel.enabledTypes.append(custom)
             


        emergencyLabel.customize { label in
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
        
    }
    
    func resetTextField(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: Social Login Api Call
    func doSocialLogin() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                let parameters = [
                                    //ROLE:role,
                                 // USERNAME:socialUserName!,
                                 // EMAIL:socialEmailId!,
                                  SOCIAL_ID:socialId!,
                                  //PROFILE:socialPic,
                                  SOCIAL_PROVIDER:socialType!,
                                  // TIMEZONE:localTimeZoneIdentifier
                    ] as [String : Any]
                
                LoginServices.shared.socialLogin(parameters: parameters, success: { (statusCode, loginModel) in
                    Utility.hideIndicator()
                    UserDefaults.standard.set(loginModel.data?.role, forKey: "UserType")
                    self.navigateFurtherScreen(loginModel: loginModel)
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
    
    
    func navigateFurtherScreen(loginModel: LoginModel){
        //        self.registerForPushNotification()
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
    
    
    //MARK:Login Api Call
    func doLogin() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [EMAIL : emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              PASSWORD : passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                ] as [String : Any]
            LoginServices.shared.login(parameters: parameters, success: { (statusCode, loginModel) in
                Utility.hideIndicator()
                UserDefaults.standard.set(loginModel.data?.role, forKey: "UserType")
                self.navigateFurtherScreen(loginModel: loginModel)
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



//MARK: FacebookLoginManagerDelegate
extension LoginScreen:FacebookLoginManagerDelegate{
    func onFacebookLoginSuccess(user: FacebookUserDetail) {
        print(user.socialName!)
        self.socialId = user.socialId!
        self.socialUserName = user.socialName!
        self.socialFirstName = user.firstName!
        self.socialLastName = user.lastName!
        self.socialEmailId = user.socialEmailId!
        self.socialPic = user.socialPic!
        self.socialType = user.socialType!
//        if role == "1"{
            doSocialLogin()
//        }else{
//            let storyBoard = UIStoryboard(name: "PsychologistsSignUp", bundle: nil)
//            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsSignUpScreen") as! PsychologistsSignUpScreen
//            control.facebookUser = user
//            self.navigationController?.pushViewController(control, animated: true)
//        }
        
    }
    func onFacebookLoginFailure(error: NSError) {
        print(error.description)
    }
}
extension LoginScreen: googleLoginManagerDelegate{
    func onGoogleLoginSuccess(user: GIDGoogleUser) {
        print(user)
        socialId = user.userID
        self.socialUserName = user.profile.name
        self.socialFirstName = user.profile.givenName
        self.socialLastName = user.profile.familyName
        socialEmailId = user.profile.email
        socialPic = user.profile.imageURL(withDimension: 200)!.absoluteString
        socialType = "google"
   //     if role == "1"{
            doSocialLogin()
//        }else{
//            let storyBoard = UIStoryboard(name: "PsychologistsSignUp", bundle: nil)
//            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsSignUpScreen") as! PsychologistsSignUpScreen
//            control.googleUser = user
//            self.navigationController?.pushViewController(control, animated: true)
//        }
    }
    func onGoogleLoginFailure(error: NSError) {
        print(error.description)
        
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 24 }
    var boldFont:UIFont { return UIFont(name: "Quicksand-Bold.otf", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "Quicksand-Regular.otf", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
extension UITextField {
open override func awakeFromNib() {
        super.awakeFromNib()
    if Utility.getCurrentLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
    }else{
        if textAlignment == .natural {
            self.textAlignment = .left
        }
    }
    }
}
extension UITextView {
open override func awakeFromNib() {
        super.awakeFromNib()
    if Utility.getCurrentLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
    }else{
        if textAlignment == .natural {
            self.textAlignment = .left
        }
    }
    }
}
