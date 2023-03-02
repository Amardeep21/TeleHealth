
//
//  AvailableSessionScreen.swift
//  telehealth
//
//  Created by iroid on 18/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class AvailableSessionScreen: UIViewController {
    
    //MARK:UICollectionView IBOutlet
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var sessionCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var everySessionLabel: UILabel!
    @IBOutlet weak var doneButton: dateSportButton!
    @IBOutlet weak var youCansSelectInstructionLabel: UILabel!
    
    //MARK: Variables
    var monthItem : Observable<[WeekNameInfo]>!
    var weekNameArray = [WeekNameInfo]()
    var sessionItem : Observable<[AvailableSessionsData]>!
    var sessionArray = [AvailableSessionsData]()
    var sunArray = [AvailableSessionsData]()
    var monArray = [AvailableSessionsData]()
    var tueArray = [AvailableSessionsData]()
    var wedArray = [AvailableSessionsData]()
    var thuArray = [AvailableSessionsData]()
    var friArray = [AvailableSessionsData]()
    var satArray = [AvailableSessionsData]()
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    var isFromAvailableSession = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionViewDidSelect()
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        for index in 0...weekNameArray.count-1{
            if(index == 0){
                if(monArray.count>0){
                    for subIndex in 0...monArray.count-1{
                        let object = monArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 1){
                if(tueArray.count>0){
                    for subIndex in 0...tueArray.count-1{
                        let object = tueArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 2){
                if(thuArray.count>0){
                    for subIndex in 0...thuArray.count-1{
                        let object = thuArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 3){
                if(wedArray.count>0){
                    for subIndex in 0...wedArray.count-1{
                        let object = wedArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 4){
                if(friArray.count>0){
                    for subIndex in 0...friArray.count-1{
                        let object = friArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 5){
                if(satArray.count>0){
                    for subIndex in 0...satArray.count-1{
                        let object = satArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }else if(index == 6){
                if(sunArray.count>0){
                    for subIndex in 0...sunArray.count-1{
                        let object = sunArray[subIndex]
                        object.session = Utility.localToUTC(date: object.session!, fromFormat: HHMMA, toFormat: HHMM)
                    }
                }
            }
        }
        
        let monDataArray =  monArray.toJSONString()
        let tueDataArray =  tueArray.toJSONString()
        let wedDataArray =  wedArray.toJSONString()
        let thuDataArray =  thuArray.toJSONString()
        let friDataArray =  friArray.toJSONString()
        let satDataArray = satArray.toJSONString()
        let sunDataArray = sunArray.toJSONString()
        
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                let parameters = [ "sessions[Sun]":sunDataArray!,
                                   "sessions[Mon]":monDataArray!,
                                   "sessions[Tue]":tueDataArray!,
                                   "sessions[Wed]":wedDataArray!,
                                   "sessions[Thu]":thuDataArray!,
                                   "sessions[Fri]":friDataArray!,
                                   "sessions[Sat]":satDataArray!] as [String : Any]
                
                PsychologistSelfServices.shared.addSession(parameters: parameters, success: { (statusCode, sessionModel) in
                    
                    Utility.hideIndicator()
                    //                           Utility.showAlert(vc: self, message: loginModel.message!)
                    
                    if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                        do{
                            if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                if(loginDetails.data?.userInfo?.isSessionsAdded != 0){
                                    self.navigationController?.popViewController(animated: true)
                                }else{
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
                                }
                            }
                        }catch{}
                    }
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
    
    //MARK:Initialise Detail
    func initialiseDetail(){
        //        monthNameArray = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        if(!isFromAvailableSession){
            backButton.isHidden = true
            self.doneButton.isHidden = true
            self.everySessionLabel.isHidden = true
            self.youCansSelectInstructionLabel.isHidden = false
            sunArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            monArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            tueArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            wedArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            thuArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            friArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            satArray = [
                AvailableSessionsData(session: TWELVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: ONEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TWOAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: THREEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FOURAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: FIVEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: SIXAM, isAvailable: false, isBooked: false),
                AvailableSessionsData(session: SEVENAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: EIGHTAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: NINEAM, isAvailable: false, isBooked: false),AvailableSessionsData(session: TENAM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ELEVENAM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWELVEPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: ONEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TWOPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: THREEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: FOURPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: FIVEPM,isAvailable:false,isBooked: false),AvailableSessionsData(session: SIXPM,isAvailable: false,isBooked: false),
                AvailableSessionsData(session: SEVENPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: EIGHTPM,isAvailable:false,isBooked: false),
                AvailableSessionsData(session: NINEPM,isAvailable: false,isBooked: false),AvailableSessionsData(session: TENPM,isAvailable: false,isBooked: false),
                AvailableSessionsData( session: ELEVENPM,isAvailable: false,isBooked: false)
            ]
            self.loadWeekObject()
        }
        else{
            backButton.isHidden = false
            self.getSessionData()
        }
        
        
        monthCollectionView.register(UINib(nibName: "MonthNameCell", bundle: nil), forCellWithReuseIdentifier: "MonthNameCell")
        sessionCollectionView.register(UINib(nibName: "AvailableTimeCell", bundle: nil), forCellWithReuseIdentifier: "AvailableTimeCell")
        loadMonthTable()
    }
    
    func getSessionData(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                PsychologistSelfServices.shared.getSessions( success: { (statusCode, sessionModel) in
                    Utility.hideIndicator()
                    self.sunArray = sessionModel.data?.Sun! as! [AvailableSessionsData]
                    self.monArray = sessionModel.data?.Mon! as! [AvailableSessionsData]
                    self.tueArray = sessionModel.data?.Tue as! [AvailableSessionsData]
                    self.thuArray = sessionModel.data?.Thu as! [AvailableSessionsData]
                    self.wedArray = sessionModel.data?.Wed as! [AvailableSessionsData]
                    self.friArray = sessionModel.data?.Fri as! [AvailableSessionsData]
                    self.satArray = sessionModel.data?.Sat as! [AvailableSessionsData]
                    for index in 0...6{
                        if(index == 0){
                            if(self.monArray.count>0){
                                for subIndex in 0...self.monArray.count-1{
                                    let object = self.monArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 1){
                            if(self.tueArray.count>0){
                                for subIndex in 0...self.tueArray.count-1{
                                    let object = self.tueArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 2){
                            if(self.thuArray.count>0){
                                for subIndex in 0...self.thuArray.count-1{
                                    let object = self.thuArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 3){
                            if(self.wedArray.count>0){
                                for subIndex in 0...self.wedArray.count-1{
                                    let object = self.wedArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 4){
                            if(self.friArray.count>0){
                                for subIndex in 0...self.friArray.count-1{
                                    let object = self.friArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 5){
                            if(self.satArray.count>0){
                                for subIndex in 0...self.satArray.count-1{
                                    let object = self.satArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }else if(index == 6){
                            if(self.sunArray.count>0){
                                for subIndex in 0...self.sunArray.count-1{
                                    let object = self.sunArray[subIndex]
                                    let currentDate = Date().toString(dateFormat: YYYY_MM_DD)
                                    object.session = Utility.UTCToLocal(date: "\(currentDate) \(object.session!)", fromFormat: YYYY_MM_DDHHMM, toFormat: HHMMA)
                                }
                            }
                        }
                    }
                    self.loadWeekObject()
                    self.loadMonthTable()
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
    
    func loadWeekObject(){
        weekNameArray = [
            WeekNameInfo(isSelected: false, timeArray: sunArray, weekNameTitle: "Sun"),
            WeekNameInfo(isSelected: false, timeArray: monArray, weekNameTitle: "Mon"),
            WeekNameInfo(isSelected: false, timeArray: tueArray, weekNameTitle: "Tue"),
            WeekNameInfo(isSelected: false, timeArray: wedArray, weekNameTitle: "Wed"),
            WeekNameInfo(isSelected: false, timeArray: thuArray, weekNameTitle: "Thu"),
            WeekNameInfo(isSelected: false, timeArray: friArray, weekNameTitle: "Fri"),
            WeekNameInfo(isSelected: false, timeArray: satArray, weekNameTitle: "Sat"),
        ]
    }
    
    func collectionViewDidSelect(){
        Observable
            .zip(
                monthCollectionView
                    .rx
                    .itemSelected
                ,monthCollectionView
                    .rx
                    .modelSelected(WeekNameInfo.self)
        )
            .bind{ [unowned self] indexPath, model in
                if let cell = self.monthCollectionView.cellForItem(at: indexPath) as? MonthNameCell{
                    cell.bgView.borderColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                    self.sessionArray = model.timeArray!
                    for weekArray in self.weekNameArray {
                        weekArray.setvalue(isSelected: false)
                    }
                    model.setvalue(isSelected: true)
                    if(model.isSelected == true){
                        cell.bgView.borderWidth = 0
                        cell.bgView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }else{
                        cell.bgView.borderWidth = 1.0
                        cell.bgView.borderColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                    }
                    self.loadMonthTable()
                }
        }
        .disposed(by: disposeBag)
        Observable
            .zip(
                sessionCollectionView
                    .rx
                    .itemSelected
                ,sessionCollectionView
                    .rx
                    .modelSelected(AvailableSessionsData.self)
        )
            .bind{ [unowned self] indexPath, model in
                if let cell = self.sessionCollectionView.cellForItem(at: indexPath) as? AvailableTimeCell {
                    let index =  self.weekNameArray.firstIndex(where: { $0.isSelected == true })
                    if(index == nil){
                        self.doneButton.isHidden = true
                        self.everySessionLabel.isHidden = true
                        self.youCansSelectInstructionLabel.isHidden = false
                        Utility.showAlert(vc: self, message: "Please select weekday")
                        return
                    }else{
                        self.doneButton.isHidden = false
                        self.everySessionLabel.isHidden = false
                        self.youCansSelectInstructionLabel.isHidden = true
                    }
                    if(model.isAvailable == true){
                        cell.bgView!.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        model.isAvailable = false
                    }else{
                        cell.bgView.backgroundColor =  #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                        model.isAvailable = true
                    }
                    self.loadMonthTable()
                }
        }
        .disposed(by: disposeBag)
    }
    
    //MARK: Load Month Table
    func loadMonthTable(){
        // Set automatic dimensions for row height
        monthCollectionView.dataSource = nil
        monthItem = Observable.just(weekNameArray)
        sessionCollectionView.dataSource = nil
        sessionItem = Observable.just(sessionArray)
        monthItem.asObservable().bind(to: self.monthCollectionView.rx.items(cellIdentifier: "MonthNameCell", cellType: MonthNameCell.self)){ row, data, cell in
            cell.monthLabel.text = data.weekNameTitle
            let index =  self.weekNameArray.firstIndex(where: { $0.isSelected == true })
            if(index == nil){
                self.doneButton.isHidden = true
                self.everySessionLabel.isHidden = true
                self.youCansSelectInstructionLabel.isHidden = false
            }else{
                self.doneButton.isHidden = false
                self.everySessionLabel.isHidden = false
                self.youCansSelectInstructionLabel.isHidden = true
            }
            let result = data.timeArray!.firstIndex(where: { $0.isAvailable == true })
            if result != nil {
                // found
                cell.bgView.backgroundColor =  #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                cell.monthLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // not
                cell.bgView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.monthLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            }
            if(data.isSelected!){
                cell.bgView.borderColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                cell.bgView.borderWidth = 1.0
            }else{
                cell.bgView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.bgView.borderWidth = 0
            }
        }.disposed(by: disposeBag)
        sessionItem.asObservable().bind(to: self.sessionCollectionView.rx.items(cellIdentifier: "AvailableTimeCell", cellType: AvailableTimeCell.self)){ row, data, cell in
            cell.timeLabel.text = data.session
            if(data.isAvailable == true){
                cell.bgView.backgroundColor =  #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                cell.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else{
                cell.bgView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.timeLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            }
        }.disposed(by: disposeBag)
    }
}

protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}
