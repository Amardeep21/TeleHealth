//
//  SelectTypeOfSessionScreen.swift
//  telehealth
//
//  Created by iroid on 19/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
protocol selectedTimeOfSectionDelegate: class {
    func getSelectedTimeOfSectionData(type:Int,consultantType: Int,isFree:Bool)
}
class SelectTypeOfSessionScreen: UIViewController {
    
    //MARK: UIImageView Outlets
    @IBOutlet weak var priceTextfield: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    
    @IBOutlet weak var paidViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paidImageView: UIImageView!
    @IBOutlet weak var freeRadioImageView: UIImageView!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var videoTransperantView: UIView!
    @IBOutlet weak var audioTransperantView: UIView!
    @IBOutlet weak var chatTransperantView: UIView!
    @IBOutlet weak var individualImageView: UIImageView!
    @IBOutlet weak var coupleImageView: UIImageView!
    @IBOutlet weak var familyImageView: UIImageView!
    
    //MARK: UIView Outlets
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var individualView: dateSportLabel!
    @IBOutlet weak var coupleView: dateSportLabel!
    @IBOutlet weak var familyView: dateSportLabel!
    
    //MARK: UILabel Outlets
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var chatLabe: UILabel!
    @IBOutlet weak var audioLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    //MARK: UIButton Outlets
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var individualPriceLabel: UILabel!
    @IBOutlet weak var familyPriceLabel: UILabel!
    @IBOutlet weak var couplePriceLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var typesOfSessionView: UIStackView!
    
    @IBOutlet weak var individualWholeView: UIView!
    @IBOutlet weak var coupleWholeView: UIView!
    @IBOutlet weak var familyWholeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var freePaidView: UIStackView!
    
