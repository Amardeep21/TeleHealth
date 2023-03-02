//
//  PsychologistsSignUpScreen.swift
//  telehealth
//
//  Created by iroid on 07/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import ObjectMapper
import RxCocoa
import RxSwift
import ActiveLabel

class PsychologistsSignUpScreen: UIViewController {
    
    @IBOutlet weak var certificateTextField: UITextField!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryCodeView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var confirmPasswordVisableOrUnVisableImageView: UIImageView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var agreementLabel: ActiveLabel!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var orContinueWithLabel: UILabel!
    @IBOutlet weak var signupButton: dateSportButton!
    @IBOutlet weak var cvView: UIView!
    @IBOutlet weak var licenseNumberView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    //MARK: UITextField Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryNameTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var licenseNumberTextField: UITextField!
    //MARK: UIImageView Outlets
    @IBOutlet weak var passwordVisibleOrNotVisibleImage: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var flagImageWithCodeView: UIImageView!
    //MARK: UIImageView NSLayoutConstraint
    @IBOutlet weak var flagImageWithCodeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var flagImageWithWidth: NSLayoutConstraint!
    //MARK: UITableView Outlets
    @IBOutlet weak var documentTableView: UITableView!
    //MARK: UIView Outlets
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var sucessReviewView: UIView!
    
