//
//  PsychologistsHomeScreen.swift
//  telehealth
//
//  Created by iroid on 20/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

class PsychologistsHomeScreen: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    //MARK:UICollectionView Outlate
    
    @IBOutlet weak var wholeBlogView: UIView!
    @IBOutlet weak var seeAllTitleBlogView: UIView!
    @IBOutlet weak var ourBlogTitleLabel: UILabel!
    @IBOutlet weak var blogSeeAllHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var blogTitleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var blogViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sessionDoneLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogImageView: dateSportImageView!
    @IBOutlet weak var blogDateLabel: UILabel!
    @IBOutlet weak var blogDurationLabel: UILabel!
    //    @IBOutlet weak var bookName: UILabel!
    //    @IBOutlet weak var bookImageView: dateSportImageView!
    //    @IBOutlet weak var bookDateLabel: UILabel!
    //    @IBOutlet weak var bookDurationLabel: UILabel!
    @IBOutlet weak var totalDoneSessionLabel: UILabel!
    @IBOutlet weak var emptyBookSessionView: UIView!
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var countView: dateSportView!
    @IBOutlet weak var blogSeeAllImageView: UIImageView!
    
    @IBOutlet weak var updateAvailblityImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    //MARK:Object Declration with initilization
    //var itemUserSessionObservable : Observable<[BookedSessionsModel]>!
    var blogModel:BlogsModel? = nil
    var bookedSessionsModel:BookedSessionsModel? = nil
    var bookingSessionArray = [BookedSessionsModel]()
    var psychologistsHomeDetailsModel:PsychologistsHomeDetailsModel? = nil
    //   let disposeBag = DisposeBag()
    var refreshControl = UIRefreshControl()
    var refreshHomePage: Bool = true
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        initalizedDetails()
        refreshHomePage = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        self.getGreetings()
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            updateAvailblityImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
            blogSeeAllImageView.image  =  #imageLiteral(resourceName: "back_icon_black_color")
        }else{
            updateAvailblityImageView.image = #imageLiteral(resourceName: "back_icon_right")
            blogSeeAllImageView.image  =  #imageLiteral(resourceName: "back_icon_right")
        }
        if(refreshHomePage){
            refreshHomePage = true
            self.getHomeData()
        }else{
            refreshHomePage = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.checkPermissions()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.refreshControl.endRefreshing()
        showPromptToTherapist = false
    }
    
    func initalizedDetails(){
        let nibCellForPsychologists = UINib(nibName: "UserSessionProfileCollectionViewCell", bundle: nil)
        userCollectionView.register(nibCellForPsychologists, forCellWithReuseIdentifier: "UserCell")
        self.getHomeData()
        self.registerForPushNotification()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        if(Utility.isUserAlreadyLogin()){
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        token = (loginDetails.data?.auth?.accessToken ?? "") as String
                    }
                }catch{
                }
            }
            SocketHelper.shared.connectSocket(completion: { val in
                if(val){
                    print("socket connected")
                    if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                        do{
                            if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                var parameter = [String: Any]()
                                parameter = ["senderId": loginDetails.data?.id ?? 0,
                                ] as [String:Any]
                                SocketHelper.Events.UpdateStatusToOnline.emit(params: parameter)
                            }
                        }catch{}
                    }
                }
            })
        }
        if(showPromptToTherapist){
            
        }
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        let item = self.bookingSessionArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.profile ?? ""
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    //
    //    func setupCollectionViewSelectMethod(){
    //        self.userCollectionView.rx.modelSelected(BookedSessionsModel.self)
    //            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
    //            .subscribe(onNext: {
    //                item in
    //
    //            }).disposed(by: disposeBag)
    //    }
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingSessionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserSessionProfileCollectionViewCell
        let data = bookingSessionArray[indexPath.row]
        cell.userNameImageView.text = data.username ?? ""
        cell.dateLabel.text = Utility.UTCToLocal(date: data.appointmentDate ?? "", fromFormat: YYYY_MM_DDHHMM, toFormat: MMM_DD_YYYY)
        if(data.services == 1){
            cell.audioOrVideoButton.isHidden = true
            cell.chatButton.isHidden = false
            cell.chatButtonWidthConstraint.constant = 27
            
        }
        else if(data.services == 2){
            cell.audioOrVideoButton.isHidden = false
            cell.chatButton.isHidden = true
            cell.chatButtonWidthConstraint.constant = 0
            cell.audioOrVideoButton.setImage(UIImage(named: "call_pink.png"), for: .normal)
        }else if(data.services == 3){
            cell.audioOrVideoButton.isHidden = false
            cell.audioOrVideoButton.setImage(#imageLiteral(resourceName: "video_icon_session_screen"), for: .normal)
            cell.chatButton.isHidden = true
            cell.chatButtonWidthConstraint.constant = 0
        }else{
            
        }
        cell.timeLabel.text = Utility.UTCToLocal(date: data.session ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
        Utility.setImage(data.profile, imageView: cell.userProfileImageView)
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = bookingSessionArray[indexPath.row]
        let currentTime = Utility.getCurrentTime()
        let isfromPastOrNot = Utility.findDateDiffArabic(time1Str: Utility.UTCToLocal(date: item.session ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
        var isFromUpcomingOrPast = Int()
        if(isfromPastOrNot){
            isFromUpcomingOrPast = 1
        }else{
            isFromUpcomingOrPast = 2
        }
        let storyBoard = UIStoryboard(name: "Appointments", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
        control.sessionId = item.sessionId ?? 0
        control.isFromUpcomingOrPast = isFromUpcomingOrPast
        self.navigationController?.pushViewController(control, animated: true)
    }
    //    func setupCollectionView(){
    //        itemUserSessionObservable = Observable.just(bookingSessionArray)
    //        userCollectionView.dataSource = nil
    //        itemUserSessionObservable.asObservable().bind(to: self.userCollectionView.rx.items(cellIdentifier: "UserCell", cellType: UserSessionProfileCollectionViewCell.self)) { row, data, cell in
    //
    //        }.disposed(by: disposeBag)
    //}
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.getHomeData()
    }
    
    //MARK: Methods
    func setupData(){
        if(self.blogModel != nil){
            blogTitleLabel.text = self.blogModel?.title
            Utility.setImage(self.blogModel?.media, imageView: blogImageView)
            blogDateLabel.text = Utility.UTCToLocal(date: self.blogModel?.publishAt ?? "", fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY)
            blogDurationLabel.text = "\(self.blogModel?.duration ?? "") \(Utility.getLocalizdString(value: "READ"))"
            seeAllTitleBlogView.isHidden = false
            ourBlogTitleLabel.isHidden = false
            blogSeeAllHeightConstant.constant = 22
            blogTitleHeightConstant.constant = 22
            blogViewHeightConstant.constant = 120
            wholeBlogView.isHidden = false
        }else{
            seeAllTitleBlogView.isHidden = true
            ourBlogTitleLabel.isHidden = true
            blogSeeAllHeightConstant.constant = 0
            blogTitleHeightConstant.constant = 0
            blogViewHeightConstant.constant = 0
            wholeBlogView.isHidden = true
        }
        
        //        bookName.text = bookedSessionsModel?.username ?? ""
        //        bookDateLabel.text = Utility.UTCToLocal(date: bookedSessionsModel?.appointmentDate ?? "", fromFormat: YYYY_MM_DDHHMM, toFormat: MMM_DD_YYYY)
        //        bookDurationLabel.text = Utility.UTCToLocal(date: bookedSessionsModel?.session ?? "", fromFormat: HHMM, toFormat: HHMMA)
        //        Utility.UTCToLocal(date: bookedSessionsModel?.session ?? "", fromFormat: HHMM, toFormat: HHMMA)
        //        Utility.setImage(self.bookedSessionsModel?.profile, imageView: bookImageView)
        let totalSession = Double((psychologistsHomeDetailsModel?.totalSessions) ?? Int(0.0))
        let remaingSession = Double((psychologistsHomeDetailsModel?.remainingSessions) ?? Int(0.0))
        let result = Double(totalSession - remaingSession)
        
        progressView.trackClr = #colorLiteral(red: 1, green: 0.8862745098, blue: 0.8156862745, alpha: 1)
        progressView.progressClr = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        
        var avg = Double()
        if(result != 0){
            avg = (((result * 100.0) / totalSession)/100.0)
        }else{
            avg = 0
        }
        progressView.setProgressWithAnimation(duration: 1.0, value: Float(avg))
        totalDoneSessionLabel.text = "\(Int(result)) \(Utility.getLocalizdString(value: "OF")) \(psychologistsHomeDetailsModel?.totalSessions ?? 0) \(Utility.getLocalizdString(value: "COMPLETED"))"
        sessionDoneLabel.text = "\(Int(result))"
    }
    
    func openSettingAlert(){
        let alertController = UIAlertController (title: Utility.getLocalizdString(value: "PUSH_NOTIFICATION_PERMISSION"), message: Utility.getLocalizdString(value: "PUSH_MESSAGE"), preferredStyle: .alert)
        
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
//            self.checkPermissions()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
//    func checkPermissions(){
//        if  UIApplication.shared.remoteNotificationsEnabled() {
//            // User is registered for notification
//        } else {
//            openSettingAlert()
//        }
//    }
    
    func getGreetings(){
        var greeting = String()
        let date     = Date()
        let calendar = Calendar.current
        let hour     = calendar.component(.hour, from: date)
        let morning = 3; let afternoon=12; let evening=16; let night=22;
        print("Hour: \(hour)")
        if morning < hour, hour < afternoon {
            greeting = Utility.getLocalizdString(value: "GOOD_MORNING")
        }else if afternoon <= hour, hour < evening{
            greeting = Utility.getLocalizdString(value: "GOOD_AFTERNOON")
        }else if evening <= hour, hour < night{
            greeting = Utility.getLocalizdString(value: "GOOD_EVENING")
        }else{
            greeting = Utility.getLocalizdString(value: "GOOD_NIGHT")
        }
        print(greeting)
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                        if(uesrRole == 1){
                            greetingsLabel.text  = "\(greeting)، \(loginDetails.data?.username ?? "")"
                        }
                        else{
                            greetingsLabel.text  = "\(greeting)، \(loginDetails.data?.firstnameAr ?? "") \(loginDetails.data?.lastnameAr ?? "")"
                        }
                    }else{
                        if(uesrRole == 1){
                            greetingsLabel.text  = "\(greeting), \(loginDetails.data?.username ?? "")"
                        }
                        else{
                            greetingsLabel.text  = "\(greeting), \(loginDetails.data?.firstname ?? "") \(loginDetails.data?.lastname ?? "")"
                        }
                    }
                }
                
            }catch{}
        }
        
    }
    
    
    @IBAction func onUpdateAvailability(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onNotification(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Notification", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "NotificationListScreen") as! NotificationListScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    
    @IBAction func onTodaySession(_ sender: Any) {
        //        let currentTime = Utility.getCurrentTime()
        //        let isfromPastOrNot = Utility.findDateDiff(time1Str: Utility.UTCToLocal(date: bookedSessionsModel?.session ?? "", fromFormat: HHMM, toFormat: HHMMA), time2Str: currentTime, selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true)
        let currentTime = "\(Date().string(format: YYYY_MM_DD)) \(Utility.dateFormatting())"
        let isfromPastOrNot = Utility.findDateDiffArabic(time1Str: Utility.stringDatetoStringDateWithDifferentFormate(dateString: bookedSessionsModel!.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM), time2Str: currentTime,selectedDate: Date().string(format: YYYY_MM_DD),checkOneHour: true, dateFormate: YYYY_MM_DDAMPM)
        var isFromUpcomingOrPast = Int()
        if(isfromPastOrNot){
            isFromUpcomingOrPast = 1
        }else{
            isFromUpcomingOrPast = 2
        }
        let storyBoard = UIStoryboard(name: "Appointments", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
        control.sessionId = self.bookedSessionsModel?.sessionId ?? 0
        control.isFromUpcomingOrPast = isFromUpcomingOrPast
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onSeeAll(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "BlogListScreen") as! BlogListScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onIndividualBlog(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "BlogDetailScreen") as! BlogDetailScreen
        control.blogId = self.blogModel?.id!
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    func registerForPushNotification(){
        if Utility.isInternetAvailable(){
            let parameters = ["token" :UserDefaults.standard.object(forKey: FCM_TOKEN) ?? "",
                              "type" : "iOS",
                              DEVICE_ID:DEVICE_UNIQUE_IDETIFICATION,
            ] as [String : Any]
            LoginServices.shared.registerForPush(parameters: parameters, success: { (statusCode, commanModel) in
                
            }) { (error) in
            }
        }else{
            
        }
    }
    
    func getStatus(){
        Utility.showIndicator()
        PsychologistsHomeService.shared.getStatus(url: GET_STATUS) { (statusCode , CommanModel) in
            Utility.hideIndicator()
            showPromptToTherapist = false
            messageAlert = ""
            if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                if(!(CommanModel.data?.isEnglishProfileCompleted)!){
                    showPromptToTherapist = true
                    messageAlert = CommanModel.message!
                    let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: messageAlert, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "COMPLETE_NOW"), style: .default, handler: { (action: UIAlertAction!) in
                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                        showPromptToTherapist = false
                        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                        control.isFromSetting = true
                        self.navigationController?.pushViewController(control, animated: true)
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .cancel, handler: { (action: UIAlertAction!) in
                        showPromptToTherapist = false
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }else{
                if(!(CommanModel.data?.isArabicProfileCompleted)!){
                    showPromptToTherapist = true
                    messageAlert = CommanModel.message!
                    let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: messageAlert, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "COMPLETE_NOW"), style: .default, handler: { (action: UIAlertAction!) in
                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
                        showPromptToTherapist = false
                        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistSelfScreen") as! PsychologistSelfScreen
                        control.isFromSetting = true
                        self.navigationController?.pushViewController(control, animated: true)
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .cancel, handler: { (action: UIAlertAction!) in
                        showPromptToTherapist = false
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        } failure: { (error) in
            Utility.hideIndicator()
            Utility.showAlert(vc: self, message: error)
        }
        
    }
    
    //MARK:Get getHomeData list Api Call
    func getHomeData(shouldShowIndicator: Bool = false) {
        if Utility.isInternetAvailable(){
            if(shouldShowIndicator){
                Utility.showIndicator()
            }
            let url = "\(PSYCHOLOGIST_HOME)?timezone=\(localTimeZoneIdentifier)"
            PsychologistsHomeService.shared.getHomeData(url: url, success: { (statusCode, psychologistHomeModel) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                
                self.blogModel = psychologistHomeModel.data?.blogs
                self.psychologistsHomeDetailsModel = psychologistHomeModel.data
                self.bookingSessionArray = []
                self.bookingSessionArray.append(contentsOf: (psychologistHomeModel.data?.bookedSessions)!)
                //                self.setupCollectionView()
                self.userCollectionView.reloadData()
                if self.bookingSessionArray.count != 0{
                    self.emptyBookSessionView.isHidden = true
                }
                if(psychologistHomeModel.data?.unreadNotification == 0){
                    self.countView.isHidden = true
                }else{
                    self.countView.isHidden = false
                    self.countLabel.text = "\(psychologistHomeModel.data?.unreadNotification ?? 0)"
                    
                }
                self.setupData()
                if(showPromptToTherapist){
                    self.getStatus()
                }
                
            }) { (error) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            self.refreshControl.endRefreshing()
            
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:Check Fillup Status
    func checkInformationStatus(shouldShowIndicator: Bool = false) {
        if Utility.isInternetAvailable(){
            if(shouldShowIndicator){
                Utility.showIndicator()
            }
            PsychologistsHomeService.shared.getHomeData(url: GET_STATUS, success: { (statusCode, psychologistHomeModel) in
                Utility.hideIndicator()
                
            }) { (error) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            self.refreshControl.endRefreshing()
            
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
}
extension Date {
    func string(format: String) -> String {
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = format
            return formatter.string(from: self)
        }else{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
    }
}
//MARK: CollectionView FlowLayout Delegate Methods
extension PsychologistsHomeScreen : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: emptyBookSessionView.layer.frame.width, height: 90)
        
    }
}