    //MARK: Variables
    var sessionStatus = -1
    var delegate:selectedTimeOfSectionDelegate?
    var onDoneBlock : ((Bool) -> Void)?
    var selectedConsultant:Int = -1
    var psychologistDetailModel:PsychologistsDataModel? = nil
    var isFromPastRequest:Bool = false
    var selectedDate = String()
    var selectedTime = String()
    var isFromRequest: Bool = false
    var isSelectedFree:Bool = true
    var requestModel:RequestModel?
    var isFromPastBookRequest: Bool = false
    var appointmentDeatilModel :AppointmentDataModel?
    var psychologistSessionAvailabilityModel:PsychologistSessionAvailabilityModel?
    var isFree = Bool()
    var type = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isFromRequest){
            freePaidView.isHidden = false
            typesOfSessionView.isHidden = true
        }else{
            freePaidView.isHidden = true
            typesOfSessionView.isHidden = false
        }
        paidView.isHidden = true
        freeRadioImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        paidImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            if #available(iOS 11.0, *){
                chatView.clipsToBounds = false
                chatView.layer.cornerRadius = 10
                chatView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            }
            if #available(iOS 11.0, *){
                videoView.clipsToBounds = false
                videoView.layer.cornerRadius = 10
                videoView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }
        }else{
            if #available(iOS 11.0, *){
                chatView.clipsToBounds = false
                chatView.layer.cornerRadius = 10
                chatView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }
            if #available(iOS 11.0, *){
                videoView.clipsToBounds = false
                videoView.layer.cornerRadius = 10
                videoView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            }
        }
        
        
        if #available(iOS 11.0, *){
            mainView.clipsToBounds = false
            mainView.layer.cornerRadius = 15
            mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            //For lower versions
            let rectShape = CAShapeLayer()
            rectShape.bounds = mainView.frame
            rectShape.position = mainView.center
            rectShape.path = UIBezierPath(roundedRect: mainView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            mainView.layer.mask = rectShape
        }
        
        if !isFromRequest{
            dateAndTimeLabel.text = "\(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedDate, fromDateFormatter: YYYY_MM_DD, toDateFormatter: MMMM_DD_YYYY)) \(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedTime, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: HHMMA))"
            
            //          dateAndTimeLabel.text = "\(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedTime, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: YYYY_MM_DDAMPM))"
            if(isFree){
                individualPriceLabel.text = Utility.getLocalizdString(value: "INDIVIDUAL_FREE_CONSULTATION")
                couplePriceLabel.text = Utility.getLocalizdString(value: "COUPLE_FREE_CONSULTATION")
                familyPriceLabel.text = Utility.getLocalizdString(value: "FAMILY_FREE_CONSULTATION")
            }else{
                //            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "INDIVIDUALS")) (\(psychologistDetailModel?.consultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES")))"
                //            couplePriceLabel.text = "\(Utility.getLocalizdString(value: "COUPLE")) (\(psychologistDetailModel?.coupleConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES")))"
                //            familyPriceLabel.text = "\(Utility.getLocalizdString(value: "FAMILY")) (\(psychologistDetailModel?.familyConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES")))"
                if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                    individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
                    couplePriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_COUPLE")) \(psychologistDetailModel?.coupleConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
                    familyPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_FAMILY")) \(psychologistDetailModel?.familyConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
                    //                chatIndividualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.chatConsultationPrice ?? "") KD per 30 \(Utility.getLocalizdString(value: "MINUTES"))"
                }else{
                    individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"
                    couplePriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_COUPLE")) \(psychologistDetailModel?.coupleConsultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"
                    familyPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_FAMILY")) \(psychologistDetailModel?.familyConsultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"

                }
            }
            checkViewHideShow()
            if((psychologistSessionAvailabilityModel?.services)!.contains(1)){
                chatView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                chatView.isUserInteractionEnabled = true
            }else{
                chatView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                chatView.isUserInteractionEnabled = false
            }
            
            self.displayVisablityOfViews()
        }else{
            individualWholeView.isHidden = false
            familyWholeView.isHidden = true
            coupleWholeView.isHidden = true
            individualWholeView.isUserInteractionEnabled = false
            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "INDIVIDUALS"))"
            chatTransperantView.isHidden = true
            videoTransperantView.isHidden = true
            audioTransperantView.isHidden = true
            audioButton.isSelected = false
            videoButton.isSelected = false
            
            chatButton.isSelected = true
            sessionStatus = 1
            chatView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
            audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            chatLabe.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            
            chatImageView.image = UIImage(named: "white_chat_icon")
            videoImageView.image = UIImage(named: "video_black_icon")
            audioImageView.image = UIImage(named: "phone_black_icon")
            
            selectedConsultant = INDIVIDUAL_COUNSELLING
            
            individualImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            coupleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            familyImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            dateAndTimeLabel.text = "\(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedDate, fromDateFormatter: YYYY_MM_DD, toDateFormatter: MMMM_DD_YYYY)) \(Utility.stringDatetoStringDateWithDifferentFormate(dateString: selectedTime, fromDateFormatter: YYYY_MM_DDHHMMSS, toDateFormatter: HHMMA))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    func displayVisablityOfViews(){
        if(type == 1){
            if((psychologistSessionAvailabilityModel?.services)!.contains(3)){
                videoView.isUserInteractionEnabled = true
                videoTransperantView.isHidden = true
            }else{
                videoView.isUserInteractionEnabled = false
                videoTransperantView.isHidden = false
            }
            if((psychologistSessionAvailabilityModel?.services)!.contains(2)){
                audioView.isUserInteractionEnabled = true
                audioTransperantView.isHidden = true
                
            }else{
                audioView.isUserInteractionEnabled = false
                audioTransperantView.isHidden = false
            }
            
            chatView.isUserInteractionEnabled = false
            chatTransperantView.isHidden = false
        }else if(type == 2){
            if((psychologistSessionAvailabilityModel?.services)!.contains(1)){
                chatView.isUserInteractionEnabled = true
                chatTransperantView.isHidden = true
                
            }else{
                chatView.isUserInteractionEnabled = false
                chatTransperantView.isHidden = false
            }
            
            audioView.isUserInteractionEnabled = false
            audioTransperantView.isHidden = false
            videoView.isUserInteractionEnabled = false
            videoTransperantView.isHidden = false
            audioButton.isSelected = false
            videoButton.isSelected = false
            
            chatButton.isSelected = true
            sessionStatus = 1
            chatView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
            audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            chatLabe.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
            
            chatImageView.image = UIImage(named: "white_chat_icon")
            videoImageView.image = UIImage(named: "video_black_icon")
            audioImageView.image = UIImage(named: "phone_black_icon")
            if(psychologistDetailModel?.chatConsultationPrice == nil){
                individualWholeView.isHidden = true
            }else{
                
                individualWholeView.isHidden = false
                if(isFree){
                    individualPriceLabel.text = Utility.getLocalizdString(value: "INDIVIDUAL_FREE_CONSULTATION")
                }else{
                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        individualPriceLabel.text = "\(Utility.getLocalizdString(value: "INDIVIDUALS")) (\(psychologistDetailModel?.chatConsultationPrice ?? "") KD per 30 \(Utility.getLocalizdString(value: "MINUTES")))"
                    }else{
                        individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD لكل 30 \(Utility.getLocalizdString(value: "MINUTES"))"
                    }
                    
                }
            }
            coupleWholeView.isHidden = true
            familyWholeView.isHidden = true
            selectedConsultant = INDIVIDUAL_COUNSELLING
            
            individualImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            coupleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            familyImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            
            if(sessionStatus == 1){
                coupleWholeView.isHidden = true
                familyWholeView.isHidden = true
            }else{
                
                coupleWholeView.isHidden = false
                familyWholeView.isHidden = false
                self.checkViewHideShow()
            }
            chatButton.isUserInteractionEnabled = false
        }else{
            
            if((psychologistSessionAvailabilityModel?.services)!.contains(3)){
                videoView.isUserInteractionEnabled = true
                videoTransperantView.isHidden = true
            }else{
                videoView.isUserInteractionEnabled = false
                videoTransperantView.isHidden = false
            }
            if((psychologistSessionAvailabilityModel?.services)!.contains(2)){
                audioView.isUserInteractionEnabled = true
                audioTransperantView.isHidden = true
                
            }else{
                audioView.isUserInteractionEnabled = false
                audioTransperantView.isHidden = false
            }
            if((psychologistSessionAvailabilityModel?.services)!.contains(1)){
                chatView.isUserInteractionEnabled = true
                chatTransperantView.isHidden = true
                
            }else{
                chatView.isUserInteractionEnabled = false
                chatTransperantView.isHidden = false
            }
        }
        
        
    }
    
    func checkViewHideShow(checkChat:Bool = false){
        if(psychologistDetailModel?.consultationPrice == nil){
            individualWholeView.isHidden = true
            
        }else{
            individualWholeView.isHidden = false
        }
        
        if(psychologistDetailModel?.coupleConsultationPrice == nil){
            coupleWholeView.isHidden = true
        }else{
            coupleWholeView.isHidden = false
            
        }
        if(psychologistDetailModel?.familyConsultationPrice == nil){
            familyWholeView.isHidden = true
        }else{
            familyWholeView.isHidden = false
            
        }
        
    }
    
    //MARK: UIButton Actions
    @IBAction func onCancel(_ sender: UIButton) {
        if(!isFromRequest){
            onDoneBlock!(true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onChat(_ sender: UIButton) {
        if(isFromRequest){
            if sender.isSelected{
                sessionStatus = -1
                sender.isSelected = false
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                defaultImage()
            }else{
                audioButton.isSelected = false
                videoButton.isSelected = false
                
                sender.isSelected = true
                sessionStatus = 1
                chatView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatLabe.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                
                chatImageView.image = UIImage(named: "white_chat_icon")
                videoImageView.image = UIImage(named: "video_black_icon")
                audioImageView.image = UIImage(named: "phone_black_icon")
            }
        }else{
            if(selectedConsultant == COUPLE_COUNSELLING || selectedConsultant == FAMILY_COUNSELLING){
                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SERVICE_NOT_AVAILBLE_FAMILY_COUPLE"))
                return
            }
            if(!((psychologistDetailModel?.services)!.contains(1)) ||  (psychologistDetailModel?.chatConsultationPrice == nil) || (psychologistDetailModel?.chatConsultationPrice == "")){
                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SERVICE_NOT_PROVIDED"))
                return
            }
            if sender.isSelected{
                sessionStatus = -1
                sender.isSelected = false
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                defaultImage()
                coupleWholeView.isHidden = false
                familyWholeView.isHidden = false
                self.checkViewHideShow(checkChat: true)
            }else{
                audioButton.isSelected = false
                videoButton.isSelected = false
                
                sender.isSelected = true
                sessionStatus = 1
                chatView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatLabe.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                
                chatImageView.image = UIImage(named: "white_chat_icon")
                videoImageView.image = UIImage(named: "video_black_icon")
                audioImageView.image = UIImage(named: "phone_black_icon")
                if(psychologistDetailModel?.chatConsultationPrice == nil){
                    individualWholeView.isHidden = true
                }else{
                    
                    individualWholeView.isHidden = false
                    if(isFree){
                        individualPriceLabel.text =  Utility.getLocalizdString(value: "INDIVIDUAL_FREE_CONSULTATION")
                    }else{
                        
                        //                    individualPriceLabel.text = "\(Utility.getLocalizdString(value: "INDIVIDUALS")) (\(psychologistDetailModel?.chatConsultationPrice ?? "") KD per 30 \(Utility.getLocalizdString(value: "MINUTES")))"
                        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "INDIVIDUALS")) (\(psychologistDetailModel?.chatConsultationPrice ?? "") KD per 30 \(Utility.getLocalizdString(value: "MINUTES")))"
                        }else{
                            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD لكل 30 \(Utility.getLocalizdString(value: "MINUTES"))"
                        }
                        
                    }
                }
                coupleWholeView.isHidden = true
                familyWholeView.isHidden = true
                // self.displayVisablityOfViews()
            }
        }
    }
    
    @IBAction func onFree(_ sender: Any) {
        isSelectedFree = true
        paidView.isHidden = true
        freeRadioImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        paidImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        paidViewHeightConstraint.constant = 0
    }
    
    @IBAction func onPaid(_ sender: Any) {
        isSelectedFree = false
        paidView.isHidden = false
        paidImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        freeRadioImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        paidViewHeightConstraint.constant = 30
    }
    @IBAction func onOpenView(_ sender: Any) {
        
    }
    
    @IBAction func onIndividual(_ sender: Any) {
        //        individualView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        //        coupleView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        familyView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        selectedConsultant = INDIVIDUAL_COUNSELLING
        
        individualImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        coupleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        familyImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        
        
        
        if(sessionStatus == 1){
            coupleWholeView.isHidden = true
            familyWholeView.isHidden = true
        }else{
            
            coupleWholeView.isHidden = false
            familyWholeView.isHidden = false
            self.checkViewHideShow()
        }
    }
    
    @IBAction func onCouple(_ sender: Any) {
        coupleWholeView.isHidden = false
        familyWholeView.isHidden = false
        self.checkViewHideShow()
        //        individualView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        coupleView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        //        familyView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        selectedConsultant = COUPLE_COUNSELLING
        
        individualImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        coupleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        familyImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    
    @IBAction func onFamily(_ sender: Any) {
        coupleWholeView.isHidden = false
        familyWholeView.isHidden = false
        self.checkViewHideShow()
        //        individualView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        coupleView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        familyView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        selectedConsultant = FAMILY_COUNSELLING
        
        individualImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        coupleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        familyImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
    }
    
    @IBAction func onAudio(_ sender: UIButton) {
        if(isFromRequest){
            if sender.isSelected{
                sessionStatus = -1
                sender.isSelected = false
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                defaultImage()
            }else{
                sessionStatus = 2
                chatButton.isSelected = false
                videoButton.isSelected = false
                sender.isSelected = true
                audioView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatLabe.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                audioLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                chatImageView.image = UIImage(named: "black_chat_icon")
                audioImageView.image = UIImage(named: "white_phone_icon")
                videoImageView.image = UIImage(named: "video_black_icon")
            }
        }else{
            if(!((psychologistDetailModel?.services)!.contains(2))){
                Utility.showAlert(vc: self, message: "This service is not provided by the therapist")
                return
            }
            if(psychologistDetailModel?.consultationPrice == nil && psychologistDetailModel?.coupleConsultationPrice == nil && psychologistDetailModel?.familyConsultationPrice == nil){
                DispatchQueue.main.async {
                    Utility.showAlert(vc: self, message: "This service is not provided by the therapist")
                }
                return
            }
            coupleWholeView.isHidden = false
            familyWholeView.isHidden = false
            self.checkViewHideShow()
            if sender.isSelected{
                sessionStatus = -1
                sender.isSelected = false
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                defaultImage()
            }else{
                sessionStatus = 2
                chatButton.isSelected = false
                videoButton.isSelected = false
                sender.isSelected = true
                audioView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatLabe.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                audioLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                chatImageView.image = UIImage(named: "black_chat_icon")
                audioImageView.image = UIImage(named: "white_phone_icon")
                videoImageView.image = UIImage(named: "video_black_icon")
                //self.displayVisablityOfViews()
            }
        }
    }
    @IBAction func onVideo(_ sender: UIButton) {
        if(isFromRequest){
            
            if sender.isSelected{
                sessionStatus = -1
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                sender.isSelected = false
                defaultImage()
            }else{
                sessionStatus = 3
                chatButton.isSelected = false
                audioButton.isSelected = false
                sender.isSelected = true
                sender.isSelected = true
                videoView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                chatLabe.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatImageView.image = UIImage(named: "black_chat_icon")
                audioImageView.image = UIImage(named: "phone_black_icon")
                videoImageView.image = UIImage(named: "white_video_icon")
            }
        }else{
            if(!((psychologistDetailModel?.services)!.contains(3))){
                Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SERVICE_NOT_PROVIDED"))
                return
            }
            if(psychologistDetailModel?.consultationPrice == nil && psychologistDetailModel?.coupleConsultationPrice == nil && psychologistDetailModel?.familyConsultationPrice == nil){
                DispatchQueue.main.async {
                    Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SERVICE_NOT_PROVIDED"))
                }
                return
            }
            coupleWholeView.isHidden = false
            familyWholeView.isHidden = false
            self.checkViewHideShow()
            if sender.isSelected{
                sessionStatus = -1
                videoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                sender.isSelected = false
                defaultImage()
            }else{
                sessionStatus = 3
                chatButton.isSelected = false
                audioButton.isSelected = false
                sender.isSelected = true
                sender.isSelected = true
                videoView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
                chatView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                audioView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                videoLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                chatLabe.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
                chatImageView.image = UIImage(named: "black_chat_icon")
                audioImageView.image = UIImage(named: "phone_black_icon")
                videoImageView.image = UIImage(named: "white_video_icon")
                //  self.displayVisablityOfViews()
            }
        }
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if sessionStatus == -1{
            Utility.showAlert(vc: self, message:Utility.getLocalizdString(value: "PLEASE_COMMUNICATION_MEDIUM"))
            return
        }else if selectedConsultant == -1{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_THE_TYPE_OF_SESSION"))
            return
        }
        if(!isFromRequest){
            delegate?.getSelectedTimeOfSectionData(type: sessionStatus, consultantType: selectedConsultant,isFree: isFree)
            self.dismiss(animated: true, completion: nil)
        }else{
            if(isSelectedFree){
                onPayment()
            }else{
                if priceTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    Utility.showAlert(vc: self, message:Utility.getLocalizdString(value: Utility.getLocalizdString(value: "PLEASE_ENTER_PRICE")))
                    return
                }
                else if priceTextfield.text?.integerValue ?? 0 <= 0{
                    Utility.showAlert(vc: self, message:Utility.getLocalizdString(value:Utility.getLocalizdString(value: "PRICE_MUST_BE_GREATER")))
                    return
                }
                onPayment()
            }
        }
    }
    func onPayment(response: String = ""){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                var price = ""
                if(isSelectedFree){
                    price = "0"
                }else{
                    price = priceTextfield.text ?? "0"
                }
                let finalDate = "\(selectedDate)"
                var userId = Int()
                if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                    do{
                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                            userId = (loginDetails.data?.id!)!
                        }
                    }catch{
                    }
                }
