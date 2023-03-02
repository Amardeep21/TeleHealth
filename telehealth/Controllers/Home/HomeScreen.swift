//
//  HomeScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit


class HomeScreen: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var wholeBlogView: UIView!
    @IBOutlet weak var seeAllTitleBlogView: UIView!
    @IBOutlet weak var ourBlogTitleLabel: UILabel!
    @IBOutlet weak var blogSeeAllHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var blogTitleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var blogViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var upcommingSessionSeeMoreImageView: UIImageView!
    @IBOutlet weak var specialitySeeMoreImageView: UIImageView!
    @IBOutlet weak var availblePshycologistSeeMoreImageView: UIImageView!
    @IBOutlet weak var ourBlogSeeMoreImageView: UIImageView!
    
    //MARK:UICollectionView Outlate
    @IBOutlet weak var specialityCollectionView: UICollectionView!
    @IBOutlet weak var psychologistsCollectionView: UICollectionView!
    @IBOutlet weak var upcomingSessionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var upcomingSessionDateLabel: UILabel!
    @IBOutlet weak var upcomingSessionTimeLabel: UILabel!
    @IBOutlet weak var upcomingSessionNameLabel: UILabel!
    @IBOutlet weak var upcomingSessionProfileImageView: UIImageView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var upcomingSessionView: UIView!
    @IBOutlet weak var notificationCountView: dateSportView!
    @IBOutlet weak var messageButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var unreadCountLabel: UILabel!
    
    @IBOutlet weak var emptyTherpistView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var videoCallButton: UIButton!
    
    //MARK:Object Declration with initilization
//    var itemsSpecialityObservale : Observable<[SpecialityInformationModel]>!
//    var itemPsychologistsObservale : Observable<[PsychologistsInformationModel]>!
    
    //MARK:Object Declration with initilization
    var blogModel:BlogsModel? = nil
    var homeModel:HomeModel? = nil
    var upcomingSessionModel:UpcomingSessionModel? = nil
//    let disposeBag = DisposeBag()
    
    //MARK:Variable Declration with initilization
    var specialityArray = [SpecialityInformationModel]()
    var psychologistsArray = [PsychologistsInformationModel]()
    var refreshHomePage: Bool = true
    var refreshControl = UIRefreshControl()
    
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogImageView: dateSportImageView!
    @IBOutlet weak var blogDateLabel: UILabel!
    @IBOutlet weak var blogDurationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
        if(Utility.isUserAlreadyLogin()){
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        token = (loginDetails.data?.auth?.accessToken ?? "") as String
                    }
                }catch{
                }
            }
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
        refreshHomePage = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getGreetings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
//        self.setupCollectionViewSelectMethod()
//        self.setupPsychologistCollectionViewSelectMethod()
        if(refreshHomePage){
            self.getHomeData()
        }else{
            refreshHomePage = true
        }
