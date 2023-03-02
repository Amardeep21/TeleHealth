//
//  SelectSessionByUserScreen.swift
//  telehealth
//
//  Created by Apple on 19/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectSessionByUserScreen: UIViewController, FSCalendarDataSource, FSCalendarDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateAndYearLabel: UILabel!
    @IBOutlet weak var bookSessionCalendar: FSCalendar!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var sessionCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var availableSessionsLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var empthyView: dateSportView!
    @IBOutlet weak var collecctionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var updateButtonHeightConsteraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatMessageView: UIView!
    @IBOutlet weak var videoAudioView: UIView!
    @IBOutlet weak var instructionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionLabelTherapist: UILabel!
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var audioVideoTitleLabel: UILabel!
    @IBOutlet weak var audioVideoColorView: dateSportView!
    @IBOutlet weak var chatTitleLabelView: UILabel!
    @IBOutlet weak var chatColorView: dateSportView!
    //   var sessionItem : Observable<[AvailableSessionsData]>!
    var psychologistDetailModel:PsychologistsDataModel? = nil
    var psychologistSessionAvailabilityModel:PsychologistSessionAvailabilityModel? = nil
    //MARK:Object Declration with initilization
    var disposeBag = DisposeBag()
    var isFromRequest: Bool = false
    var isFromPastRequest: Bool = false
    var isFromPastBookRequest: Bool = false
    var appointmentDeatilModel :AppointmentDataModel?
   

    var availableSessionLocalArray = [AvailableSessionsData]()
    var monthlySessionLocalArray = [MonthlySlotsModel]()
    var requestModel:RequestModel?
    
    var bookedSessionLocalArray = [String]()
    var selectedDate = String()
    var selectedTime = String()
    var isFromEdit: Bool = false
    var isFromFree: Bool = false
    var sessionType = Int()
    var editPsychologistId: Int = 0
    var sessionId: Int = 0
    var currentMonthDate = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSessionCalendar.semanticContentAttribute = .forceLeftToRight
        sessionCollectionView.semanticContentAttribute = .forceLeftToRight
        self.setupCalendar()
        let today = Date()
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE)
        {
            selectedDate = today.toStringLoccal(dateFormat: YYYY_MM_DD)
        }else{
            selectedDate = today.toString(dateFormat: YYYY_MM_DD)
        }
        currentMonthDate = today.toString(dateFormat: YYYY_MM)
        dateAndYearLabel.text = today.toString(dateFormat: "MMMM YYYY")
        initalizedDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        bookSessionCalendar.semanticContentAttribute = .forceLeftToRight
        bookSessionCalendar.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        //  bookSessionCalendar.calendarWeekdayView.semanticContentAttribute = .forceLeftToRisght
        bookSessionCalendar.locale =  Locale(identifier: "en")
        //        bookSessionCalendar.collectionView.semanticContentAttribute = .forceLeftToRight
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
        mainScrollView.flashScrollIndicators()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        //        sessionItem = nil
        //        disposeBag = DisposeBag()
    }
    
    @objc func appBecomeActive() {
        print("App become active")
        setupCalendar()
        //        sessionItem = nil
        //        disposeBag = DisposeBag()
        getAvailabilitySession()
        //        self.collectionViewDidSelect()
    }
    
    func setupCalendar(){
        bookSessionCalendar.dataSource = self
        bookSessionCalendar.appearance.headerMinimumDissolvedAlpha = 0
        bookSessionCalendar.locale  = Locale(identifier: "en_US_POSIX")
        
        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
            let dateComponentsFormatter = DateComponentsFormatter()
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "en_US_POSIX")
            dateComponentsFormatter.calendar = calendar
            dateComponentsFormatter.unitsStyle = .full
            var monthStr = calendar.monthSymbols[monthInt]
            if(monthInt == (calendar.monthSymbols.count)){
                monthStr = calendar.monthSymbols[0]
            }else{
                monthStr = calendar.monthSymbols[monthInt]
            }
            if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
            nextMonthButton.setTitle(monthStr, for: .normal)
                previousMonthButton.setTitle("", for: .normal)
            }else{
                previousMonthButton.setTitle(monthStr, for: .normal)
                nextMonthButton.setTitle("", for: .normal)
            }
        }
        self.bookSessionCalendar.appearance.titleFont     = UIFont.init(name: "Quicksand-SemiBold", size: 15)
        self.bookSessionCalendar.appearance.weekdayFont          = UIFont.init(name: "Quicksand-Bold", size: 14)
        self.bookSessionCalendar.appearance.headerTitleFont             = UIFont.init(name: "Quicksand-SemiBold", size: 16)
        sessionCollectionView.register(UINib(nibName: "AvailableTimeCell", bundle: nil), forCellWithReuseIdentifier: "AvailableTimeCell")
        bookSessionCalendar.semanticContentAttribute = .forceLeftToRight
    }
    func initalizedDetails(){
        scrollViewBottomConstraint.constant = 24
        updateButtonHeightConsteraint.constant = 50
        buttonViewHeightConstraint.constant = 50
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if uesrRole == 1{
            if(isFromEdit){
                buttonView.isHidden = false
            }else{
                buttonView.isHidden = true
                scrollViewBottomConstraint.constant = 0
                updateButtonHeightConsteraint.constant = 0
                buttonViewHeightConstraint.constant = 0
            }
            instructionLabelHeightConstraint.constant = 0
            instructionLabelTherapist.isHidden = true
            availableSessionsLabel.text = Utility.getLocalizdString(value: "AVAILABLE_SESSIONS")
            updateButton.isHidden = true
            titleLabel.text = Utility.getLocalizdString(value: "SELECT_DATE_TIME")
        }else{
            instructionLabelTherapist.isHidden = false
            instructionLabelHeightConstraint.constant = 40
            titleLabel.text = Utility.getLocalizdString(value: "UPDATE_AVAILABILITY")
            availableSessionsLabel.text = Utility.getLocalizdString(value: "YOUR_SESSION")
        }
        self.getAvailabilityMonthlySession(date: self.currentMonthDate)
        getAvailabilitySession()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableSessionLocalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data =  availableSessionLocalArray[indexPath.row]
        let cell = self.sessionCollectionView.dequeueReusableCell(withReuseIdentifier: "AvailableTimeCell", for: indexPath) as! AvailableTimeCell
        cell.timeLabel.text = Utility.stringDatetoStringDateWithDifferentFormate(dateString: data.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: HHMMA)
        let currentTime = "\(Date().string(format: YYYY_MM_DD)) \(Utility.dateFormatting())"
        let dateDiff = Utility.findDateDiff(time1Str: Utility.stringDatetoStringDateWithDifferentFormate(dateString: data.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM), time2Str: currentTime,selectedDate: self.selectedDate,dateFormate: YYYY_MM_DDAMPM)
        if(dateDiff){
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                if(data.isAvailable == true){
                    cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    if(data.isFree == true){
                        cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                    if(data.type == 1){
                        cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }else if(data.type == 2){
                        cell.bgView.backgroundColor = #colorLiteral(red: 0.5461700559, green: 0.4999729991, blue: 0.7512809634, alpha: 1)
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }else if(data.type == 3){
                        cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                }else{
                    cell.bgView.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.6352941176, blue: 0.6470588235, alpha: 1)
                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                if(self.isFromEdit == true){
                    if(data.rearrangedSelected == true){
                        cell.bgView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                        
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                }
            }else{
                if(data.isBooked == true){
                    cell.bgView.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.6352941176, blue: 0.6470588235, alpha: 1)
                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }else{
                    if(data.isAvailable == true){
                        cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                        cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        if(data.isFree == true){
                            cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                        }
                        if(data.type == 1){
                            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        }else if(data.type == 2){
                            cell.bgView.backgroundColor = #colorLiteral(red: 0.5461700559, green: 0.4999729991, blue: 0.7512809634, alpha: 1)
                            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        }else if(data.type == 3){
                            cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        }
                        
                    }else{
                        cell.bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        cell.timeLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
                    }
                }
            }
        }else{
            cell.bgView.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.6352941176, blue: 0.6470588235, alpha: 1)
            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
    }
    //MARK: Load Month Table
    //    func loadSessionTable(){
    //        // Set automatic dimensions for row height
    //        sessionCollectionView.dataSource = nil
    //
    //        sessionItem.asObservable().bind(to: self.sessionCollectionView.rx.items(cellIdentifier: "AvailableTimeCell", cellType: AvailableTimeCell.self)){ row, data, cell in
    //
    //        }.disposed(by: disposeBag)
    //        DispatchQueue.main.async{
    //            let height = self.sessionCollectionView.collectionViewLayout.collectionViewContentSize.height
    //            self.collecctionViewHeightConstraint.constant = height
    //        }
    //
    //        self.view.setNeedsLayout()
    ////        Or self.view.layoutIfNeeded()
    //    }
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //       return "srk"
    //    }
    
    //    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
    //        return true
    //    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //          return 1
        let dateString = date.toString(dateFormat: "yyyy-MM-dd")
        let index = monthlySessionLocalArray.firstIndex{$0.date == dateString} // 0
        if(index != nil){
            if(index!<monthlySessionLocalArray.count){
                let monthlyObject = monthlySessionLocalArray[index!]
                if monthlyObject.date  == dateString {
                    if(monthlyObject.isSlotAdded!){
                        return 1
                    }else{
                        return 0
                    }
                }
            }
        }
        return 0
    }
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    //        let dateString = date.toString(dateFormat: "yyyy-MM-dd")
    //        let index = monthlySessionLocalArray.firstIndex{$0.date == dateString} // 0
    //        if(index!<monthlySessionLocalArray.count){
    //            let monthlyObject = monthlySessionLocalArray[index!]
    //            if monthlyObject.date  == dateString {
    //                if(monthlyObject.isSlotAdded!){
    //                return [UIColor.green]
    //                }else{
    //                    return [UIColor.clear]
    //                }
    //            }
    //        }
    //        return [UIColor.clear]
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = availableSessionLocalArray[indexPath.row]
        if let cell = self.sessionCollectionView.cellForItem(at: indexPath) as? AvailableTimeCell{
            
            let currentTime = "\(Date().string(format: YYYY_MM_DD)) \(Utility.dateFormatting())"
            let dateDiff = Utility.findDateDiff(time1Str: Utility.stringDatetoStringDateWithDifferentFormate(dateString: model.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM), time2Str: currentTime,selectedDate: self.selectedDate,dateFormate: YYYY_MM_DDAMPM)
            //                    let currentTime = Utility.dateFormatting()
            //                    let dateDiff = Utility.findDateDiff(time1Str: model.session!, time2Str: currentTime, selectedDate: self.selectedDate)
            if(dateDiff){
                uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                if(uesrRole == 1){
                    if(model.isAvailable == true){
                        //                                if(self.checckSlotAvailbleForbook(indexPath:indexPath)){
                        if(!self.isFromEdit){
                            if(model.type == 1){
                                cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                            }else if(model.type == 2){
                                cell.bgView.backgroundColor = #colorLiteral(red: 0.5461700559, green: 0.4999729991, blue: 0.7512809634, alpha: 1)
                            }else if(model.type == 3){
                                cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                            }
                            //                                if(model.isFree!){
                            //                                    cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                            //
                            //                                }else{
                            //                                    cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                            //                                }
                            self.selectedTime = model.session!
                            
                            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
                            let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "SelectTypeOfSessionScreen") as! SelectTypeOfSessionScreen
                            confirmAlertController.modalPresentationStyle = .overFullScreen
                            confirmAlertController.delegate = self
                            confirmAlertController.psychologistDetailModel = self.psychologistDetailModel
                            confirmAlertController.type = model.type!
                            confirmAlertController.isFree = model.isFree!
                            confirmAlertController.selectedDate = self.selectedDate
                            confirmAlertController.psychologistSessionAvailabilityModel = self.psychologistSessionAvailabilityModel
                            confirmAlertController.selectedTime = model.session!
                            confirmAlertController.onDoneBlock = { result in
                                // Do something
                                if(result){
                                    self.sessionCollectionView.reloadData()
                                    DispatchQueue.main.async{
                                        let height = self.sessionCollectionView.collectionViewLayout.collectionViewContentSize.height
                                        self.collecctionViewHeightConstraint.constant = height
                                    }
                                    
                                    self.view.setNeedsLayout()
                                }
                            }
                            self.present(confirmAlertController, animated: true, completion: nil)
                        }else{
                            
                            if(sessionType != model.type){
                                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "APPINTMENT_TYPE_MISSMATCH"))
                                return
                            }
                            if(model.isFree!){
                                if(!isFromFree){
                                    Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "APPINTMENT_TYPE_MISSMATCH"))
                                    return
                                }
                                cell.bgView.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                                
                            }else{
                                if(isFromFree){
                                    Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "APPINTMENT_TYPE_MISSMATCH"))
                                    return
                                }
                                cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                            }
                            
                            self.selectedTime = model.session!
                            
                            cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            for i in 0...self.availableSessionLocalArray.count-1{
                                let availbleSessionObject = self.availableSessionLocalArray[i]
                                availbleSessionObject.rearrangedSelected = false
                            }
                            model.rearrangedSelected = true
                            self.sessionCollectionView.reloadData()
                            DispatchQueue.main.async{
                                let height = self.sessionCollectionView.collectionViewLayout.collectionViewContentSize.height
                                self.collecctionViewHeightConstraint.constant = height
                            }
                            
                            self.view.setNeedsLayout()
                        }
                        //                                }
                        //                                else{
                        //                                    let refreshAlert = UIAlertController(title: "Not Allowed", message: "You have to select the slots with minimum 1 hour difference in between.", preferredStyle: UIAlertController.Style.alert)
                        //
                        //                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        //
                        //                                    }))
                        //
                        //                                    self.present(refreshAlert, animated: true, completion: nil)
                        //                                }
                    }
                }else{
                    if(self.checckSlotAvailbleForbook(indexPath:indexPath)){
                        if(model.isBooked != true){
                            
                            if(isFromRequest){
                                let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
                                let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "SelectTypeOfSessionScreen") as! SelectTypeOfSessionScreen
                                confirmAlertController.modalPresentationStyle = .overFullScreen
                                confirmAlertController.delegate = self
                                confirmAlertController.psychologistDetailModel = self.psychologistDetailModel
                                confirmAlertController.isFromPastRequest = self.isFromPastRequest
                                confirmAlertController.type = model.type!
                                confirmAlertController.isFree = model.isFree!
                                confirmAlertController.selectedDate = self.selectedDate
                                confirmAlertController.psychologistSessionAvailabilityModel = self.psychologistSessionAvailabilityModel
                                confirmAlertController.requestModel = self.requestModel
                                confirmAlertController.isFromPastBookRequest = self.isFromPastBookRequest
                                confirmAlertController.appointmentDeatilModel = self.appointmentDeatilModel
                                confirmAlertController.isFromRequest = true
                                confirmAlertController.selectedTime = model.session!
                                confirmAlertController.onDoneBlock = { result in
                                    // Do something
                                    if(result){
                                        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                                        let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                                        self.navigationController?.pushViewController(control, animated: true)
                                    }
                                }
                                self.present(confirmAlertController, animated: true, completion: nil)
                            }else{
                                //                            if(model.isAvailable == true){
                                print(self.psychologistSessionAvailabilityModel?.services)
                                model.type = model.type! + 1
                                if((self.psychologistSessionAvailabilityModel?.services)!.contains(2) || (self.psychologistSessionAvailabilityModel?.services)!.contains(3)){
                                    //                                    if( model.type! > 1){
                                    //                                        model.type = model.type! - 1
                                    //                                    }
                                }else{
                                    if( model.type! == 1){
                                        model.type = model.type! + 1
                                    }
                                }
                                if((self.psychologistSessionAvailabilityModel?.services)!.contains(1)){
                                    //                                    if( model.type! >= 2){
                                    //                                        model.type = model.type! - 1
                                    //                                    }
                                }else{
                                    if( model.type! >= 2){
                                        model.type =  model.type! + 1
                                    }
                                }
                                if(model.type == 1){
                                    model.isFree = false
                                    model.isAvailable = true
                                    cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                    
                                }else if(model.type == 2){
                                    model.isFree = false
                                    model.isAvailable = true
                                    cell.bgView.backgroundColor = #colorLiteral(red: 0.5461700559, green: 0.4999729991, blue: 0.7512809634, alpha: 1)
                                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                    
                                }else if(model.type == 3){
                                    model.isFree = true
                                    model.isAvailable = true
                                    cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                }else{
                                    cell.bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                    cell.timeLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
                                    model.isAvailable = false
                                    model.type = 0
                                }
                            }
                            //
                            //                                if(model.isFree == true){
                            //                                    model.isAvailable = false
                            //                                    model.isFree = false
                            //                                    cell.bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                            //                                    cell.timeLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
                            //                                }
                            //                                else{
                            //                                    cell.bgView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.6705882353, blue: 0.9098039216, alpha: 1)
                            //
                            //                                    model.isAvailable = true
                            //                                    model.isFree = true
                            //                                    cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            //                                }
                            //                            }else{
                            //                                cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                            //                                cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            //                                model.isAvailable = true
                            //                            }
                        }
                    }else{
                        let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "NOT_ALLOWED"), message: Utility.getLocalizdString(value: "SELET_SLOAT_WITH_MINIMUM_ONE_HOUR_GAP"), preferredStyle: UIAlertController.Style.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "OK"), style: .default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            }else{
                cell.bgView.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.6352941176, blue: 0.6470588235, alpha: 1)
                cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    //    func collectionViewDidSelect(){
    //        Observable
    //            .zip(
    //                sessionCollectionView
    //                    .rx
    //                    .itemSelected
    //                ,sessionCollectionView
    //                    .rx
    //                    .modelSelected(AvailableSessionsData.self)
    //        )
    //            .bind{ [unowned self] indexPath, model in
    //
    //        }
    //        .disposed(by: disposeBag)
    //    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func checckSlotAvailbleForbook(indexPath:IndexPath) -> Bool{
        var previousCell: AvailableTimeCell? = nil
        var nextCell: AvailableTimeCell? = nil
        previousCell = self.sessionCollectionView.cellForItem(at: IndexPath(row: indexPath.row - 1, section: 0)) as? AvailableTimeCell
        if(indexPath.row != 0 && previousCell != nil){
            
            let previousObject = self.availableSessionLocalArray[indexPath.row-1]
            if(previousObject.isBooked!){
                return false
            }
            let currentTime = "\(Date().string(format: YYYY_MM_DD)) \(Utility.dateFormatting())"
            let dateDiff = Utility.findDateDiff(time1Str: Utility.stringDatetoStringDateWithDifferentFormate(dateString: previousObject.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM), time2Str: currentTime,selectedDate: self.selectedDate,dateFormate: YYYY_MM_DDAMPM)
            if(dateDiff){
                previousObject.isAvailable = false
                previousObject.isFree = false
                previousCell!.bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                previousCell!.timeLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
            }
        }else{
            if(psychologistSessionAvailabilityModel?.isPreviousSessionAvailable == true){
                return false
            }else{
                
            }
        }
        
        nextCell = self.sessionCollectionView.cellForItem(at: IndexPath(row: indexPath.row + 1, section: 0)) as? AvailableTimeCell
        if indexPath.row != self.availableSessionLocalArray.count - 1 && nextCell != nil{
            
            let nextObject = self.availableSessionLocalArray[indexPath.row+1]
            if(nextObject.isBooked!){
                return false
            }else{
                let currentTime = "\(Date().string(format: YYYY_MM_DD)) \(Utility.dateFormatting())"
                let dateDiff = Utility.findDateDiff(time1Str: Utility.stringDatetoStringDateWithDifferentFormate(dateString: nextObject.session!, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM), time2Str: currentTime,selectedDate: self.selectedDate,dateFormate: YYYY_MM_DDAMPM)
                if(dateDiff){
                    nextObject.isAvailable = false
                    nextObject.isFree = false
                    nextCell!.bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    nextCell!.timeLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
                    return  true
                }
            }
        }else{
            if(psychologistSessionAvailabilityModel?.isNextSessionAvailable == true){
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    @IBAction func onUpdate(_ sender: UIButton) {
        if(self.availableSessionLocalArray.count > 0){
            for index in 0...self.availableSessionLocalArray.count-1{
                let sessionObject = self.availableSessionLocalArray[index]
                sessionObject.session = Utility.localToUTC(date: "\(sessionObject.session!)", fromFormat:YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
            }
            
            let sunDataArray = availableSessionLocalArray.toJSONString()
            
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                if Utility.isInternetAvailable(){
                    Utility.showIndicator()
                    let finalDate = "\(selectedDate) \(Utility.getCurrentTime())"
                    let parameters = ["sessions":sunDataArray ?? "",
                                      "version": "v2",
                                      DATE:Utility.localToUTC(date: finalDate, fromFormat: YYYY_MM_DDAMPM, toFormat: YYYY_MM_DD)] as [String : Any]
                    SessionServices.shared.updateSession(parameters: parameters, success: { (statusCode, sessionAvailabilityModel) in
                        Utility.hideIndicator()
                        
                        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                            do{
                                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                    if(loginDetails.data?.userInfo?.isSessionsAdded == 0){
                                        loginDetails.data?.userInfo?.isSessionsAdded = 1
                                        do{
                                            let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                            UserDefaults.standard.set(data, forKey: USER_DETAILS)
                                            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                                            let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                                            self.navigationController?.pushViewController(control, animated: true)
                                        }catch{
                                            print(error)
                                        }
                                    }else{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }catch{}
                        }
                        
                        //                        self.availableSessionLocalArray = []
                        //                        self.availableSessionLocalArray = sessionAvailabilityModel.data!
                        //                        if(self.availableSessionLocalArray.count>0){
                        //                            for index in 0...self.availableSessionLocalArray.count-1{
                        //                                let sessionObject = self.availableSessionLocalArray[index]
                        //                                sessionObject.session = Utility.UTCToLocal(date: sessionObject.session!, fromFormat: "HH:mm", toFormat: "hh:mma")
                        //                            }
                        //                        }
                        //                        self.loadSessionTable()
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
    
    
    @IBAction func onReschedule(_ sender: Any) {
        if(selectedTime == ""){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_SELECT_TIME"))
            return
        }
        self.onRescheduleSession()
    }
    
    func onRescheduleSession(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(RESCHEDULE_APPOINTMENT)\(sessionId)"
            let finalDate = "\(selectedDate)"
            //            let finalConvertedDate = Utility.localToUTC(date: finalDate, fromFormat: YYYY_MM_DD, toFormat: YYYY_MM_DD)
            let parameters = [
                "appointmentDate":finalDate,
                "psychologistId":editPsychologistId,
                "session":Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)] as [String : Any]
            SessionServices.shared.rescheduleSession(parameters: parameters, url: url, success:{ (statusCode, commanModel) in
                Utility.hideIndicator()
                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: commanModel.message, preferredStyle: UIAlertController.Style.alert)
                NotificationCenter.default.post(name: Notification.Name("REFRESH_DATA"), object: nil, userInfo:nil)
                refreshAlert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "TELEHEALTH"))", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: AppointmentsScreen.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    })
                    
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
    
    @IBAction func onCancel(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ReasonOfCancellationScreen") as! ReasonOfCancellationScreen
        confirmAlertController.appointmentId = sessionId
        confirmAlertController.modalPresentationStyle = .overFullScreen
        confirmAlertController.controllerDismissed
            .subscribe(onNext: { [weak self] dismiss in
                if(dismiss){
                    for controller in (self?.navigationController!.viewControllers)! as Array {
                        if controller.isKind(of: AppointmentsScreen.self) {
                            self?.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }).disposed(by: disposeBag)
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAvailabilitySession(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(PSYCHOLOGIST_SESSION_AVAILABILITY)"
            var parameters = [:] as [String : Any]
            let finalDate = "\(selectedDate) \(Utility.getCurrentTime())"
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                var psychologistId = Int()
                if(isFromEdit){
                    psychologistId = editPsychologistId
                }else{
                    psychologistId = psychologistDetailModel?.id! ?? 0
                }
                parameters = [PSYCHOLOGIST_ID :psychologistId,
                              DATE:selectedDate,
                              "version": "v2"
                ] as [String : Any]
            }else{
                parameters = [
                    DATE:selectedDate,
                    "version": "v2"
                ] as [String : Any]
            }
            SessionServices.shared.getAvailabilitySession(parameters: parameters, url: url, success:{ (statusCode, sessionAvailabilityModel) in
                Utility.hideIndicator()
                self.availableSessionLocalArray = []
                self.psychologistSessionAvailabilityModel = sessionAvailabilityModel
                self.availableSessionLocalArray = sessionAvailabilityModel.data!
                if ((sessionAvailabilityModel.services)!.contains(1)){
                    //                    self.chatMessageView.isHidden = false
                    self.chatTitleLabelView.alpha = 1.0
                    self.chatColorView.alpha = 1.0
                }else{
                    //                    self.chatMessageView.isHidden = true
                    self.chatTitleLabelView.alpha = 0.5
                    self.chatColorView.alpha = 0.5
                }
                if ((sessionAvailabilityModel.services)!.contains(2) || (sessionAvailabilityModel.services)!.contains(3)){
                    //                    self.videoAudioView.isHidden = false
                    self.audioVideoColorView.alpha = 1.0
                    self.audioVideoTitleLabel.alpha = 1.0
                }else{
                    //                    self.videoAudioView.isHidden = true
                    self.audioVideoColorView.alpha = 0.5
                    self.audioVideoTitleLabel.alpha = 0.5
                }
                if(self.availableSessionLocalArray.count == 0){
                    self.empthyView.isHidden = false
                }else{
                    self.empthyView.isHidden = true
                }
                
                self.psychologistSessionAvailabilityModel = sessionAvailabilityModel
                let dateFormatter = DateFormatter()
                
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = YYYY_MM_DDHHMMSS
                
                let sortedArray = self.availableSessionLocalArray.sorted { dateFormatter.date(from: $0.session!)! < dateFormatter.date(from: $1.session!)! }
                self.availableSessionLocalArray = sortedArray
                //                self.sessionItem = Observable.just(sortedArray)
                
                //                if(self.availableSessionLocalArray.count>0){
                ////                    for index in 0...self.availableSessionLocalArray.count-1{
                ////                        let sessionObject = self.availableSessionLocalArray[index]
                ////
                ////                        sessionObject.session = Utility.UTCToLocal(date: "\(sessionObject.session!)", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
                ////
                ////                    }
                //                }
                self.sessionCollectionView.reloadData()
                DispatchQueue.main.async{
                    let height = self.sessionCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.collecctionViewHeightConstraint.constant = height
                }
                
                self.view.setNeedsLayout()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func getAvailabilityMonthlySession(date:String){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            var parameters = [:] as [String : Any]
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
            if(uesrRole == 1){
                var psychologistId = Int()
                if(isFromEdit){
                    psychologistId = editPsychologistId
                }else{
                    psychologistId = psychologistDetailModel?.id! ?? 0
                }
                parameters = [PSYCHOLOGIST_ID :psychologistId,
                              DATE:date
                ] as [String : Any]
            }else{
                parameters = [
                    DATE:date
                ] as [String : Any]
            }
            SessionServices.shared.getAvailabilityMonthlySession(parameters: parameters, success:{ [self] (statusCode, sessionAvailabilityModel) in
                Utility.hideIndicator()
                self.monthlySessionLocalArray = []
                self.monthlySessionLocalArray = sessionAvailabilityModel.data!
                
                self.bookSessionCalendar.reloadData()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.toString(dateFormat: "yyyy-MM-dd")
        selectedTime = ""
        if(date != Date()){
            self.getAvailabilitySession()
        }
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("changed")
        let currentPageDate = calendar.currentPage
        
        print(currentPageDate)
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        
        //        getAvailabilityMonthlySession(date: "\(month)-\(year)")
        let strDate = "\(year)-\(month)-01"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = YYYY_MM_DD
        let newDate = dateFormatter.date(from: strDate)
        dateAndYearLabel.text = newDate!.toString(dateFormat: "MMMM YYYY")
        
        selectedDate = newDate!.toString(dateFormat: YYYY_MM_DD)
        getAvailabilityMonthlySession(date:  newDate!.toString(dateFormat: YYYY_MM))
        //        self.bookSessionCalendar.select(newDate)
        //        let calendar = Calendar.autoupdatingCurrent
        var nextMonth = String()
        var PreviosMonth = String()
        //        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
        //        if month == 12 {
        //            nextMonth  = Calendar.current.monthSymbols[0]
        //            PreviosMonth  = Calendar.current.monthSymbols[month-2]
        //        }else{
        //            nextMonth  = Calendar.current.monthSymbols[month]
        //            if(month == 0){
        //                PreviosMonth  = Calendar.current.monthSymbols[11]
        //            }else if(month == 1){
        //                PreviosMonth  = Calendar.current.monthSymbols[11]
        //            }else{
        //                PreviosMonth  = Calendar.current.monthSymbols[month-2]
        //            }
        //        }
        //        }else{
        let dateComponentsFormatter = DateComponentsFormatter()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        dateComponentsFormatter.calendar = calendar
        dateComponentsFormatter.unitsStyle = .full
        
        if month == 12 {
            nextMonth  = calendar.monthSymbols[0]
            PreviosMonth  = calendar.monthSymbols[month-2]
        }else{
            nextMonth  = calendar.monthSymbols[month]
            if(month == 0){
                PreviosMonth  = calendar.monthSymbols[11]
            }else if(month == 1){
                PreviosMonth  = calendar.monthSymbols[11]
            }else{
                PreviosMonth  = calendar.monthSymbols[month-2]
            }
        }
        //        }
        let current = calendar.dateComponents([.hour, .minute, .second, .nanosecond,.year,.month], from: NSDate() as Date)
        if(year >= current.year ?? 0){
            if(Utility.getCurrentLanguage()==ENGLISH_LANG_CODE){
            nextMonthButton.setTitle(nextMonth, for: .normal)
            previousMonthButton.setTitle(PreviosMonth, for: .normal)
            }else{
                previousMonthButton.setTitle(nextMonth, for: .normal)
                nextMonthButton.setTitle(PreviosMonth, for: .normal)
            }
                if(year  == current.year ?? 0){
                if(current.month ?? 0 <= month){
                    
                    if(current.month == month){
                        if(Utility.getCurrentLanguage()==ENGLISH_LANG_CODE){
                        previousMonthButton.setTitle("", for: .normal)
                        }else{
                            nextMonthButton.setTitle("", for: .normal)
                        }
                    }else{
                        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        previousMonthButton.setTitle(PreviosMonth, for: .normal)
                        }else{
                            nextMonthButton.setTitle(PreviosMonth, for: .normal)
                        }
                    }
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                    nextMonthButton.setTitle(nextMonth, for: .normal)
                    }else{
                        previousMonthButton.setTitle(nextMonth, for: .normal)
                    }
                }else{
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                    nextMonthButton.setTitle("", for: .normal)
                    previousMonthButton.setTitle("", for: .normal)
                    }else{
                        previousMonthButton.setTitle("", for: .normal)
                        nextMonthButton.setTitle("", for: .normal)
                    }
                }
            }else{
                if(current.month ?? 0 >= month){
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                    nextMonthButton.setTitle(nextMonth, for: .normal)
                    previousMonthButton.setTitle(PreviosMonth, for: .normal)
                    }else{
                        previousMonthButton.setTitle(nextMonth, for: .normal)
                        nextMonthButton.setTitle(PreviosMonth, for: .normal)
                    }
                }else{
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                    nextMonthButton.setTitle("", for: .normal)
                    previousMonthButton.setTitle("", for: .normal)
                    }else{
                        previousMonthButton.setTitle("", for: .normal)
                        nextMonthButton.setTitle("", for: .normal)
                    }
                }
            }
        }else{
            nextMonthButton.setTitle("", for: .normal)
            previousMonthButton.setTitle("", for: .normal)
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date){
        
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
        
    }
    
    func toStringLoccal( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
}

extension SelectSessionByUserScreen:selectedTimeOfSectionDelegate{
    func getSelectedTimeOfSectionData(type:Int,consultantType: Int,isFree:Bool){
        let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "AppointmentSessionScreen") as! AppointmentSessionScreen
        confirmAlertController.psychologistDetailModel = self.psychologistDetailModel
        confirmAlertController.selectedDate = self.selectedDate
        confirmAlertController.selectedTime = self.selectedTime
        confirmAlertController.service = "\(type)"
        confirmAlertController.selectedConsultant = consultantType
        confirmAlertController.isFree = isFree
        self.navigationController?.pushViewController(confirmAlertController, animated: true)
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension Date {
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
}