//                let price =
                var parameters = [String : Any]()
                if(isFromPastBookRequest){
                    parameters = [APPOINTMENT_DATE:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD),
                                     PSYCHOLOGIST_ID:userId ,
                                     SESSION:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS),
                                     SERVICES:sessionStatus,
                                     "paymentResponse":response,
                                     "consultantType":selectedConsultant,
                                     "consultationPrice":price,
                                     "userId":appointmentDeatilModel?.userId ?? 0,
                                     "requestId": 0,
                                     
                   ] as [String : Any]
                }else{
                 parameters = [APPOINTMENT_DATE:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD),
                                  PSYCHOLOGIST_ID:userId ,
                                  SESSION:Utility.localToUTC(date: selectedTime, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS),
                                  SERVICES:sessionStatus,
                                  "paymentResponse":response,
                                  "consultantType":selectedConsultant,
                                  "consultationPrice":price,
                                  "userId":requestModel?.userId ?? 0,
                                  "requestId":self.isFromPastRequest == true ? 0 : requestModel?.requestId! ?? 0,
                                  
                ] as [String : Any]
                }
                AppointmentServices.shared.appointMentBooking(isFree:isSelectedFree == true ? false:true,parameters: parameters ,success: { (statusCode, commanModel) in
                    Utility.hideIndicator()
                    self.dismiss(animated: true, completion: {
                        self.onDoneBlock!(true)
                    })
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
    
    func defaultImage(){
        chatImageView.image = UIImage(named: "black_chat_icon")
        videoImageView.image = UIImage(named: "video_black_icon")
        audioImageView.image = UIImage(named: "phone_black_icon")
        videoLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        chatLabe.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        audioLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension String
    {

        func isNumber() -> Bool{
            let numberCharacters = CharacterSet.decimalDigits.inverted
            return !self.isEmpty && self.rangeOfCharacter(from:numberCharacters) == nil
        }
        struct NumberFormat
        {
            static let instance = NumberFormatter()
        }
        var integerValue:Int?
        {
            if self.isEmpty
            {
                return 0
            }
            else
            {
                return (NumberFormat.instance.number(from: self)?.intValue) ?? 0
            }
        }
    }
