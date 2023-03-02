//
//  MyProfileDetailScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RxCocoa
import RxSwift


class MyProfileDetailScreen: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: dateSportImageView!
    
    @IBOutlet weak var userNameViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numberViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var mobileNumberDetailsView: dateSportView!
    @IBOutlet weak var userNameDetailsView: UIView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    
    //MARK:Object Declration with initilization
    var itemsObservale : Observable<[SettingOptionModel]>!
    
    let disposeBag = DisposeBag()
    var settingArray = [SettingOptionModel]()
    
    var imageData: Data? = nil
    var oldUserName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializedDetails()
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
          uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if(uesrRole == 1){
            if(imageData == nil && oldUserName == userNameTextField.text){
                self.navigationController?.popViewController(animated: true)
                return
            }
            Utility.showIndicator()
            let parameters = ["username" : userNameTextField.text!,
                ] as [String : Any]
            self.userRegistration(url: "\(APIManager.shared.baseURL)\(USER_API)", imageData: imageData, parameter: parameters, complition: { (model) in
                print(model)

            }) { (error) in
                print(error)
            }
        }else{
            var parameters = [:] as [String : Any]
          if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
              do{
                 
                  if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                      emailTextField.text = loginDetails.data?.email
                    var firstName = ""
                    var lastName = ""
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        firstName = loginDetails.data?.firstname ?? ""
                        lastName = loginDetails.data?.lastname ?? ""
                    }else{
                        firstName = loginDetails.data?.firstnameAr ?? ""
                        lastName = loginDetails.data?.lastnameAr ?? ""
                    }
                    parameters = [ROLE:2,
                                  EMAIL:loginDetails.data?.email ?? "",
                                  "firstname":firstName,
                                  "lastname":lastName,
                                  MOBILE:loginDetails.data?.userInfo?.mobile! ?? "",
                                  COUNTRY_NAME:loginDetails.data?.userInfo?.country?.id ?? "",
                                  PHONE_CODE:countryCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  LICENSE_NUMBER:loginDetails.data?.userInfo?.licenseNumber! ?? "",
                        ] as [String : Any]
                  }
              }catch{}
          }
           
            if(imageData == nil){
                           self.navigationController?.popViewController(animated: true)
                           return
                       }
            Utility.showIndicator()
                       
                       self.userRegistration(url: "\(APIManager.shared.baseURL)\(USER_API)", imageData: imageData, parameter: parameters, complition: { (model) in
                           print(model)
                       }) { (error) in
                           print(error)
                       }
