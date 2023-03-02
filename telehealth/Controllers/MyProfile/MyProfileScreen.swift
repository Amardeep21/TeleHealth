//
//  MyProfileScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
//import RxCocoa
//import RxSwift

class MyProfileScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var settingOptionsTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var countView: dateSportView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableviewMainView: UIView!
    
    //MARK:Object Declration with initilization
//    var itemsObservale : Observable<[SettingOptionModel]>!
    
//    let disposeBag = DisposeBag()
    var settingArray = [SettingOptionModel]()
    var countModel : CountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *){
                       tableviewMainView.clipsToBounds = false
                       tableviewMainView.layer.cornerRadius = 24
                       tableviewMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
               } else {
                     //For lower versions
                   let rectShape = CAShapeLayer()
                   rectShape.bounds = tableviewMainView.frame
                   rectShape.position = tableviewMainView.center
                   rectShape.path = UIBezierPath(roundedRect: tableviewMainView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 24, height: 24)).cgPath
                   tableviewMainView.layer.mask = rectShape
               }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializedDetails()
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    @IBAction func onLogout(_ sender: Any) {
        let alertController = UIAlertController(title: Utility.getLocalizdString(value: "LOGOUT"), message: Utility.getLocalizdString(value: "ARE_YOU_SURE_MSG"), preferredStyle: .alert)
        
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
    
    // MARK: - Methods
    func initializedDetails(){
        settingOptionsTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsCell")
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                    if(uesrRole == 1){
                        userNameLabel.text = loginDetails.data?.username
                    }else{
                        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        userNameLabel.text = "\(loginDetails.data?.firstname ?? "") \(loginDetails.data?.lastname ?? "")"
                        }else{
                            userNameLabel.text = "\(loginDetails.data?.firstnameAr ?? "") \(loginDetails.data?.lastnameAr ?? "")"
                        }
                    }
                    if(loginDetails.data?.profile != ""){
                        Utility.setImage(loginDetails.data?.profile, imageView: profileImageView)
                    }
                    if(loginDetails.data?.role == 1){
                        settingArray = [
                            SettingOptionModel(imageName: "profile_icon", title: Utility.getLocalizdString(value: "MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: true,index: 1),
                            SettingOptionModel(imageName: "language_icon", title: Utility.getLocalizdString(value: "LANGUAGE"), isShowMessageCount: false, isShowLaguage: true,isFirstLineShow: false,index: 2),
                            SettingOptionModel(imageName: "security_icon", title:Utility.getLocalizdString(value: "APP_SECURITY"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                            SettingOptionModel(imageName: "chat_icon", title: Utility.getLocalizdString(value: "CHATS"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            SettingOptionModel(imageName: "notification_icon_icon", title: Utility.getLocalizdString(value: "MANAGE_NOTIFICATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 7),
                            SettingOptionModel(imageName: "logout_icon", title: Utility.getLocalizdString(value: "LOG_OUT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 8),
                            SettingOptionModel(imageName: "about_icon", title: Utility.getLocalizdString(value: "ABOUT_JUTHOOR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 9)
                        ]
                    }else{
                        settingArray  = [
                            SettingOptionModel(imageName: "profile_icon", title: Utility.getLocalizdString(value: "MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: true,index: 1),
                            SettingOptionModel(imageName: "Request", title: Utility.getLocalizdString(value: "REQUEST"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: true,index: 10),
                            SettingOptionModel(imageName: "language_icon", title: Utility.getLocalizdString(value: "LANGUAGE"), isShowMessageCount: false, isShowLaguage: true,isFirstLineShow: false,index: 2),
                            SettingOptionModel(imageName: "security_icon", title: Utility.getLocalizdString(value: "APP_SECURITY"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                            SettingOptionModel(imageName: "chat_icon", title: Utility.getLocalizdString(value: "CHATS"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            SettingOptionModel(imageName: "update_info", title: Utility.getLocalizdString(value: "UPDATE_INFORMATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 5),
                            //SettingOptionModel(imageName: "calender_icon", title: "Update Weekly Session Schedule", isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 6),
                            SettingOptionModel(imageName: "notification_icon_icon", title: Utility.getLocalizdString(value: "MANAGE_NOTIFICATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 6),
                            SettingOptionModel(imageName: "calender_icon", title: Utility.getLocalizdString(value: "UPDATE_AVAIBLITY_TO_CALENDAR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 7),
                            SettingOptionModel(imageName: "logout_icon", title: Utility.getLocalizdString(value: "LOG_OUT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 8),
                             SettingOptionModel(imageName: "about_icon", title: Utility.getLocalizdString(value: "ABOUT_JUTHOOR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 9)
                        ]
                    }
                }
            }catch{}
        }
//        loadTable()
        settingOptionsTableView.reloadData()
        settingOptionsTableView.tableFooterView = UIView()
        self.getCount()
    }
    
//    func loadTable(){
//        settingOptionsTableView.dataSource = nil
//        itemsObservale.bind(to: settingOptionsTableView.rx.items(cellIdentifier: "OptionsCell", cellType:SettingTableViewCell.self)){(row,item,cell) in
//
//        }.disposed(by: disposeBag)
//
//
//    }

    func setData(){
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                    if(uesrRole == 1){
                        userNameLabel.text = loginDetails.data?.username
                    }else{
                        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        userNameLabel.text = "\(loginDetails.data?.firstname ?? "") \(loginDetails.data?.lastname ?? "")"
                        }else{
                            userNameLabel.text = "\(loginDetails.data?.firstnameAr ?? "") \(loginDetails.data?.lastnameAr ?? "")"
                        }
                    }
                    if(loginDetails.data?.profile != ""){
                        Utility.setImage(loginDetails.data?.profile, imageView: profileImageView)
                    }
                    if(loginDetails.data?.role == 1){
                        settingArray = [
                            SettingOptionModel(imageName: "profile_icon", title: Utility.getLocalizdString(value: "MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: true,index: 1),
                            SettingOptionModel(imageName: "language_icon", title: Utility.getLocalizdString(value: "LANGUAGE"), isShowMessageCount: false, isShowLaguage: true,isFirstLineShow: false,index: 2),
                            SettingOptionModel(imageName: "security_icon", title:Utility.getLocalizdString(value: "APP_SECURITY"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                            SettingOptionModel(imageName: "chat_icon", title: Utility.getLocalizdString(value: "CHATS"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            SettingOptionModel(imageName: "notification_icon_icon", title: Utility.getLocalizdString(value: "MANAGE_NOTIFICATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 7),
                            SettingOptionModel(imageName: "logout_icon", title: Utility.getLocalizdString(value: "LOG_OUT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 8),
                            SettingOptionModel(imageName: "about_icon", title: Utility.getLocalizdString(value: "ABOUT_JUTHOOR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 9)
                        ]
                    }else{
                        settingArray  = [
                            SettingOptionModel(imageName: "profile_icon", title: Utility.getLocalizdString(value: "MY_ACCOUNT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: true,index: 1),
                            SettingOptionModel(imageName: "Request", title: Utility.getLocalizdString(value: "REQUEST"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: true,index: 10),
                            SettingOptionModel(imageName: "language_icon", title: Utility.getLocalizdString(value: "LANGUAGE"), isShowMessageCount: false, isShowLaguage: true,isFirstLineShow: false,index: 2),
                            SettingOptionModel(imageName: "security_icon", title: Utility.getLocalizdString(value: "APP_SECURITY"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 3),
                            SettingOptionModel(imageName: "chat_icon", title: Utility.getLocalizdString(value: "CHATS"), isShowMessageCount: true, isShowLaguage: false,isFirstLineShow: false,index: 4),
                            SettingOptionModel(imageName: "update_info", title: Utility.getLocalizdString(value: "UPDATE_INFORMATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 5),
                            //SettingOptionModel(imageName: "calender_icon", title: "Update Weekly Session Schedule", isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 6),
                            SettingOptionModel(imageName: "notification_icon_icon", title: Utility.getLocalizdString(value: "MANAGE_NOTIFICATIONS"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 6),
                            SettingOptionModel(imageName: "calender_icon", title: Utility.getLocalizdString(value: "UPDATE_AVAIBLITY_TO_CALENDAR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 7),
                            SettingOptionModel(imageName: "logout_icon", title: Utility.getLocalizdString(value: "LOG_OUT"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 8),
                             SettingOptionModel(imageName: "about_icon", title: Utility.getLocalizdString(value: "ABOUT_JUTHOOR"), isShowMessageCount: false, isShowLaguage: false,isFirstLineShow: false,index: 9)
                        ]
                    }
                }
            }catch{}
        }
//        loadTable()
        settingOptionsTableView.reloadData()
        settingOptionsTableView.tableFooterView = UIView()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingArray[indexPath.row]
        let cell = self.settingOptionsTableView.dequeueReusableCell(withIdentifier: "OptionsCell", for:indexPath) as! SettingTableViewCell
        cell.menuIconImageView.image = UIImage(named: item.imageName ?? "")
        cell.titleLabel.text = item.title
        
        if(item.isFirstLineShow!){
            cell.firstLineLabel.isHidden = false
        }else{
            cell.firstLineLabel.isHidden = true
        }
        
        if(item.isShowMessageCount!){
            cell.circleView.isHidden = false
            if(self.countModel?.chat_count == 0){
                cell.circleView.isHidden = true
            }else{
                cell.messageCountLabel.text = "\(self.countModel?.chat_count ?? 0)"
            }

        }else{
            cell.circleView.isHidden = true
        }
        
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if(uesrRole == 2){
            if(item.index == 10){
                if(self.countModel?.requestCount == 0){
                    cell.circleView.isHidden = true
                }else{
                    cell.circleView.isHidden = false
                    cell.messageCountLabel.text = "\(self.countModel?.requestCount ?? 0)"
                }
            }
        }
        
        if(item.isShowLaguage!){
            cell.languageLabel.isHidden = false
            
        }else{
            cell.languageLabel.isHidden = true
        }
        if(Utility.getCurrentLanguage() == "ar"){
            cell.languageLabel.text = "Arabic"
            cell.nextArrowImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
        }else{
            cell.languageLabel.text = "English"
            cell.nextArrowImageView.image = #imageLiteral(resourceName: "back_icon_right")
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingArray[indexPath.row]
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if(uesrRole == 1){
            if(item.index == 1){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "MyProfileDetailScreen") as! MyProfileDetailScreen
                self.navigationController?.pushViewController(control, animated: true)
            }else if(item.index == 2){
                let storyboard = UIStoryboard(name: "MyProfile", bundle: nil)
                let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "LanguagePopUpScreen") as! LanguagePopUpScreen
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self.present(confirmAlertController, animated: true, completion: nil)
                
            }else if(item.index == 3){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "AppSecurityScreen") as! AppSecurityScreen
                self.navigationController?.pushViewController(control, animated: true)
            }else if(item.index == 4){
                let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "ChatListScreen") as! ChatListScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
            else if(item.index == 7){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "ManageNotificationScreen") as! ManageNotificationScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
            else if(item.index == 8){
                let alertController = UIAlertController(title: Utility.getLocalizdString(value: "LOGOUT"), message: Utility.getLocalizdString(value: "ARE_YOU_SURE_MSG"), preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title:Utility.getLocalizdString(value: "YES"), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.doLogout()
                }
                let cancelAction = UIAlertAction(title:Utility.getLocalizdString(value: "NO"), style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                //self.doLogout()
            }else if(item.index == 9){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "AboutUsScreen") as! AboutUsScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
        }else{
            if(item.index == 1){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "MyProfileDetailScreen") as! MyProfileDetailScreen
                self.navigationController?.pushViewController(control, animated: true)
            }else if(item.index == 10){
                let storyBoard = UIStoryboard(name: "Request", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "RequestScreen") as! RequestScreen
                self.navigationController?.pushViewController(control, animated: true)
            }else if(item.index == 2){
                let storyboard = UIStoryboard(name: "MyProfile", bundle: nil)
                let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "LanguagePopUpScreen") as! LanguagePopUpScreen
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self.present(confirmAlertController, animated: true, completion: {
                })
            }else if(item.index == 3){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "AppSecurityScreen") as! AppSecurityScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
            else if(item.index == 4){
                let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "ChatListScreen") as! ChatListScreen
                self.navigationController?.pushViewController(control, animated: true)
            }else if(item.index == 5){
                let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                control.isFromSetting = true
                self.navigationController?.pushViewController(control, animated: true)
            }
//                    else if(item.index == 6){
//                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
//                        let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
//                        control.isFromAvailableSession = true
//                        self.navigationController?.pushViewController(control, animated: true)
//                    }
                else if(item.index == 6){
                    let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "ManageNotificationScreen") as! ManageNotificationScreen
                    self.navigationController?.pushViewController(control, animated: true)
                }
            else if(item.index == 7){
                let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
            else if(item.index == 8){
                //self.doLogout()
                let alertController = UIAlertController(title: Utility.getLocalizdString(value: "LOGOUT"), message: Utility.getLocalizdString(value: "ARE_YOU_SURE_MSG"), preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title:Utility.getLocalizdString(value: "YES"), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.doLogout()
                }
                let cancelAction = UIAlertAction(title:Utility.getLocalizdString(value: "NO"), style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }else if(item.index == 9){
                let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "AboutUsScreen") as! AboutUsScreen
                self.navigationController?.pushViewController(control, animated: true)
            }
        }
    }
  
//    func didSelect(){
//        settingOptionsTableView.rx.modelSelected(SettingOptionModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//
//            }).disposed(by: disposeBag)
//    }
    @IBAction func onNotification(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Notification", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "NotificationListScreen") as! NotificationListScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
 
    @IBAction func onProfile(_ sender: Any) {
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    
                    let storyboard = UIStoryboard(name: "Blog", bundle: nil)
                    let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                    confirmAlertController.imageUrl = loginDetails.data?.profile ?? ""
                    confirmAlertController.modalPresentationStyle = .overFullScreen
                    self.present(confirmAlertController, animated: true, completion: nil)
                }
            }catch{}
        }
    }
    
    func getCount() {
        if Utility.isInternetAvailable(){
            //               Utility.showIndicator()
            
            ProfileServices.shared.getCount(success: { [self] (statusCode, countModel) in
                Utility.hideIndicator()
                if(countModel.data?.unreadNotification == 0){
                    self.countView.isHidden = true
                }else{
                    self.countView.isHidden = false
                    self.countLabel.text = "\(countModel.data?.unreadNotification ?? 0)"
                }
                self.countModel = countModel.data
                UserDefaults.standard.set(countModel.data?.sessionReminder, forKey: "upcommingSession")
                UserDefaults.standard.set(countModel.data?.chatReminder, forKey: "messageSwitch")
                UserDefaults.standard.set(countModel.data?.blogReminder, forKey: "blogSwitch")
//                self.loadTable()

                if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                    do{
                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                            UserDefaults.standard.set(countModel.data?.user?.role, forKey: "UserType")
                            if let loginDetailsNew = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {

                            loginDetails.data = countModel.data?.user
                                loginDetails.data?.auth = loginDetailsNew.data?.auth
                            }
                            do{
                                let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                UserDefaults.standard.set(data, forKey: USER_DETAILS)
                                setData()
                            }catch{
                                print(error)
                            }
                        }
                    }catch{}
                }
                self.settingOptionsTableView.reloadData()
            }) { (error) in
                //                   Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            //               Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:Logout Api Call
    func doLogout() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(LOGOUT_API)\(DEVICE_UNIQUE_IDETIFICATION)"
            ProfileServices.shared.logout(url: url,success: { (statusCode, logoutModel) in
                Utility.hideIndicator()
                UserDefaults().set("0", forKey: IS_LOGIN)
                UserDefaults.standard.set(nil, forKey: PIN_SET)
                UserDefaults.standard.set(nil, forKey: USER_DETAILS)
                UserDefaults.standard.set(nil, forKey: CONFIRM_PIN_SET)
                SocketHelper.shared.disconnectSocket()
                let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
                self.navigationController?.pushViewController(control, animated: true)
                //                let refreshAlert = UIAlertController(title: APPLICATION_NAME, message: logoutModel.message!, preferredStyle: UIAlertController.Style.alert)
                //                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                //
                //                }))
                //                self.present(refreshAlert, animated: true, completion: nil)
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
