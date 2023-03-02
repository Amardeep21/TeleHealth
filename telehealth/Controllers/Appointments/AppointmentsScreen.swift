//
//  AppointmentsScreen.swift
//  telehealth
//
//  Created by iroid on 18/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class AppointmentsScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var sessionsTableView: UITableView!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    
    var sessionArray = [String]()
    var psychologistDetailModel:PsychologistsDataModel? = nil
    var selectedDate = String()
    var selectedTime = String()
    var appointmentArray:[AppointmentDataModel] = []
    var refreshControl = UIRefreshControl()
    var metaData:MetaDataModel!
    var isFromUpcommingOrPast = Int()
    var checkCurrantStatus = UPCOMMING_SELECED

    
    override func viewDidLoad() {
        super.viewDidLoad()
           initialiseDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            if #available(iOS 11.0, *){
                       upcomingButton.clipsToBounds = false
                       upcomingButton.layer.cornerRadius = 8
                       upcomingButton.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
                   }
                   if #available(iOS 11.0, *){
                       pastButton.clipsToBounds = false
                       pastButton.layer.cornerRadius = 8
                       pastButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
                   }
        }else{
            if #available(iOS 11.0, *){
                       upcomingButton.clipsToBounds = false
                       upcomingButton.layer.cornerRadius = 8
                       upcomingButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
                   }
                   if #available(iOS 11.0, *){
                       pastButton.clipsToBounds = false
                       pastButton.layer.cornerRadius = 8
                       pastButton.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
                   }
        }
       
        self.tabBarController?.tabBar.isHidden = false
        self.metaData = nil
        if self.checkCurrantStatus == UPCOMMING_SELECED{
            self.getSession(type: "upcoming")
        }else{
            self.getSession(type: "past")
        }
//        self.setupSessionTableViewSelectMethod()
    }
    
    //MARK:Initialise Detail
    func initialiseDetail(){
        
        appointmentArray.removeAll()
        self.metaData = nil
        isFromUpcommingOrPast = 1
//        upcomingButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 8)
//        pastButton.roundCorners(corners: [.topRight, .bottomRight], radius: 8)
       
        
        
        sessionsTableView.register(UINib(nibName: "SessionsTableViewCell", bundle: nil), forCellReuseIdentifier: "SessionsCell")
        if(appointmentArray.count > 0){
            sessionsTableView.reloadData()
        }
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshAppointments), for: UIControl.Event.valueChanged)
        sessionsTableView.addSubview(refreshControl)
//        getSession(type: "upcoming")
        