    @IBOutlet weak var checkBoxView: UIView!
    //MARK: UITableView NSLayoutConstraint
    @IBOutlet weak var documentTableViewHeight: NSLayoutConstraint!
    //MARK: UITextField NSLayoutConstraint
    @IBOutlet weak var passwordTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldTopConstant: NSLayoutConstraint!
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
    var googleUser:GIDGoogleUser?
    var facebookUser: FacebookUserDetail?
    var documentArray = NSMutableArray()
    var documentArrayOfDictionary = NSMutableArray()
    var countryCode = Int()
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
//        UIApplication.shared.beginIgnoringInteractionEvents()
        signupLabel.alpha = 0.0
        firstNameView.alpha = 0.0
        lastNameView.alpha = 0.0
        emailView.alpha = 0.0
        passwordView.alpha = 0.0
        countryView.alpha = 0.0
        countryCodeView.alpha = 0.0
        mobileNumberView.alpha = 0.0
        licenseNumberView.alpha = 0.0
        leftLineLabel.alpha = 0.0
        rightLineLabel.alpha = 0.0
        cvView.alpha = 0.0
        checkBoxView.alpha = 0.0
        signupButton.alpha = 0.0
        orContinueWithLabel.alpha = 0.0
        confirmPasswordView.alpha = 0.0
        signupLabel.alpha = 0.0
        signupLabel.fadeIn(duration: 0.25, delay: 0.25) { (Bool) in
            self.firstNameView.fadeIn(duration: 0.3, delay: 0) { (Bool) in
                self.lastNameView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                    self.emailView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                        self.passwordView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                            self.confirmPasswordView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                self.countryView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                    self.countryCodeView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                        self.mobileNumberView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                            self.licenseNumberView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                self.cvView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                    self.checkBoxView.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                        self.signupButton.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                            self.orContinueWithLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                                self.leftLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                                    self.rightLineLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                                        self.facebookButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                                            self.googleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                                                self.appleButton.fadeIn(duration: 0.0, delay: 0.0) { (Bool) in
                                                                                    self.alreadyAccountLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
                                                                                        self.loginLabel.fadeIn(duration: 0.3, delay: 0.0) { (Bool) in
//                                                                                            UIApplication.shared.endIgnoringInteractionEvents()
                                                                                            
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
                        }
                    }
                }
            }
        }
        if(Utility.getCurrentLanguage() == "ar"){
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
           
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
           
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    func initializedDetails(){
//        if(Utility.getCurrentLanguage() == "ar"){
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
//           
//            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
//        }else{
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//           
//            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
//        }
        self.agreementButton.isSelected = false
        self.agreementButton.setImage(UIImage(named: "checkbox_fill.png") , for: .selected)
        self.agreementButton.setImage(UIImage(named: "checkbox.png"), for: .normal)
        flagImageWithCodeViewWidth.constant = 0
        flagImageWithWidth.constant = 0
        documentTableView.dataSource = self
        documentTableView.delegate = self
        documentTableView.register(UINib(nibName: "OnDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "OnDocumentCell")
        documentTableView.tableFooterView = UIView()
        FacebookAndGoogleDataManage()
        agreementLabel.text = Utility.getLocalizdString(value: "AGREE_TERMS_POLICY")
        let customType = ActiveType.custom(pattern: "\\sterms&condition\\b") //Looks for "are"
        
        let customType2 = ActiveType.custom(pattern: "\\sprivacy policy\\b") //Looks for "it"
        
        
        agreementLabel.enabledTypes.append(customType)
        agreementLabel.enabledTypes.append(customType2)
        
        
        
        agreementLabel.customize { label in
            label.text = Utility.getLocalizdString(value: "AGREE_TERMS_POLICY")
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
             
                let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
                                                let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                                      control.titleType = Utility.getLocalizdString(value: "TERMS&CONDITION")
                if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                    control.url = ARABIC_TERMS_URL_THERPIST
                }
                else{
                    control.url = TERMS_URL_THERPIST
                }
                                     
                                                self.navigationController?.pushViewController(control, animated: true)
            }
            
            label.handleCustomTap(for: customType2) { _ in
               
                let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
                          let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                control.titleType = "Privacy"
                if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                    control.url = ARABIC_PRIVACY_URL
                }else{
                    control.url = PRIVACY_URL
                }
                    
                self.navigationController?.pushViewController(control, animated: true)
                
            }

            
        }
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "EMAIL"),
              attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
              
              passwordTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "PASSWORD"),
              attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "CONFIRM_PASSWORD"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
              
              firstNameTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "FIRST_NAME"),
              attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "FIRST_NAME"),
                     attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "LAST_NAME"),
                     attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        countryCodeTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "CODE"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        countryNameTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "COUNTRY"),
           attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "MOBILE_NUMBER"),
           attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        licenseNumberTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "LICENSE_NUMBER"),
        attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        
        certificateTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "CERTIFICATE"),
             attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
        if(Utility.getCurrentLanguage() == "ar"){
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
            passwordTextField.textAlignment = .right
            confirmPasswordTextField.textAlignment = .right
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            passwordTextField.textAlignment = .left
            confirmPasswordTextField.textAlignment = .left
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
        
    }
    
    func FacebookAndGoogleDataManage(){
        if googleUser != nil{
            firstNameTextField.text = googleUser?.profile.givenName
            lastNameTextField.text = googleUser?.profile.familyName
            emailTextField.text = googleUser?.profile.email
        }else if facebookUser != nil{
            firstNameTextField.text = facebookUser?.firstName!
            lastNameTextField.text = facebookUser?.lastName!
            emailTextField.text = facebookUser?.socialEmailId!
        }
        
        if googleUser != nil || facebookUser != nil{
            passwordTextFieldHeight.constant = 0
            passwordTextFieldTopConstant.constant = 0
            passwordView.isHidden = true
        }else{
            passwordTextFieldHeight.constant = 50
            passwordTextFieldTopConstant.constant = 40
            passwordView.isHidden = false
        }
    }
    
    //MARK: Button Actions
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSignUp(_ sender: UIButton) {
        if(firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_FIRSTNAME"))
            return
        }else if(lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
           Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_LASTNAME"))
            return
        }
        else if(countryNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
    Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_COUNTRY"))
            return
        }
        else if(mobileNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
             Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_MOBILE_NUMBER"))
            return
        }
        else if(licenseNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                  Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_LICENCE_NUMBER"))
            return
        }
        else if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
               Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_YOUR_EMAIL"))
            return
        }else if !emailTextField.text.isEmailValid(){
             Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_VALID_MAIL"))
            return
        }else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            if(googleUser == nil && facebookUser == nil){
                            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_PASSWORD"))
                return
            }
        }else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
        Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_CONFIRM_PASSWORD"))