//            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onDeleteAccount(_ sender: Any) {
        self.onDelete()
    }
    
    
    @IBAction func onCancelDeletedView(_ sender: Any) {
        deleteView.isHidden = true
    }
    
    @IBAction func onProfilePicture(_ sender: Any) {
        self.showAlert()
    }
    
    
    func onDelete() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            ProfileServices.shared.deleteAccount(success: { (statusCode, logoutModel) in
                Utility.hideIndicator()
                UserDefaults().set("0", forKey: IS_LOGIN)
                UserDefaults.standard.set(nil, forKey: PIN_SET)
                UserDefaults.standard.set(nil, forKey: USER_DETAILS)
                UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: logoutModel.message!, preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "OK"), style: .default, handler: { (action: UIAlertAction!) in
                    let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
                    self.navigationController?.pushViewController(control, animated: true)
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
    //Show alert to selected the media source type.
    private func showAlert() {
        
        let alert = UIAlertController(title: Utility.getLocalizdString(value: "IMAGE_SELECTION"), message: Utility.getLocalizdString(value: "WHERE_YOU_WANT_PIC"), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CAMERA"), style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "PHOTO_ALBUM"), style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.profileImageView.image = image
            self!.imageData = image.jpegData(compressionQuality:0.4)!
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func initializedDetails(){
        optionTableView.isExclusiveTouch = true
        optionTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsCell")
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    if ((loginDetails.data?.socialProvider ?? 0) == 1 || (loginDetails.data?.socialProvider ?? 0) == 2){
                        if(loginDetails.data?.role == 1){
                            settingArray = [
                                SettingOptionModel(imageName: "delete_icon", title: Utility.getLocalizdString(value: "DELETE_MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 2),
                            ]
                            
                        }else{
                            settingArray  = [
                                 SettingOptionModel(imageName: "map_blue_icon", title: Utility.getLocalizdString(value: "Change Country"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 2),
                                SettingOptionModel(imageName: "certificate_icon", title: Utility.getLocalizdString(value: "CERTIFICATE"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                                SettingOptionModel(imageName: "delete_icon", title: Utility.getLocalizdString(value: "DELETE_MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            ]
                            
                        }
                    }else{
                        if(loginDetails.data?.role == 1){
                            settingArray = [
                                SettingOptionModel(imageName: "lock_icon", title: Utility.getLocalizdString(value: "CHANGE_PASSWORD"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 1),
                                SettingOptionModel(imageName: "delete_icon", title: Utility.getLocalizdString(value: "DELETE_MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 2),
                                
                            ]
                            
                        }else{
                            settingArray  = [
                                SettingOptionModel(imageName: "lock_icon", title: Utility.getLocalizdString(value: "CHANGE_PASSWORD"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 1),
                                SettingOptionModel(imageName: "map_blue_icon", title: Utility.getLocalizdString(value: "CHANGE_COUNTRY"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 2),
                                SettingOptionModel(imageName: "certificate_icon", title: Utility.getLocalizdString(value: "CERTIFICATE"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                                SettingOptionModel(imageName: "delete_icon", title: Utility.getLocalizdString(value: "DELETE_MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            ]
                            
                        }
                    }
                    
                    itemsObservale = Observable.just(settingArray)
                    self.loadTable()
                    
                }
            }catch{}
        }
        self.updateUserInformation()
    }
    
    func loadTable(){
        optionTableView.dataSource = nil
        itemsObservale.bind(to: optionTableView.rx.items(cellIdentifier: "OptionsCell", cellType:SettingTableViewCell.self)){(row,item,cell) in
            cell.menuIconImageView.image = UIImage(named: item.imageName ?? "")
            cell.titleLabel.text = item.title
            cell.bottomLineLabel.isHidden = true
            cell.firstLineLabel.isHidden = true
            if(item.isFirstLineShow!){
                cell.firstLineLabel.isHidden = false
            }else{
                cell.firstLineLabel.isHidden = true
            }
            if(item.isShowMessageCount!){
                cell.circleView.isHidden = false
            }else{
                cell.circleView.isHidden = true
            }
            if(item.isShowLaguage!){
                cell.languageLabel.isHidden = false
            }else{
                cell.languageLabel.isHidden = true
            }
            if(Utility.getCurrentLanguage() == "ar"){
               
                cell.nextArrowImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
            }else{
                cell.nextArrowImageView.image = #imageLiteral(resourceName: "back_icon_right")
            }
            cell.cellSelectButton.rx.tap.first()
                .subscribe({ _ in
                    
                })
                .disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        
        optionTableView.rx.modelSelected(SettingOptionModel.self)
        .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
            .subscribe(onNext: {
            item in
                  uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                if(item.index == 1){
                    let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordScreen") as! ChangePasswordScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }else if(item.index == 2){
                    self.deleteView.isHidden = false
                }
            }else{
                if(item.index == 1){
                    let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordScreen") as! ChangePasswordScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }else if(item.index == 3){
                    let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "CertificateListScreen") as! CertificateListScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }else if(item.index == 4){
                    Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_EMAIL_US_TO_DELETE_ACCOUNT"))
//                    self.deleteView.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
              
       
    }
    
    func updateUserInformation(){
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    emailTextField.text = loginDetails.data?.email
                    if(loginDetails.data?.role == 1){
                        userNameTextField.text = loginDetails.data?.username
                        oldUserName = (loginDetails.data?.username)!
                        if(loginDetails.data?.profile != ""){
                            Utility.setImage(loginDetails.data?.profile, imageView: profileImageView)
                            userNameViewHeightConstraint.constant = 65
                            numberViewHeightConstraint.constant = 0
                            emailTopConstraint.constant = 16
                        }
                    }else{
                        Utility.setImage(loginDetails.data?.userInfo?.country?.flag, imageView: flagImageView)
                        countryCodeTextField.text = "+\(loginDetails.data?.userInfo?.country?.phonecode ?? "")"
                        phoneNumberLabel.text = loginDetails.data?.userInfo?.mobile
                        Utility.setImage(loginDetails.data?.profile, imageView: profileImageView)
                        userNameViewHeightConstraint.constant = 0
                        numberViewHeightConstraint.constant = 65
                        emailTopConstraint.constant = 0
                    }
                }
            }catch{}
        }
    }
    
    func userRegistration(url: String, imageData: Data?, parameter: Parameters, complition: @escaping(LoginModel)-> Void, failure: @escaping (String) -> Void) {
        if (Utility.isInternetAvailable()){
            
            let headers = self.getHeader()
            
            AF.upload(multipartFormData: { (multipartFormData) in
                if let data = imageData {
                    multipartFormData.append(data, withName: "profile", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
            },to: url , usingThreshold: UInt64.init(),
              method: .post,
              headers: headers).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if(200..<300 ~= response.response!.statusCode) {
                        Utility.hideIndicator()
                        let model:LoginModel
                        do{
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                            model = Mapper<LoginModel>().map(JSON: json!)!
                            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                                do{
                                    if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                        let authantication = loginDetails.data?.auth!
                                        loginDetails.data = model.data
                                        loginDetails.data?.auth = authantication
                                        do{
                                            let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                            UserDefaults.standard.set(data, forKey: USER_DETAILS)
                                            self.updateUserInformation()
                                            self.navigationController?.popViewController(animated: true)
                                        }catch{
                                            print(error)
                                        }
                                    }
                                }catch{}
                            }
                        }catch{
                        }
                    } else {
                        Utility.hideIndicator()
                        let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                        if let errorResponse = json as? [String: Any] {
                            if let message = errorResponse["message"] as? String {
                                Utility.showAlert(vc: self, message: message)
                            }
                        }
                    }
                case.failure:
                    Utility.hideIndicator()
                    if let err = response.error {
                        Utility.showAlert(vc: self, message: err.errorDescription!)
                    }
                }
                
              })
        } else {
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

