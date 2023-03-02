//
//  MySessionScreen.swift
//  telehealth
//
//  Created by iroid on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import AVFoundation
class MySessionScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:UILabel IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfSessionLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var totalPaymentTitleLabel: UILabel!
    
    @IBOutlet weak var bookSessionButton: dateSportButton!
    @IBOutlet weak var consultantType: UILabel!
    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var counsellingLabel: UILabel!
//    @IBOutlet weak var genderLabel: UILabel!
//    @IBOutlet weak var marriedStatusLabel: UILabel!
//    @IBOutlet weak var beforeCounsellingLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionView: dateSportView!
//    @IBOutlet weak var questionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceButton: dateSportButton!
//    @IBOutlet weak var sessionTypeBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionAnswerTableView: UITableView!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var cancelSessionTitleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelSessionTitleView: dateSportView!
    @IBOutlet weak var chatButton: dateSportButton!
    @IBOutlet weak var pastButtonView: UIView!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var serviceButtonLeadingConstraint: NSLayoutConstraint!
    
    var sessionId = Int()
    var appointmentDeatilModel :AppointmentDataModel?
    var psychologistDetailModel:PsychologistsDataModel?
    var serviceType :Int?
    var psychologistId :Int?
    var isFromUpcomingOrPast :Int?
    var isFromPushNotification : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkPermissions()
    }
    
    func checkPermissions(){
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
           openSettingAlert()
        }
        
        if !self.isAuthorized(){
            openSettingAlert()
        }
    }
    
    func openSettingAlert(){
        let alertController = UIAlertController (title: Utility.getLocalizdString(value: "PERMISSION_REQUIRED"), message: Utility.getLocalizdString(value: "ALLOW_PERMISSION_MSG"), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: Utility.getLocalizdString(value: "GOTO_SETTINGS"), style: .default) { (_) -> Void in

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
             return
         }

         if UIApplication.shared.canOpenURL(settingsUrl) {
             UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                 print("Settings opened: \(success)") // Prints true
             })
         }
     }
     alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .default){ (_) -> Void in
        self.checkPermissions()
     }
     alertController.addAction(cancelAction)

    self.present(alertController, animated: true, completion: nil)
    }
     public func isAuthorized() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    @IBAction func onCall(_ sender: Any) {
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if(uesrRole == 1){
//            let currentTime = Utility.getCurrentTime()
//            let isfromPastOrNot = self.findDateDiff(time1Str: Utility.UTCToLocal(date: appointmentDeatilModel?.session ?? "", fromFormat: HHMM, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
            let currentTime = Utility.getCurrentTime()
                           let isfromPastOrNot = Utility.findDateDiff(time1Str: Utility.UTCToLocal(date: appointmentDeatilModel?.session ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
            if(isfromPastOrNot){
                self.joinCall()
            }else{
                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SESSION_TIME_NOT_STARTED"))
            }
        }else{
//            let currentTime = Utility.getCurrentTime()
//            let isfromPastOrNot = self.findDateDiff(time1Str: Utility.UTCToLocal(date: appointmentDeatilModel?.session ?? "", fromFormat: HHMM, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
            let currentTime = Utility.getCurrentTime()
                                   let isfromPastOrNot = Utility.findDateDiff(time1Str: Utility.UTCToLocal(date: appointmentDeatilModel?.session ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
            if(isfromPastOrNot){
                self.createRoomCall()
            }else{
                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SESSION_TIME_NOT_STARTED"))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    @IBAction func onEdit(_ sender: Any) {
        var isFromFree:Bool = false
        if(appointmentDeatilModel?.consultationPrice == "0" || appointmentDeatilModel?.consultationPrice == nil || appointmentDeatilModel?.consultationPrice == ""){
            isFromFree = true
        }
        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
        control.isFromEdit = true
        control.editPsychologistId = appointmentDeatilModel?.psychologistId as! Int
        control.sessionType = appointmentDeatilModel?.type ?? 0
        control.sessionId = self.sessionId
        control.isFromFree = isFromFree
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onBack(_ sender: UIButton) {
 
            self.navigationController?.popViewController(animated: true)
     
    }
    
    
    @IBAction func onProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
               let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = appointmentDeatilModel?.profile ?? ""
               confirmAlertController.modalPresentationStyle = .overFullScreen
               self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    @IBAction func onRearrange(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
        control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onChat(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "ChatScreen") as! ChatScreen
        control.appointmentDeatilModel = appointmentDeatilModel
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onGiveRating(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "FeedbackScreen") as! FeedbackScreen
        control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
        control.modalPresentationStyle = .overFullScreen
        self.present(control, animated: true, completion: nil)
    }
    
    func findDateDiff(time1Str: String, time2Str: String,selectedDate: String,checkOneHour: Bool = false) -> Bool {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = HHMMA
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
            if((-3600 ... 0 ~= intervalInt)){
                return true
            }
            else{
                return false
            }
        }
    }
    
    func initalizedDetails(){
        bookSessionButton.isHidden = true
        questionAnswerTableView.register(UINib(nibName: "QuestionAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if uesrRole == 1{
//            questionViewHeight.constant = 0
            tableViewHeightConstant.constant = 0
            questionView.isHidden = true
            titleLabel.text = Utility.getLocalizdString(value: "YOUR_SESSIONS")
//            sessionTypeBottomConstraint.constant = 15
            totalPaymentTitleLabel.text = Utility.getLocalizdString(value: "TOTAL_PAYMENT")
            if(isFromUpcomingOrPast == 1){
                editButton.isHidden = false
            }else{
                editButton.isHidden = true
            }
            if(isFromUpcomingOrPast == 1){
                self.pastButtonView.isHidden = true
//                self.serviceButton.isHidden = false
//                self.chatButton.isHidden = false
            }else{
                self.pastButtonView.isHidden = false
                self.serviceButton.isHidden = true
                self.chatButton.isHidden = true
            }
        }
        else{
            if(isFromUpcomingOrPast == 2){
                serviceButton.isHidden = true
                chatButton.isHidden = true
                bookSessionButton.isHidden = false
            }else{
                serviceButton.isHidden = false
                chatButton.isHidden = false
            }
            titleLabel.text = Utility.getLocalizdString(value: "MY_SESSION")
//            totalPaymentTitleLabel.text = ""
        
        }
        
        getAppointmentDetail(sessionId: sessionId)
        
        
    }
    
    func setUserAppointmentDetails(){
        if(appointmentDeatilModel?.isCanceled == true){
            self.pastButtonView.isHidden = true
            self.serviceButton.isHidden = true
            self.chatButton.isHidden = true
            editButton.isHidden = true
            cancelSessionTitleViewHeightConstraint.constant = 40
            reasonView.isHidden = false
            reasonLabel.text = appointmentDeatilModel?.reason
        }else{
            cancelSessionTitleViewHeightConstraint.constant = 0
            reasonView.isHidden = true
            reasonLabel.text = ""
        }
        serviceType = appointmentDeatilModel!.services!
        nameLabel.text = appointmentDeatilModel?.username
        dateLabel.text = Utility.UTCToLocal(date: appointmentDeatilModel!.appointmentDate!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY)
        timeLabel.text = Utility.UTCToLocal(date: appointmentDeatilModel!.session!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
        Utility.setImage(appointmentDeatilModel?.profile ?? "", imageView: profileImageView)
        self.setCallButton(serviceType:serviceType!)
//        counsellingLabel.text = self.setCounsellingValue()
//        genderLabel.text = self.setGenderValue()
//        marriedStatusLabel.text = self.setRelationship()
//        beforeCounsellingLabel.text = self.setCounsellingBefore()
        if(appointmentDeatilModel?.consultationPrice == nil){
            totalPaymentLabel.text =  "\(appointmentDeatilModel?.consultationPrice ?? "Free") "

        }else{
            totalPaymentLabel.text =  "\(appointmentDeatilModel?.consultationPrice ?? "0") KD"

        }
        
        if(appointmentDeatilModel?.consultantType == 1){
            consultantType.text = Utility.getLocalizdString(value: "INDIVIDUALS")
        }else if(appointmentDeatilModel?.consultantType == 2){
            consultantType.text = Utility.getLocalizdString(value: "COUPLE")
        }else{
            consultantType.text = Utility.getLocalizdString(value: "FAMILY")
        }
        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
        if(appointmentDeatilModel?.questions?.en?.count == 0){
                 questionView.isHidden = true
                 tableViewHeightConstant.constant = 0
             }else{
                 questionView.isHidden = false
                tableViewHeightConstant.constant = 256
                questionAnswerTableView.reloadData()
             }
        }else{
            if(appointmentDeatilModel?.questions?.ar?.count == 0){
                     questionView.isHidden = true
                     tableViewHeightConstant.constant = 0
                 }else{
                     questionView.isHidden = false
                    tableViewHeightConstant.constant = 256
                    questionAnswerTableView.reloadData()
                 }
        }
//         if()
    }
    @IBAction func onBookSession(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
        control.isFromRequest = true
        control.isFromPastRequest = true
        control.isFromPastBookRequest = true
        control.appointmentDeatilModel = appointmentDeatilModel
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    func setCounsellingValue() -> String{
        if(appointmentDeatilModel?.counsellingType == 1){
            return Utility.getLocalizdString(value: "INDIVIDUAL_COUNSELLING")
        }else if(appointmentDeatilModel?.counsellingType == 2){
            return Utility.getLocalizdString(value: "COUPLE_COUNSELLING")
        }else{
            return Utility.getLocalizdString(value: "TEEN_COUNSELLING")
        }
    }
    
    func setGenderValue() -> String{
        if(appointmentDeatilModel?.gender == 1){
            return Utility.getLocalizdString(value: "MALE")
        }else{
            return Utility.getLocalizdString(value: "FEMALE")
        }
    }
    
    func setRelationship() -> String{
        if(appointmentDeatilModel?.relationship == 1){
            return Utility.getLocalizdString(value: "MARRIED")
        }else{
            return Utility.getLocalizdString(value: "UN_MARRIED")
        }
    }
    
    func setCounsellingBefore() -> String{
        if(appointmentDeatilModel?.relationship == 1){
            return Utility.getLocalizdString(value: "YES")
        }else{
            return Utility.getLocalizdString(value: "NO")
        }
    }
    
    func setCallButton(serviceType:Int){
//        if(serviceType == 1)
//        {
//            typeOfSessionLabel.text = Utility.getLocalizdString(value: "CHAT")
//            chatButtonTrailingConstraint.constant = (((pastButtonView.frame.size.width/2) + 23 ) - (chatButton.layer.frame.width / 2))
//            serviceButton.isHidden = true
//        }
         if(serviceType == 2)
        {
//            chatButton.isHidden = true
           // serviceButtonLeadingConstraint.constant = ((pastButtonView.frame.size.width/2) - (serviceButton.layer.frame.width / 2))
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "AUDIO_CALL")
                serviceButton.setTitle(Utility.getLocalizdString(value: "JOIN_AUDIO_CALL"), for: .normal)
            }else{
                typeOfSessionLabel.text =  Utility.getLocalizdString(value: "AUDIO_CALL")
                serviceButton.setTitle(Utility.getLocalizdString(value: "START_AUDIO_CALL"), for: .normal)
            }
        }
        else if(serviceType == 3)
        {
//            chatButton.isHidden = true
//            serviceButtonLeadingConstraint.constant = ((pastButtonView.frame.size.width/2) - (serviceButton.layer.frame.width / 2))
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "VIDEO_CALL")
                serviceButton.setTitle(Utility.getLocalizdString(value: "JOIN_VIDEO_CALL"), for: .normal)
            }else{
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "VIDEO_CALL")
                serviceButton.setTitle(Utility.getLocalizdString(value: "START_VIDEO_CALL"), for: .normal)
            }
        }
        else{
            typeOfSessionLabel.text = Utility.getLocalizdString(value: "CHAT")
            chatButtonTrailingConstraint.constant = (((pastButtonView.frame.size.width/2) + 23 ) - (chatButton.layer.frame.width / 2))
                        serviceButton.isHidden = true
            
        }
    }
    
    func setPsychologistAppointmentDetails(){
        if(appointmentDeatilModel?.isCanceled == true){
            self.pastButtonView.isHidden = true
            self.serviceButton.isHidden = true
            self.chatButton.isHidden = true
            editButton.isHidden = true
            cancelSessionTitleViewHeightConstraint.constant = 40
            reasonView.isHidden = false
            reasonLabel.text = appointmentDeatilModel?.reason
        }else{
            cancelSessionTitleViewHeightConstraint.constant = 0
            reasonView.isHidden = true
            reasonLabel.text = ""
        }
        serviceType = appointmentDeatilModel!.services!
        nameLabel.text = "\(appointmentDeatilModel?.firstname ?? "") \(appointmentDeatilModel?.lastname ?? "")"
        dateLabel.text = Utility.UTCToLocal(date: appointmentDeatilModel!.appointmentDate!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY)
        timeLabel.text = Utility.UTCToLocal(date: appointmentDeatilModel!.session!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
        Utility.setImage(appointmentDeatilModel?.profile ?? "", imageView: profileImageView)
        self.setCallButton(serviceType: serviceType!)
        if(appointmentDeatilModel?.consultationPrice == nil){
            totalPaymentLabel.text =  "\(appointmentDeatilModel?.consultationPrice ?? "Free") "
        }else{
            totalPaymentLabel.text =  "\(appointmentDeatilModel?.consultationPrice ?? "0") KD"
        }
        totalPaymentLabel.text =  "\(appointmentDeatilModel?.consultationPrice ?? "0") KD"
        
        if(appointmentDeatilModel?.consultantType == 1){
            consultantType.text = Utility.getLocalizdString(value: "INDIVIDUALS")
        }else if(appointmentDeatilModel?.consultantType == 2){
            consultantType.text = Utility.getLocalizdString(value: "COUPLE")
        }else{
            consultantType.text = Utility.getLocalizdString(value: "FAMILY")
        }
//        if(appointmentDeatilModel?.consultantType == 1){
//            consultantType.text = INDIVIDUAL
//        }else if(appointmentDeatilModel?.consultantType == 2){
//            consultantType.text = COUPLE
//        }else{
//            consultantType.text = FAMILY
//        }
//        if(appointmentDeatilModel?.consultantType == 0){
//            questionView.isHidden = true
//            questionViewHeight.constant = 0
//        }else{
//            questionView.isHidden = false
//            questionViewHeight.constant = 256
//        }
    }
    
    func createRoomCall(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = CREATE_ROOM + "\(sessionId)"
            AppointmentServices.shared.createOrJoinRoom(url: url, success: { (statusCode, callModel) in
                Utility.hideIndicator()
                self.navigateToVideoOrAudioScreen(callModel: callModel)
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func navigateToVideoOrAudioScreen(callModel: CallModel){
        if(appointmentDeatilModel?.services == 2){
            let storyBoard = UIStoryboard(name: "VoiceCall", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "VoiceCallScreen") as! VoiceCallScreen
            control.appointmentDeatilModel = self.appointmentDeatilModel
            control.callModel = callModel
            control.onDoneBlock = { result in
                // Do something
                if(result){
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                    if(uesrRole == 1){
                        let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
                        let control = storyBoard.instantiateViewController(withIdentifier: "FeedbackScreen") as! FeedbackScreen
                        control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
                        control.onDoneBlock2 = { result in
                        print(self.appointmentDeatilModel?.consultationPrice!)
                            if(self.appointmentDeatilModel?.consultationPrice == "0" || self.appointmentDeatilModel?.consultationPrice == ""){
                        let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "BOOK_YOUR_SESSION"), message: Utility.getLocalizdString(value: "WOULD_YOU_LIKE_TO_BOOK"), preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "YES"), style: .default, handler: { (action: UIAlertAction!) in
                            let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                            control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
                            self.navigationController?.pushViewController(control, animated: true)
                        }))

                        refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "LATER"), style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        }))

                        self.present(refreshAlert, animated: true, completion: nil)
                            }
                        }
                        control.modalPresentationStyle = .overFullScreen
                        self.present(control, animated: true, completion: nil)
                    }
                }
            }
            self.navigationController?.pushViewController(control, animated: true)
        }
        else{
            let storyBoard = UIStoryboard(name: "VideoCall", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "VideoCallScreen") as! VideoCallScreen
            control.appointmentDeatilModel = self.appointmentDeatilModel
            control.callModel = callModel
            control.onDoneBlock = { result in
                // Do something
                if(result){
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                    if(uesrRole == 1){
                        let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
                        let control = storyBoard.instantiateViewController(withIdentifier: "FeedbackScreen") as! FeedbackScreen
                        control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
                        control.onDoneBlock2 = { result in
                        print(self.appointmentDeatilModel?.consultationPrice!)
                            if(self.appointmentDeatilModel?.consultationPrice == "0" || self.appointmentDeatilModel?.consultationPrice == ""){
                                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "BOOK_YOUR_SESSION"), message: Utility.getLocalizdString(value: "WOULD_YOU_LIKE_TO_BOOK"), preferredStyle: UIAlertController.Style.alert)

                                refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "YES"), style: .default, handler: { (action: UIAlertAction!) in
                                    let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                                    let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                                    control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
                                    self.navigationController?.pushViewController(control, animated: true)
                                }))

                                refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "LATER"), style: .cancel, handler: { (action: UIAlertAction!) in
                                    print("Handle Cancel Logic here")
                                }))

                                self.present(refreshAlert, animated: true, completion: nil)
                                    }
                        }
                        control.modalPresentationStyle = .overFullScreen
                        self.present(control, animated: true, completion: nil)
                    }
                }
            }
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
    
    func joinCall(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = JOIN_ROOM + "\(sessionId)"
            AppointmentServices.shared.createOrJoinRoom(url: url, success: { (statusCode, callModel) in
                Utility.hideIndicator()
                self.navigateToVideoOrAudioScreen(callModel: callModel)
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    
    //MARK:Get Appointment detail Api call
    func getAppointmentDetail(sessionId:Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = GET_APPOINTMENT_DETAIL + "\(sessionId)"
            AppointmentServices.shared.getAppointmentDetail(url: url, success: { (statusCode, appointmentModel) in
                Utility.hideIndicator()
                self.appointmentDeatilModel = appointmentModel.detailData
                if(self.appointmentDeatilModel!.role == 1){
                    self.setUserAppointmentDetails()
                }else{
                    self.setPsychologistAppointmentDetails()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
        return self.appointmentDeatilModel?.questions?.en?.count ?? 0
        }else{
            return self.appointmentDeatilModel?.questions?.ar?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.questionAnswerTableView.dequeueReusableCell(withIdentifier: "QuestionCell", for:indexPath) as! QuestionAnswerTableViewCell
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            let item = self.appointmentDeatilModel?.questions?.ar?[indexPath.row]
            cell.questionLabel.text = item?.question
            cell.answerLabel.text = item?.value
        }else{
            let item = self.appointmentDeatilModel?.questions?.en?[indexPath.row]
            cell.questionLabel.text = item?.question
            cell.answerLabel.text = item?.value
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableViewHeightConstant.constant  = tableView.contentSize.height
        }
    }
}
