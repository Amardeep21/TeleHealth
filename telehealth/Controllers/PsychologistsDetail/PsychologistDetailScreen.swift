//
//  PsychologistDetailScreen.swift
//  telehealth
//
//  Created by iroid on 17/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class PsychologistDetailScreen: UIViewController {

    //MARK:UIImageView IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    //MARK: UILabel IBOutlet
    //@IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: ExpandableLabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var experiencedInLabel: ExpandableLabel!
    @IBOutlet weak var yearOfExperienceLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var funFactValueLabel: UILabel!
    @IBOutlet weak var funFaceBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var funFactTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var funFactLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var individualPriceLabel: UILabel!
    @IBOutlet weak var couplePriceLabel: UILabel!
    @IBOutlet weak var familyPriceLabel: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var individualLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var coupleLabelHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var familyLabelHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var experiencesLabel: UILabel!
    
    @IBOutlet weak var educationsLabel: UILabel!
    
    @IBOutlet weak var alsoExperienceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alsoExperienceHeightLabel: NSLayoutConstraint!
    var isExpandable = true
    var psychologistId = 0
    var profileImageUrl = ""
    var psychologistName = ""
    var psychologistDetailModel:PsychologistsDataModel? = nil
    @IBOutlet weak var individulaLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTitleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatIndividualPriceLabel: UILabel!
    @IBOutlet weak var chatTitleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatSessionTitleLabel: UILabel!
    @IBOutlet weak var chatIndividualLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var familyLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var coupleLabelTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialiseDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        setAboutMe()
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
            aboutMeLabel.textAlignment = .right
            experiencesLabel.textAlignment = .right
            experiencedInLabel.textAlignment = .right
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
            aboutMeLabel.textAlignment = .left
            experiencesLabel.textAlignment = .left
            experiencedInLabel.textAlignment = .left

        }
    }
    
    func initialiseDetail(){
      
        setAboutMe()
         getPsychologistProfile()
      
    }
    
    func setAboutMe(){
    [aboutMeLabel].forEach{
        $0?.delegate = self
        $0?.setLessLinkWith(lessLink: "Read Less", attributes: [.foregroundColor:Utility.getUIcolorfromHex(hex: "#02080A"),.font: UIFont(name: "Quicksand-Regular", size: 13)!], position: nil)
        $0?.shouldCollapse = true
        $0?.textReplacementType = .word
        $0?.numberOfLines = 3
        $0?.collapsed = isExpandable
        $0?.text = ""
    }
        aboutMeLabel.text =  psychologistDetailModel?.aboutme ?? "--"
    }
    //MARK:UIButton Action
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBookSession(_ sender: UIButton) {
        if(psychologistDetailModel?.id != nil && psychologistDetailModel?.id != 0 ){
        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
        control.psychologistDetailModel = self.psychologistDetailModel
        self.navigationController?.pushViewController(control, animated: true)
        }else{
            self.getPsychologistProfile()
        }
    }
    

    @IBAction func onProfilePhoto(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
               let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = psychologistDetailModel?.profile ?? ""
               confirmAlertController.modalPresentationStyle = .overFullScreen
               self.present(confirmAlertController, animated: true, completion: nil)
    }
    
  func getPsychologistProfile(){
           if Utility.isInternetAvailable(){
               Utility.showIndicator()
            let url = "\(PSYCHOLOGIST_DETAIL)\(psychologistId)"
               HomeServices.shared.getPsychologistProfile(url: url, success: { (statusCode, PsychologistDetailModel) in
                   Utility.hideIndicator()
                self.psychologistDetailModel = PsychologistDetailModel.data
                self.setPsychologistData()
               }) { (error) in
                   Utility.hideIndicator()
                   Utility.showAlert(vc: self, message: error)
//                self.getPsychologistProfile()
               }
           }else{
               Utility.hideIndicator()
               Utility.showNoInternetConnectionAlertDialog(vc: self)
           }
       }
    
    func setPsychologistData(){
        nameLabel.text = "\(psychologistDetailModel?.firstname ?? "") \(psychologistDetailModel?.lastname ?? "" )"
//        titleNameLabel.text = "\(psychologistDetailModel?.firstname ?? "") \(psychologistDetailModel?.lastname ?? "")"
        Utility.setImage(psychologistDetailModel?.profile, imageView: profileImageView)
        aboutMeLabel.text =  psychologistDetailModel?.aboutme ?? "--"
     
//        experiencesLabel.text = "\(psychologistDetailModel?.yearOfExperience ?? "0")" + " Years of Experience"
        let education = psychologistDetailModel?.education!.replacingOccurrences(of: "\n", with: ", ")
        educationsLabel.text = "\(education ?? "")"
        let specialtiesArray = psychologistDetailModel?.speciality
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            specialityLabel.text = specialtiesArray?.joined(separator: "، ")
            yearOfExperienceLabel.text  = "\(psychologistDetailModel?.yearOfExperience ?? "0")" + ""
        }else{
            specialityLabel.text = specialtiesArray?.joined(separator: ", ")
            yearOfExperienceLabel.text  = "\(psychologistDetailModel?.yearOfExperience ?? "0")" + " \(Utility.getLocalizdString(value: "YEARS"))"
        }
        
        if(psychologistDetailModel?.experience == nil){
            alsoExperienceHeightLabel.constant = 0
            alsoExperienceTopConstraint.constant = 0
            experiencedInLabel.text = ""
        }else{
            experiencedInLabel.text = psychologistDetailModel?.experience
            alsoExperienceHeightLabel.constant = 20
            alsoExperienceTopConstraint.constant = 20
        }
        
