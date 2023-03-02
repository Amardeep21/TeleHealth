//
//  AppointmentsScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppointmentSessionScreen: UIViewController {
    
    @IBOutlet weak var sucessBookingMessageLable: UILabel!
    @IBOutlet weak var paymentDoneView: UIView!
    @IBOutlet weak var paymentButton: dateSportButton!
    //MARK:UIImageView IBOutlet
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    //MARK:UILabel IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfSessionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var consultantTypeLabel: UILabel!
    
    @IBOutlet weak var failureView: UIView!
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    var psychologistDetailModel:PsychologistsDataModel? = nil
    var notificationModel:NotificationModel? = nil
    var isFromPayAndConfirm: Bool = false
    var selectedDate = String()
    var selectedTime = String()
    var selectedConsultant: Int = -1
    var service = String()
    var payment = String()
    var isFree = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialiseDetail()
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
    //MARK:Initialise Detail
    func initialiseDetail(){
        failureView.isHidden = true
        if(isFromPayAndConfirm){
            nameLabel.text = "\(notificationModel?.initialSession?.name ?? "")"
            dateLabel.text = Utility.stringDatetoStringDateWithDifferentFormate(dateString: notificationModel?.initialSession?.session ?? "", fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: MMMM_DD_YYYY)
            Utility.setImage(notificationModel?.initialSession?.profile, imageView: profileImageView)
//            timeLabel.text = "\(Utility.stringDatetoStringDateWithDifferentFormate(dateString: notificationModel?.initialSession?.session ?? "", fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: HHMMA))"
            timeLabel.text = Utility.UTCToLocal(date: notificationModel?.initialSession?.session ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            
            if(notificationModel?.initialSession?.services == "1"){
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "CHAT")
            }else if(notificationModel?.initialSession?.services == "2"){
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "AUDIO")
            }else {
                typeOfSessionLabel.text = Utility.getLocalizdString(value: "VIDEO")
            }
            consultantTypeLabel.text = Utility.getLocalizdString(value: "INDIVIDUALS")
            payment = notificationModel?.initialSession?.consultationPrice ?? ""
            paymentButton.setTitle("\(Utility.getLocalizdString(value: "PAY")) \(payment) KD", for: .normal)
            totalPaymentLabel.text = "\(payment) KD"
        }else{
            
        nameLabel.text = "\(psychologistDetailModel?.firstname ?? "") \(psychologistDetailModel?.lastname ?? "")"
        dateLabel.text = Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedDate, fromDateFormatter: YYYY_MM_DD, toDateFormatter: MMMM_DD_YYYY)
        Utility.setImage(psychologistDetailModel?.profile, imageView: profileImageView)
        
        timeLabel.text = "\(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedTime, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: HHMMA))"
        
        if(service == "1"){
            typeOfSessionLabel.text = Utility.getLocalizdString(value: "CHAT")
        }else if(service == "2"){
            typeOfSessionLabel.text = Utility.getLocalizdString(value: "AUDIO")
        }else {
            typeOfSessionLabel.text = Utility.getLocalizdString(value: "VIDEO")
        }
        if(isFree){
            payment = "0"
            if(selectedConsultant == INDIVIDUAL_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "INDIVIDUALS")
                //payment = psychologistDetailModel?.consultationPrice ?? ""
            }else if(selectedConsultant == COUPLE_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "COUPLE")
                //payment = psychologistDetailModel?.coupleConsultationPrice ?? ""
            }else if(selectedConsultant == FAMILY_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "FAMILY")
                //  payment = psychologistDetailModel?.familyConsultationPrice ?? ""
            }
        }else{
            if(selectedConsultant == INDIVIDUAL_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "INDIVIDUALS")
                payment = psychologistDetailModel?.consultationPrice ?? ""
            }else if(selectedConsultant == COUPLE_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "COUPLE")
                payment = psychologistDetailModel?.coupleConsultationPrice ?? ""
            }else if(selectedConsultant == FAMILY_COUNSELLING){
                consultantTypeLabel.text = Utility.getLocalizdString(value: "FAMILY")
                payment = psychologistDetailModel?.familyConsultationPrice ?? ""
            }
            if(service == "1"){
                payment = psychologistDetailModel?.chatConsultationPrice ?? ""
            }
        }
        if(isFree){
            paymentButton.setTitle(Utility.getLocalizdString(value: "BOOK_NOW"), for: .normal)
        }else{
            paymentButton.setTitle("\(Utility.getLocalizdString(value: "PAY")) \(payment) KD", for: .normal)
        }
        totalPaymentLabel.text = "\(payment) KD"
        if(isFree){
            payment = "0"
        }
        }
    }
    
    @IBAction func onProfile(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = (psychologistDetailModel?.profile ?? "") 
        
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    //MARK: Load Payment method Table
    //    func loadPaymentMethodTable(){
    //        // Set automatic dimensions for row height
    //        paymentMethodTableView.dataSource = nil
    //        paymentItem = Observable.just(paymentMethodNameArray)
    //        paymentItem.bind(to: paymentMethodTableView.rx.items(cellIdentifier: "PaymentMethodTableCell", cellType:PaymentMethodCell.self)){(row,item,cell) in
    //            print(item)
    //            cell.selectionStyle = .none
    //            cell.paymentNameLabel.text = self.paymentMethodNameArray[row]
    //            cell.paymentIconImageView.image = UIImage(named: self.paymentMethodImageArray[row])
    //        }.disposed(by: disposeBag)
    //
    ////        paymentMethodTableView.rx.itemSelected.subscribe(onNext : {
    ////            [weak self] indexPath in
    ////            if let cell = self?.paymentMethodTableView.cellForRow(at: indexPath) as? PaymentMethodCell {
    ////                if(cell.tapButton.isSelected)
    ////                {
    ////                    cell.tapButton.isSelected = false
    ////                    cell.dotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
    ////                    cell.dotLabel.layer.borderWidth = 0.0
    ////                }
    ////                else
    ////                {
    ////                    cell.tapButton.isSelected = true
    ////                    cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    ////                    cell.dotLabel.layer.borderWidth = 0.5
    ////                }
    ////            }
    ////        }).disposed(by: disposeBag)
    //    }
    
    //MARK:UIButton Action
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onPay(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "CONFIRMATION"), message: Utility.getLocalizdString(value: "VERIFY_APPOINTMENT_MESSAGE"), preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CONFIRMED"), style: .cancel, handler: { (action: UIAlertAction!) in
            self.checkSessionAvaibleOrNot()
          }))

        refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "EDIT"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
          }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func onTryAgain(_ sender: Any) {
        failureView.isHidden = true
    }
    
    func presentHesabeGateway(paymentRequest: PaymentRequest) {
        let vc = HesabeGatewayVC()
        vc.paymentRequest = paymentRequest
        
        vc.modalPresentationStyle = .overFullScreen // to avoid dafault popover presentation
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    //      func paymentResponse(response: PaymentResponse) {
    //        print("PaymentResponse",response)
    //      }
    func hesabeResponse(paymentResponse: PaymentResponse,stringResponse:String) {
        let data = paymentResponse.response
        if(paymentResponse.status){
            self.onPayment(response: stringResponse)
        }else{
            self.failureView.isHidden = false
        }
    }
    
    func hesabefailureResponse(error:String){
        Utility.showAlert(vc: self, message: error)
    }
    
    func checkSessionAvaibleOrNot(response: String = ""){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                var parameters = [String:Any]()
                if(isFromPayAndConfirm){
                    
                    parameters = [APPOINTMENT_DATE:Utility.stringDatetoStringDateWithDifferentFormate(dateString: notificationModel?.initialSession?.session ?? "", fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DD),
                                  PSYCHOLOGIST_ID:notificationModel?.initialSession?.psychologistId ?? 0,
                                  SESSION:notificationModel?.initialSession?.session ?? "",
                                  "requestId":notificationModel?.initialSession?.requestId ?? 0,
                    ] as [String : Any]
                }else{
                let finalDate = "\(selectedDate)"
                parameters = [APPOINTMENT_DATE:finalDate,
                                  PSYCHOLOGIST_ID:psychologistDetailModel?.id! ?? 0,
                                  SESSION:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                ] as [String : Any]
                }
                AppointmentServices.shared.checkAppointmentAvailiblity(parameters: parameters,success: { [self] (statusCode, commanModel) in
                    if(isFree){
                        self.onPayment()
                    }else{
                        var paymentRequest = PaymentRequest(amount: payment)
                        let uuid = UUID().uuidString
                        paymentRequest?.orderReferenceNumber = uuid
                        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                            do{
                                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                    paymentRequest?.variable1 = "\(loginDetails.data?.id ?? 0)"
                                    
                                }
                            }catch{}
                        }
                        paymentRequest?.variable2 = "\(psychologistDetailModel?.id! ?? 0)"
                        paymentRequest?.variable3 = Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                        self.presentHesabeGateway(paymentRequest: paymentRequest!)
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
    func onPayment(response: String = ""){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                var parameters = [String:Any]()
                if(isFromPayAndConfirm){
                   
                    parameters = [APPOINTMENT_DATE:Utility.stringDatetoStringDateWithDifferentFormate(dateString: notificationModel?.initialSession?.session ?? "", fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DD),
                                  PSYCHOLOGIST_ID:notificationModel?.initialSession?.psychologistId! ?? 0,
                                  SESSION:notificationModel?.initialSession?.session ?? "",
                                      SERVICES:notificationModel?.initialSession?.services ?? 1,
                                      "paymentResponse":response,
                                      "consultantType":1,
                                      "consultationPrice":payment,
                                      "requestId":notificationModel?.initialSession?.requestId ?? 0,
                                      
                    ] as [String : Any]
                }else{
                    let finalDate = "\(selectedDate)"
                     parameters = [APPOINTMENT_DATE:finalDate,
                                      PSYCHOLOGIST_ID:psychologistDetailModel?.id! ?? 0,
                                      SESSION:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS),
                                      SERVICES:service,
                                      "paymentResponse":response,
                                      "consultantType":selectedConsultant,
                                      "consultationPrice":payment
                    ] as [String : Any]
                }
               
                
                AppointmentServices.shared.appointMentBooking(parameters: parameters, success: { (statusCode, commanModel) in
                    Utility.hideIndicator()
                    self.paymentDoneView.isHidden = false
                    self.sucessBookingMessageLable.text = commanModel.message!
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