//        self.checkPermissions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshControl.endRefreshing()
    }
    
    @IBAction func onNotificationListScreen(_ sender: Any) {
        self.homeModel?.data?.unreadNotification = 0
        let storyBoard = UIStoryboard(name: "Notification", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "NotificationListScreen") as! NotificationListScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onSeeAllSpeciality(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SpecialityListScreen") as! SpecialityListScreen
        control.specialityArray = self.specialityArray
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onTodaySession(_ sender: Any) {
        let currentTime = Utility.getCurrentTime()
        let finalDate = "\(Utility.UTCToLocal(date: self.upcomingSessionModel?.appointmentDate ?? "", fromFormat: YYYY_MM_DDHHMM, toFormat: YYYY_MM_DD))"
        let isfromPastOrNot = Utility.findDateDiffArabic(time1Str: Utility.UTCToLocal(date: self.upcomingSessionModel?.appointmentDate ?? "", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA), time2Str: currentTime, selectedDate:finalDate,checkOneHour: true)
        var isFromUpcomingOrPast = Int()
        if(isfromPastOrNot){
            isFromUpcomingOrPast = 1
        }else{
            isFromUpcomingOrPast = 2
        }
        let storyBoard = UIStoryboard(name: "Appointments", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
        control.sessionId = self.upcomingSessionModel?.sessionId ?? 0
        control.isFromUpcomingOrPast = isFromUpcomingOrPast
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onBlogSeeAll(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "BlogListScreen") as! BlogListScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onSeeAllAvailiblity(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onIndividualBlog(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "BlogDetailScreen") as! BlogDetailScreen
        control.blogId = self.blogModel?.id!
        self.navigationController?.pushViewController(control, animated: true)
    }
    //MARK: Methods
    func setupCollectionView(){
        let nibCellSpeciality = UINib(nibName: "SpecialityCollectionViewCell", bundle: nil)
        specialityCollectionView.register(nibCellSpeciality, forCellWithReuseIdentifier: "SpecialityCell")
        
        let nibCellForPsychologists = UINib(nibName: "PsychologistsCollectionViewCell", bundle: nil)
        psychologistsCollectionView.register(nibCellForPsychologists, forCellWithReuseIdentifier: "PsychologistsCell")
        
            specialityCollectionView.reloadData()
        psychologistsCollectionView.reloadData()
        if(specialityArray.count != 0){
            if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                self.setCollectionViewScrollPostion(collectionView: self.specialityCollectionView, count: 0)
            }
        }
        if(psychologistsArray.count != 0){
            if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                self.setCollectionViewScrollPostion(collectionView: self.psychologistsCollectionView, count: 0)
            }
        }
//        itemsSpecialityObservale = Observable.just(specialityArray)
//        specialityCollectionView.dataSource = nil
//        specialityCollectionView.delegate = nil
//        specialityCollectionView.delegate = self
//        itemsSpecialityObservale.asObservable().bind(to: self.specialityCollectionView.rx.items(cellIdentifier: "SpecialityCell", cellType: SpecialityCollectionViewCell.self)) { row, data, cell in
//            Utility.setImage(data.icon, imageView: cell.specialityImageView)
//            cell.specialityTitle.text = data.speciality
//        }.disposed(by: disposeBag)
//        itemPsychologistsObservale = Observable.just(psychologistsArray)
//        psychologistsCollectionView.dataSource = nil
//        itemPsychologistsObservale.asObservable().bind(to: self.psychologistsCollectionView.rx.items(cellIdentifier: "PsychologistsCell", cellType: PsychologistsCollectionViewCell.self)) { row, data, cell in
//            Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
//
//            let string = data.speciality?.componentsJoined(by: ", ")
//            let education = data.education!.replacingOccurrences(of: "\n", with: ", ")
//            let language = data.languages!.replacingOccurrences(of: ",", with: ", ")
//            cell.yearOfExpLabel.text = "Experience: \(data.yearOfExperience ?? "") years"
//            cell.titleLabel.text = "\(data.firstname ?? "") \(data.lastname ?? ""), \(education)"
//            cell.specialityLabel.text = "Languages: \(language)"
//        }.disposed(by: disposeBag)
//
        if(self.blogModel != nil){
        blogTitleLabel.text = self.blogModel?.title
        Utility.setImage(self.blogModel?.media, imageView: blogImageView)
        blogDateLabel.text = Utility.UTCToLocal(date: (self.blogModel?.publishAt ?? ""), fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY)
        blogDurationLabel.text = "\(self.blogModel?.duration ?? "") \(Utility.getLocalizdString(value: "READ"))"
            seeAllTitleBlogView.isHidden = false
            ourBlogTitleLabel.isHidden = false
            wholeBlogView.isHidden = false
            blogSeeAllHeightConstant.constant = 22
            blogTitleHeightConstant.constant = 22
            blogViewHeightConstant.constant = 120
        }else{
            seeAllTitleBlogView.isHidden = true
            ourBlogTitleLabel.isHidden = true
            wholeBlogView.isHidden = true
            blogSeeAllHeightConstant.constant = 0
            blogTitleHeightConstant.constant = 0
            blogViewHeightConstant.constant = 0
        }
    }
    
    func setUpcomingSessionDetail(){
        if(upcomingSessionModel != nil)
        {
            upcomingSessionView.isHidden = false
            upcomingSessionViewHeightConstraint.constant = 155
            upcomingSessionNameLabel.text = "\(upcomingSessionModel!.firstname ?? "") \(upcomingSessionModel!.lastname ?? "")"
            Utility.setImage(self.upcomingSessionModel?.profile, imageView: upcomingSessionProfileImageView)
            upcomingSessionDateLabel.text = Utility.UTCToLocal(date: (self.upcomingSessionModel?.appointmentDate)!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMM_DD_YYYY)
            upcomingSessionTimeLabel.text = Utility.UTCToLocal(date: (self.upcomingSessionModel?.session)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            if(self.upcomingSessionModel?.services == 1){
                messageButtonWidthConstraint.constant = 27
                videoCallButton.isHidden = true
            }
           else if(self.upcomingSessionModel?.services == 2){
                videoCallButton.setImage(UIImage(named: "call_pink.png"), for: .normal)
            messageButtonWidthConstraint.constant = 0
            videoCallButton.isHidden = false

            }else if(self.upcomingSessionModel?.services == 3){
                videoCallButton.setImage(#imageLiteral(resourceName: "video_icon_session_screen"), for: .normal)
                messageButtonWidthConstraint.constant = 0
                videoCallButton.isHidden = false
            }else{
                videoCallButton.isHidden = true
            }
            
        }
    }
    
    @IBAction func onUpcomingSessionVideo(_ sender: UIButton) {
    }
    
    @IBAction func onUpcomingSessionChat(_ sender: UIButton) {
    }
    
    @IBAction func onUpcomingSeeAll(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
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
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                    if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                        if(uesrRole == 1){
                            greetingsLabel.text  = "\(greeting)، \(loginDetails.data?.username ?? "")"
                        }
                        else{
                            greetingsLabel.text  = "\(greeting)، \(loginDetails.data?.firstnameAr ?? "")"
                        }
                    }else{
                        if(uesrRole == 1){
                            greetingsLabel.text  = "\(greeting), \(loginDetails.data?.username ?? "")"
                        }
                        else{
                            greetingsLabel.text  = "\(greeting), \(loginDetails.data?.firstname ?? "")"
                        }
                    }
                   
                    
                    
                    
                }
                
            }catch{}
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if specialityCollectionView == collectionView{
         return specialityArray.count
        }else{
            return psychologistsArray.count
        }
        
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if specialityCollectionView == collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialityCell", for: indexPath) as! SpecialityCollectionViewCell
            let data =  specialityArray[indexPath.row]
            Utility.setImage(data.icon, imageView: cell.specialityImageView)
            cell.specialityTitle.text = data.speciality
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PsychologistsCell", for: indexPath) as! PsychologistsCollectionViewCell
            let data =  psychologistsArray[indexPath.row]
            if(data.profile != "" || data.profile != nil){
            Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
            }else{
                Utility.setImage("", imageView: cell.profileImageView)
            }
            let string = data.speciality?.componentsJoined(by: ", ")
            let education = data.education?.replacingOccurrences(of: "\n", with: ", ") ?? ""
            let language = data.languages?.replacingOccurrences(of: ",", with: ", ")
            if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                cell.yearOfExpLabel.text = "\(Utility.getLocalizdString(value: "EXP")): \(data.yearOfExperience ?? "") \(Utility.getLocalizdString(value: "YEARS"))"
            }else{
                cell.yearOfExpLabel.text = "سنوات الخبرة: \(data.yearOfExperience ?? "")"
            }

            cell.titleLabel.text = "\(data.firstname ?? "") \(data.lastname ?? "")"
            cell.educationLabel.text = "\(education)"
            cell.specialityLabel.text = "Languages: \(language)"
            cell.profileButton.tag = indexPath.row
            if(data.chatConsultationPrice != nil && data.chatConsultationPrice != "" &&  data.chatConsultationPrice != "0"){
                cell.chatView.isHidden = false
                cell.chatPriceLabel.text = "KD \(data.chatConsultationPrice ?? "")"
            }else{
                cell.chatView.isHidden = true
            }
            if(data.AudioVideoMinConsultationPrice != nil && data.AudioVideoMinConsultationPrice != "" &&  data.AudioVideoMinConsultationPrice != "0"){
                cell.audioVideoView.isHidden = false
                cell.audioVideoPriceLabel.text = "KD \(data.AudioVideoMinConsultationPrice ?? "")"
            }else{
                cell.audioVideoView.isHidden = true
            }
            cell.profileButton.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if specialityCollectionView == collectionView{
             let item =  specialityArray[indexPath.row]
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
            control.isFromSpeciality = true
            control.specialityModel = item
            self.navigationController?.pushViewController(control, animated: true)
         }else{
            let item =  psychologistsArray[indexPath.row]
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        
                        if(loginDetails.data!.flag == 0){
                            let storyBoard = UIStoryboard(name: "Question", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
                            control.psychologistId = item.id ?? 0
                            self.navigationController?.pushViewController(control, animated: true)
                        }else{
                            let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                            let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                            control.psychologistId = item.id ?? 0
                            self.navigationController?.pushViewController(control, animated: true)
                        }
                    }
                }catch{}
            }
        }
   
    }
    
    
    
    @objc func buttonClicked(sender:UIButton) {

            let buttonRow = sender.tag
        let item = self.psychologistsArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
               let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.profile ?? ""
               confirmAlertController.modalPresentationStyle = .overFullScreen
               self.present(confirmAlertController, animated: true, completion: nil)
        }
    
    //MARK:Get getHomeData list Api Call
    func getHomeData(shouldShowIndicator: Bool = false) {
        if Utility.isInternetAvailable(){
            if(shouldShowIndicator){
                Utility.showIndicator()
            }
            
            let url = "\(HOME)?timezone=\(localTimeZoneIdentifier)"
            HomeServices.shared.getHomeData(url: url, success: {(statusCode, specialityModel) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                
                self.blogModel = specialityModel.data?.blogs
                self.specialityArray = []
                self.psychologistsArray = []
                self.specialityArray.append(contentsOf: (specialityModel.data?.speciality)!)
                self.psychologistsArray.append(contentsOf: (specialityModel.data?.psychologists)!)
                if(specialityModel.data?.psychologists?.count == 0 || specialityModel.data?.psychologists?.count == nil){
                    self.emptyTherpistView.isHidden = false
                }else{
                    self.emptyTherpistView.isHidden = true
                }
                self.upcomingSessionModel = specialityModel.data?.upcomingSession
                self.homeModel = specialityModel
                self.setupCollectionView()
                self.setUpcomingSessionDetail()
                if(specialityModel.data?.unreadNotification == 0){
                    self.notificationCountView.isHidden = true
                }else{
                    self.notificationCountView.isHidden = false
                    self.unreadCountLabel.text = "\(specialityModel.data?.unreadNotification ?? 0)"
                }

            }) { (error) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            refreshControl.endRefreshing()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func setCollectionViewScrollPostion(collectionView:UICollectionView,count:Int){
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        let indexPath:IndexPath = IndexPath(item: count, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
    
    func initalizedDetails(){
        upcomingSessionView.isHidden = true
        upcomingSessionViewHeightConstraint.constant = 0
        self.getGreetings()
        self.getHomeData(shouldShowIndicator: true)
        self.registerForPushNotification()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            blogTitleLabel.textAlignment = .right
            upcommingSessionSeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
            ourBlogSeeMoreImageView.image  =  #imageLiteral(resourceName: "back_icon_black_color")
            availblePshycologistSeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
            specialitySeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_black_color")
        }else{
            blogTitleLabel.textAlignment = .left
            upcommingSessionSeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_right")
            ourBlogSeeMoreImageView.image  =  #imageLiteral(resourceName: "back_icon_right")
            availblePshycologistSeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_right")
            specialitySeeMoreImageView.image = #imageLiteral(resourceName: "back_icon_right")
        }
      
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
//        self.checkPermissions()
     }
     alertController.addAction(cancelAction)

    self.present(alertController, animated: true, completion: nil)
    }
    
    
//    func checkPermissions(){
//    
//        if UIApplication.shared.remoteNotificationsEnabled() {
//             // User is registered for notification
//        } else {
//            openSettingAlert()
//        }
//    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.getHomeData()
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
    func setupCollectionViewSelectMethod(){
//        self.specialityCollectionView.rx.modelSelected(SpecialityInformationModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
//                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
//                control.isFromSpeciality = true
//                control.specialityModel = item
//                self.navigationController?.pushViewController(control, animated: true)
//            }).disposed(by: disposeBag)
    }
    
    func setupPsychologistCollectionViewSelectMethod(){
//        self.psychologistsCollectionView.rx.modelSelected(PsychologistsInformationModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//                if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
//                    do{
//                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
//
//                            if(loginDetails.data!.flag == 0){
//                                let storyBoard = UIStoryboard(name: "Question", bundle: nil)
//                                let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
//                                control.psychologistId = item.id ?? 0
//                                self.navigationController?.pushViewController(control, animated: true)
//                            }else{
//                                let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
//                                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
//                                control.psychologistId = item.id ?? 0
//                                self.navigationController?.pushViewController(control, animated: true)
//                            }
//
//
//                        }
//                    }catch{}
//                }
//                //                let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
//                //                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
//                //                control.profileImageUrl = item.profile ?? ""
//                //                control.psychologistId = item.id ?? 0
//                //                control.psychologistName = "\(item.firstname ?? "") \(item.lastname ?? "")"
//                //                self.navigationController?.pushViewController(control, animated: true)
//            }).disposed(by: disposeBag)
    }
    
    
}

//MARK: CollectionView FlowLayout Delegate Methods
extension HomeScreen : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == specialityCollectionView){
            return CGSize(width: 152, height: 160)
        }else{
            return CGSize(width: 187, height: 230)
        }
    }
}


extension UIApplication {
    func remoteNotificationsEnabled() -> Bool {
        var notificationsEnabled = false
        if let userNotificationSettings = currentUserNotificationSettings {
            notificationsEnabled = userNotificationSettings.types.contains(.alert)
        }
        return notificationsEnabled
    }
}