return
        }
        else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines){
            
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PASSWORD&CONFIRM_PASSWORD_MUST"))
         return
     }
        
        else if(documentArray.count == 0){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_ONE_DOCUMENT_ATLEAST"))
            return
        }
//        else if(!agreementButton.isSelected){
//             Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ACCCEPT_AGREEMENT"))
//            return
//        }
        
        // doSignUp()
        var parameters = [:] as [String : Any]
        if(facebookUser != nil || googleUser != nil){
            if(facebookUser != nil){
                parameters = [ROLE:2,
                              EMAIL:emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              "firstname":firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              "lastname":lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              MOBILE:mobileNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              COUNTRY_NAME:countryCode,
                              PHONE_CODE:countryCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              LICENSE_NUMBER:licenseNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              SOCIAL_ID: facebookUser?.socialId! ?? "",
                              SOCIAL_PROVIDER:facebookUser?.socialType! ?? ""
                    ] as [String : Any]
            }else{
                parameters = [ROLE:2,
                              EMAIL:emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              "firstname":firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              "lastname":lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              MOBILE:mobileNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              COUNTRY_NAME:countryCode,
                              PHONE_CODE:countryCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              LICENSE_NUMBER:licenseNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              SOCIAL_ID: googleUser?.userID ?? "",
                              SOCIAL_PROVIDER:"google"
                    ] as [String : Any]
            }
            
        }else{
            parameters = [ROLE:2,
                          EMAIL:emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          "firstname":firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          "lastname":lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          PASSWORD:passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          MOBILE:mobileNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          COUNTRY_NAME:countryCode,
                          PHONE_CODE:countryCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                          LICENSE_NUMBER:licenseNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                ] as [String : Any]
        }
        Utility.showIndicator()
        for index in 0...documentArray.count-1 {
            let object = NSMutableDictionary()
            let dictionary = documentArray.object(at: index) as! NSDictionary
            object.setValue(dictionary.object(forKey: "title") as! String, forKey: "title")
            object.setValue(dictionary.object(forKey: "uuid") as! String, forKey: "certificate")
            documentArrayOfDictionary.add(object)
        }
        var url = ""
        if (facebookUser != nil || googleUser != nil){
            url = "\(APIManager.shared.baseURL)\(SOCIAL_REGISTER)"
        }else{
            url = "\(APIManager.shared.baseURL)\(REGISTER)"
        }
        self.userRegistration(url: url, documentArray: documentArray, parameter: parameters, complition: { (model) in
            print(model)
        }) { (error) in
            print(error)
        }
    }
    @IBAction func onFacebook(_ sender: UIButton) {
        let facebookLoginManager = FacebookLoginManager()
        facebookLoginManager.delegate = self
        facebookLoginManager.handleFacebookLoginButtonTap(viewController: self)
    }
    @IBAction func onApple(_ sender: UIButton) {
    }
    
    
    @IBAction func onAgreement(_ sender: Any) {
        self.agreementButton.isSelected = !agreementButton.isSelected
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
    
    @IBAction func onConfirmPasswordVisableOrUnVisable(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordVisableOrUnVisableImageView.image = UIImage(named: "password_not_visible.png")
            
        }else{
            sender.isSelected = true
            confirmPasswordTextField.isSecureTextEntry = false
            confirmPasswordVisableOrUnVisableImageView.image = UIImage(named: "password_visible.png")
        }
    }
    
    
    @IBAction func onCountry(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PsychologistsSignUp", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "CountryScreen") as! CountryScreen
        confirmAlertController.delegate = self
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    @IBAction func onCertificate(_ sender: UIButton) {
        if documentArray.count > 9{
            Utility.showAlert(vc: self, message:  Utility.getLocalizdString(value: "YOU_CAN_UPLOAD_UP_TO_10"))
            return
        }
        let storyboard = UIStoryboard(name: "PsychologistsSignUp", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "DocumentUploadScreen") as! DocumentUploadScreen
        confirmAlertController.modalPresentationStyle = .overFullScreen
        confirmAlertController.delegate = self
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    
    @IBAction func onSucessOkay(_ sender: Any) {
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.sucessReviewView.fadeOut() { (Bool) in
            self.signupLabel.fadeOut() { (Bool) in
                self.firstNameView.fadeOut() { (Bool) in
                    self.lastNameView.fadeOut(){ (Bool) in
                        self.emailView.fadeOut() { (Bool) in
                            self.passwordView.fadeOut() { (Bool) in
                                self.confirmPasswordView.fadeOut() { (Bool) in
                                    self.countryView.fadeOut() { (Bool) in
                                        self.countryCodeView.fadeOut() { (Bool) in
                                            self.mobileNumberView.fadeOut() { (Bool) in
                                                self.licenseNumberView.fadeOut() { (Bool) in
                                                    self.cvView.fadeOut() { (Bool) in
                                                        self.checkBoxView.fadeOut() { (Bool) in
                                                            self.documentTableView.fadeOut() { (Bool) in
                                                                self.signupButton.fadeOut() { (Bool) in
                                                                    self.orContinueWithLabel.fadeOut() { (Bool) in
                                                                        self.leftLineLabel.fadeOut() { (Bool) in
                                                                            self.rightLineLabel.fadeOut() { (Bool) in
                                                                                self.facebookButton.fadeOut() { (Bool) in
                                                                                    self.googleButton.fadeOut() { (Bool) in
                                                                                        self.appleButton.fadeOut() { (Bool) in
                                                                                            self.alreadyAccountLabel.fadeOut() { (Bool) in
                                                                                                self.loginLabel.fadeOut() { (Bool) in
//                                                                                                    UIApplication.shared.endIgnoringInteractionEvents()
                                                                                                    
                                                                                                    self.navigationController?.popViewController(animated: false)
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
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func userRegistration(url: String, documentArray: NSMutableArray, parameter: Parameters, complition: @escaping(LoginModel)-> Void, failure: @escaping (String) -> Void) {
        if (Utility.isInternetAvailable()){
            
            let headers = self.getHeader()
            
            AF.upload(multipartFormData: { (multipartFormData) in
                //                   if let data = imageData {
                for index in 0...documentArray.count-1 {
                    let dictionary = documentArray.object(at: index) as! NSDictionary
                    
                    multipartFormData.append(dictionary.object(forKey: "documentImage") as! Data, withName: "certificates[\(dictionary.object(forKey: "uuid") as! String)]", fileName: "image.jpeg", mimeType: (dictionary.object(forKey: "mimeType") as! String))
                }
                
                //                   }
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
                
                struct abc :Codable{
                    var title : String?
                    var certificate :  String?
                }
                var object = [abc]()
                for index in 0...documentArray.count-1 {
                    let dictionary = documentArray.object(at: index) as! NSDictionary
                    
                    let xyz = abc(title: (dictionary.object(forKey: "title") as! String), certificate: (dictionary.object(forKey: "uuid") as! String))
                    object.append(xyz)
                }
                
                let jsonArr = try? JSONEncoder().encode(object)
                multipartFormData.append(jsonArr!, withName: "certificateTitles")
                
            },to: url , usingThreshold: UInt64.init(),
              method: .post,
              headers: headers).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if(200..<300 ~= response.response!.statusCode) || (response.response!.statusCode == 403) {
                        Utility.hideIndicator()
                        
                        let model:LoginModel
                        do{
                            self.documentArrayOfDictionary = NSMutableArray()
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                            model = Mapper<LoginModel>().map(JSON: json!)!
                            //                            Utility.showAlert(vc: self, message: model.message!)
                            self.emailTextField.resignFirstResponder()
                            self.lastNameTextField.resignFirstResponder()
                            self.firstNameTextField.resignFirstResponder()
                            self.licenseNumberTextField.resignFirstResponder()
                            self.passwordTextField.resignFirstResponder()
                            self.countryCodeTextField.resignFirstResponder()
                            self.countryCodeTextField.resignFirstResponder()
                            self.countryNameTextField.resignFirstResponder()
                            self.sucessReviewView.isHidden = false
                        }catch{
                        }
                    } else {
                        self.documentArrayOfDictionary = NSMutableArray()
                        Utility.hideIndicator()
                        let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                        if let errorResponse = json as? [String: Any] {
                            if let message = errorResponse["message"] as? String {
                                Utility.showAlert(vc: self, message: message)
                            }
                        }
                    }
                case.failure:
                    self.documentArrayOfDictionary = NSMutableArray()
                    Utility.hideIndicator()
                    if let err = response.error {
                        Utility.showAlert(vc: self, message: err.errorDescription!)
                    }
                }
                
              })
        } else {
            documentArrayOfDictionary = NSMutableArray()
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
   
    func getHeader() -> HTTPHeaders {
        var headerDic: HTTPHeaders = [:]
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil)
        {
            headerDic = [
                ACCEPT:APLLICATION_JSON,
                 TIMEZONE:localTimeZoneIdentifier,
                "Content-Language":Utility.getCurrentLanguage()
            ]
        }
        else
        {
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginResponse = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        let accessToken = (loginResponse.data?.auth?.accessToken ?? "") as String
                        let authorization = "\(loginResponse.data?.auth?.tokenType! ?? "") \(accessToken)"
                        if (accessToken != "")
                        {
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                 TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }else{
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                 TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }
                    }
                }catch{}
            }
        }
        return headerDic
    }
}

extension PsychologistsSignUpScreen:selectedCountryDelegate {
    func getSelectedCountryData(CountryData: CountryInformation) {
        // CountryData.phoneCode
        flagImageWithCodeViewWidth.constant = 26
        flagImageWithWidth.constant = 26
        Utility.setImage (CountryData.flag, imageView: flagImageView)
        Utility.setImage( CountryData.flag, imageView: flagImageWithCodeView)
        countryNameTextField.text = CountryData.name
        countryCodeTextField.text = "+" + "\(CountryData.phoneCode!)"
        countryCode = CountryData.id!
    }
    
}

extension PsychologistsSignUpScreen:selectedDocumentDelegate {
    func getSelectedDocumentData(DocumentData: NSDictionary) {
        documentArray.add(DocumentData)
        documentTableView.reloadData()
    }
}
extension PsychologistsSignUpScreen: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documentTableViewHeight.constant = CGFloat(40 * documentArray.count)
        return documentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnDocumentCell", for: indexPath) as! OnDocumentTableViewCell
        let documentDictionary = documentArray[indexPath.row] as! NSDictionary
        cell.documentTitleLabel.text = documentDictionary["title"] as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        documentArray.removeObject(at: indexPath.row)
        documentTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
//MARK: FacebookLoginManagerDelegate
extension PsychologistsSignUpScreen:FacebookLoginManagerDelegate{
    func onFacebookLoginSuccess(user: FacebookUserDetail) {
        googleUser = nil
        facebookUser = nil
        print(user.socialName!)
        self.socialId = user.socialId!
        self.socialUserName = user.socialName!
        self.socialFirstName = user.firstName!
        self.socialLastName = user.lastName!
        self.socialEmailId = user.socialEmailId!
        self.socialPic = user.socialPic!
        self.socialType = user.socialType!
        firstNameTextField.text = user.firstName!
        lastNameTextField.text = user.lastName!
        emailTextField.text = user.socialEmailId!
        facebookUser = user
        FacebookAndGoogleDataManage()
        
    }
    func onFacebookLoginFailure(error: NSError) {
        print(error.description)
    }
}
extension PsychologistsSignUpScreen: googleLoginManagerDelegate{
    func onGoogleLoginSuccess(user: GIDGoogleUser) {
        print(user)
        googleUser = nil
        facebookUser = nil
        socialId = user.userID
        self.socialUserName = user.profile.name
        self.socialFirstName = user.profile.givenName
        self.socialLastName = user.profile.familyName
        socialEmailId = user.profile.email
        socialPic = user.profile.imageURL(withDimension: 200)!.absoluteString
        socialType = "google"
        firstNameTextField.text = user.profile.givenName
        lastNameTextField.text = user.profile.familyName
        emailTextField.text = user.profile.email
        googleUser = user
        FacebookAndGoogleDataManage()
        
    }
    func onGoogleLoginFailure(error: NSError) {
        print(error.description)
        
    }
}