//        educationLabel.text = "\(education ?? "")"
         let language = psychologistDetailModel?.languages!.replacingOccurrences(of: ",", with: ", ")
        languageLabel.text = language
        if(psychologistDetailModel?.consultationPrice == nil){
            individualLabelHeightConstant.constant = 0
            individulaLabelTopConstraint.constant =  0
        }else{ 
            individualLabelHeightConstant.constant = 21
            individulaLabelTopConstraint.constant =  8
        }
        if(psychologistDetailModel?.coupleConsultationPrice == nil){
            coupleLabelHeightConstant.constant = 0
            coupleLabelTopConstraint.constant =  0
        }else{
            coupleLabelHeightConstant.constant = 21
            coupleLabelTopConstraint.constant =  8
        }
        if(psychologistDetailModel?.familyConsultationPrice == nil){
            familyLabelHeightConstant.constant = 0
            familyLabelTopConstraint.constant =  0
        }else{
            familyLabelHeightConstant.constant = 21
            familyLabelTopConstraint.constant =  8
        }
        if(psychologistDetailModel?.chatConsultationPrice == nil){
            chatIndividualLabelHeightConstraint.constant = 0
            chatTitleLabelHeightConstraint.constant =  0
            chatTitleLabelTopConstraint.constant = 0
            chatTitleLabelBottomConstraint.constant = 0
        }else{
            chatIndividualLabelHeightConstraint.constant = 21
            chatTitleLabelHeightConstraint.constant =  21
            chatTitleLabelTopConstraint.constant = 13
            chatTitleLabelBottomConstraint.constant = 8
        }
        
        
        
        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            couplePriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_COUPLE")) \(psychologistDetailModel?.coupleConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            familyPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_FAMILY")) \(psychologistDetailModel?.familyConsultationPrice ?? "") KD per 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            chatIndividualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.chatConsultationPrice ?? "") KD per 30 \(Utility.getLocalizdString(value: "MINUTES"))"
        }else{
            individualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.consultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            couplePriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_COUPLE")) \(psychologistDetailModel?.coupleConsultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            familyPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_FAMILY")) \(psychologistDetailModel?.familyConsultationPrice ?? "") KD لكل 50 \(Utility.getLocalizdString(value: "MINUTES"))"
            chatIndividualPriceLabel.text = "\(Utility.getLocalizdString(value: "FOR_INDIVIDUAL")) \(psychologistDetailModel?.chatConsultationPrice ?? "") KD لكل 30 \(Utility.getLocalizdString(value: "MINUTES"))"
        }
        if(((psychologistDetailModel?.services)!.contains(1))){
            chatView.isHidden = false
        }else{
            chatView.isHidden = true
        }
        if(((psychologistDetailModel?.services)!.contains(2))){
            audioView.isHidden = false
        }else{
            audioView.isHidden = true
        }
        if((psychologistDetailModel?.services)!.contains(3)){
            videoView.isHidden = false
        }else{
            videoView.isHidden = true
        }
        
        if(psychologistDetailModel?.funFact == "" || psychologistDetailModel?.funFact == nil){
            funFactValueLabel.text = ""
            funFactTopConstraint.constant =  0
            funFaceBottomConstraint.constant = 0
            funFactLabelHeightConstraint.constant = 0
        }else{
            funFactValueLabel.text = psychologistDetailModel?.funFact
            funFactTopConstraint.constant =  20
            funFaceBottomConstraint.constant = 10
            funFactLabelHeightConstraint.constant = 20
        }
        self.updateLabelAlignments()
    }
    func updateLabelAlignments(){
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
            aboutMeLabel.textAlignment = .right
            experiencesLabel.textAlignment = .right
            experiencedInLabel.textAlignment = .right
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
            aboutMeLabel.textAlignment = .left
            experiencesLabel.textAlignment = .left
            experiencedInLabel.textAlignment = .left

        }
    }
    @IBAction func onRequestFreeSession(_ sender: Any) {
        setRequestForFreeSession()
    }
    
    
    
    func setRequestForFreeSession(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            RequestServices.shared.requestFreeSession(parameters: [:],url: "\(FREE_SESSION_REQUEST)\(psychologistDetailModel?.id ?? 0)", success: { (statusCode, requestModel) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: requestModel.message!)
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
// MARK: ExpandableLabel Delegate
extension PsychologistDetailScreen:ExpandableLabelDelegate{
    func willExpandLabel(_ label: ExpandableLabel) {
        self.updateLabelAlignments()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        isExpandable = false
        self.updateLabelAlignments()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.updateLabelAlignments()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        isExpandable = true
        self.updateLabelAlignments()
    }
}