//        sessionsTableView.rx
//            .willDisplayCell
//            .subscribe(onNext: { cell, indexPath in
//
//            })
//            .disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateData),
            name: NSNotification.Name(rawValue: "REFRESH_DATA"),
            object: nil)
    }
    
    @objc private func updateData(notification: NSNotification){
//        appointmentArray.removeAll()
//        metaData = nil
//        if(self.checkCurrantStatus == UPCOMMING_SELECED){
//            self.getSession(type: "upcoming")
//        }else{
//            self.getSession(type: "past")
//        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = appointmentArray[indexPath.row]
        let cell = self.sessionsTableView.dequeueReusableCell(withIdentifier: "SessionsCell", for:indexPath) as! SessionsTableViewCell
        cell.selectionStyle = .none
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if(uesrRole == 1){
            
            cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? "")"
        }else{
//            if(checkCurrantStatus){
//                
//            }else{
//                
//            }
            cell.nameLabel.text = data.username
        }
        cell.chatButton.isUserInteractionEnabled = false
        cell.videoOrAudioButton.isUserInteractionEnabled = false
        cell.dateLabel.text = Utility.UTCToLocal(date: data.appointmentDate!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMM_DD_YYYY)
        cell.sessionLabel.text = Utility.UTCToLocal(date: data.session!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
        Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
        if(data.services == 1){
            cell.chatWidthConstraint.constant = 27
            cell.videoOrAudioButton.isHidden = true
            
        }else if(data.services == 2)
        {
            cell.videoOrAudioButton.isHidden = false
            cell.videoOrAudioButton.setImage(UIImage(named: "call_pink.png") , for: .normal)
            cell.chatWidthConstraint.constant = 0
        }else if(data.services == 3){
            cell.videoOrAudioButton.isHidden = false
            cell.videoOrAudioButton.setImage(#imageLiteral(resourceName: "video_icon_session_screen"), for: .normal)
            cell.chatWidthConstraint.constant = 0
        }else{
            cell.videoOrAudioButton.isHidden = true
        }
        
        
        if(data.isCanceled!){
            cell.cancelLabel.isHidden = false
          
        }else{
            cell.cancelLabel.isHidden = true
        
        }
        if(data.consultantType == 1){
            cell.sessionTypeLabel.text = Utility.getLocalizdString(value: "INDIVIDUALS")
        }else if(data.consultantType == 2){
            cell.sessionTypeLabel.text = Utility.getLocalizdString(value: "COUPLE")
        }else{
            cell.sessionTypeLabel.text = Utility.getLocalizdString(value: "FAMILY")
        }
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = appointmentArray[indexPath.row]
        let storyBoard = UIStoryboard(name: "Appointments", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
        control.sessionId = item.sessionId!
        control.psychologistId = item.psychologistId
        control.isFromUpcomingOrPast = self.isFromUpcommingOrPast
        self.navigationController?.pushViewController(control, animated: true)
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(self.appointmentArray.count - 1 == indexPath.row){
            if(self.metaData?.has_more_pages != nil){
                if(self.metaData.has_more_pages!){
                    if self.checkCurrantStatus == UPCOMMING_SELECED{
                        self.getSession(type: "upcoming")
                    }else{
                        self.getSession(type: "past")
                    }
                }
            }
        }
    }
    
    @objc func buttonClicked(sender:UIButton) {

            let buttonRow = sender.tag
        let item = self.appointmentArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
               let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.profile ?? ""
               confirmAlertController.modalPresentationStyle = .overFullScreen
               self.present(confirmAlertController, animated: true, completion: nil)
        }
//    //MARK: Load Payment method Table
//    func loadPaymentMethodTable(){
//        // Set automatic dimensions for row height
//        sessionsTableView.dataSource = nil
//        sessionsTableView.delegate = nil
//        itemsAppointmentObservale = Observable.just(appointmentArray)
//        itemsAppointmentObservale.bind(to: sessionsTableView.rx.items(cellIdentifier: "SessionsCell", cellType:SessionsTableViewCell.self)){(row,data,cell) in
//            print(data)
//
//        }.disposed(by: disposeBag)
//
//    }
    
//
//    func setupSessionTableViewSelectMethod(){
//        self.sessionsTableView.rx.modelSelected(AppointmentDataModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//
//            }).disposed(by: disposeBag)
//    }
    
    @objc func refreshAppointments() {
        self.appointmentArray.removeAll()
        self.sessionsTableView.reloadData()
        self.metaData = nil
        if checkCurrantStatus == UPCOMMING_SELECED{
            getSession(type: "upcoming")
        }else{
            getSession(type: "past")
        }
    }
    @IBAction func onUpcoming(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pastButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pastButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1), for: .normal)
        appointmentArray.removeAll()
        checkCurrantStatus = UPCOMMING_SELECED
        metaData = nil
        getSession(type: "upcoming")
        isFromUpcommingOrPast = 1
    }
    @IBAction func onPast(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        upcomingButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        upcomingButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1), for: .normal)
        appointmentArray.removeAll()
        checkCurrantStatus = PAST_SELECED
        metaData = nil
        getSession(type: "past")
        isFromUpcommingOrPast = 2
    }
    
    func loadMoreUrl(type: String) -> String{
        var url = String()
        if(self.metaData == nil){
            url = GET_APPOINTMENT+"\(type)"+"?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            url = "\(GET_APPOINTMENT)\(urlArray?.last ?? "")"
        }
        return url
    }
    
    //MARK:Get getHomeData list Api Call
    func getSession(type:String){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = self.loadMoreUrl(type: type)
            print(url)
            AppointmentServices.shared.getSessionData(url: url, success: { (statusCode, AppointmentModel) in
                Utility.hideIndicator()
                self.refreshControl.endRefreshing()
                if(self.metaData == nil){
                    self.appointmentArray = []
                    self.appointmentArray.append(contentsOf: (AppointmentModel.data!))
                }else{
                    self.appointmentArray.append(contentsOf: (AppointmentModel.data)!)
                }
                self.metaData = AppointmentModel.meta
                self.sessionsTableView.reloadData()
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
