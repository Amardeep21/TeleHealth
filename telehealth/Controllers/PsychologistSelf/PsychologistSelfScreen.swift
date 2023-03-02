//
//  PsychologistSelfScreen.swift
//  telehealth
//
//  Created by iroid on 17/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PsychologistSelfScreen: UIViewController {
    
    //MARK:UITextView IBOutlet
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var experiencedInTextView: UITextView!
    //MARK:UITableView IBOutlet
    @IBOutlet weak var specialityTableView: UITableView!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var languageCollectionView: UICollectionView!
    //MARK:NSLayoutConstraint IBOutlet
    @IBOutlet weak var specialityTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageCollectionHeightConstraint: NSLayoutConstraint!
    //MARK:UITextField IBOutlet
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var educationTextView: dateSportTextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var consultationPriceTextField: UITextField!
    @IBOutlet weak var searchLanguageTextField: UITextField!
    @IBOutlet weak var individualPriceTextField: UITextField!
    @IBOutlet weak var familyPriceTextField: UITextField!
    @IBOutlet weak var chatPriceTextField: dateSportTextField!
    @IBOutlet weak var couplePriceTextField: UITextField!
    //MARK:UILabel IBOutlet
    @IBOutlet weak var chatDotLabel: UILabel!
    @IBOutlet weak var audioDotLabel: UILabel!
    @IBOutlet weak var videoDotLabel: UILabel!
    @IBOutlet weak var languageBorderLabel: UILabel!
    @IBOutlet weak var femaleDotLabel: UILabel!
    @IBOutlet weak var maleDotLabel: dateSportLabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var chatCheckMarkImageView: UIImageView!
    @IBOutlet weak var audioCheckMarkImageView: UIImageView!
    @IBOutlet weak var videoCheckMarkImageView: UIImageView!
    
    @IBOutlet weak var funFactViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstNameTextField: dateSportTextField!
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    
    @IBOutlet weak var funFactTextView: dateSportTextView!
    //MARK: Variables
    var specialityItem : Observable<[SpecialityInformationModel]>!
    var languageItem : Observable<[LanguageData]>!
    var selectedLanguageItem : Observable<[LanguageData]>!
    var psychologistDetailModel:PsychologistsDataModel? = nil
    
    var specialityArray = [SpecialityInformationModel]()
    var languageArray = [LanguageData]()
    var selectedLanguageArray = [LanguageData]()
    var searchLanguageResultArray = [LanguageData]()
    var selectedLanguage = ""
    var chat = Int()
    var video = Int()
    var audio = Int()
    var genderType = -1
    var isFromSetting : Bool = false
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chat = -1
        video = -1
        audio = -1
        // Do any additional setup after loading the view.
        initialiseDetail()
    }
    
    //MARK:Initialise Detail
    func initialiseDetail(){
        firstNameTextField.placeholder = Utility.getLocalizdString(value: "FIRST_NAME")
        lastNameTextField.placeholder = Utility.getLocalizdString(value: "LAST_NAME")
        languageCollectionView.dataSource = self
        languageCollectionHeightConstraint.constant = 0
        languageTableHeightConstraint.constant = 0
        languageBorderLabel.isHidden = true
        specialityTableView.register(UINib(nibName: "SpecialityCell", bundle: nil), forCellReuseIdentifier: "SpecialityTableCell")
        languageTableView.register(UINib(nibName: "LanguageTableCell", bundle: nil), forCellReuseIdentifier: "LanguageTableCell")
        languageCollectionView.register(UINib(nibName: "LanguageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LanguageCollectionCell")
        
        aboutMeTextView.textContainerInset = UIEdgeInsets(top: 12, left: 7, bottom: 7, right: 7)
        experiencedInTextView.textContainerInset = UIEdgeInsets(top: 12, left: 7, bottom: 7, right: 7)
        educationTextView.textContainerInset = UIEdgeInsets(top: 12, left: 7, bottom: 7, right: 7)
        setLeftPaddingTextField()
        [experienceTextField,consultationPriceTextField].forEach{
            $0?.layer.cornerRadius = 4
            $0?.layer.borderColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 0.5)
            $0?.layer.borderWidth = 0.5
        }
        let layout = MyLeftCustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        languageCollectionView.collectionViewLayout = layout
        //        searchLanguageTextField.attributedPlaceholder = NSAttributedString(string: "Search Languages",
        //                                                                           attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.5) ,.font: UIFont(name: "Quicksand-Regular", size: 13)!])
        getSpecialityList()
        getLanguageList()
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    firstNameTextField.text  = loginDetails.data?.firstnameAr
                    lastNameTextField.text = loginDetails.data?.lastnameAr
                }
            }catch{}
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    
    
    func getPsychologistProfile(){
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    if Utility.isInternetAvailable(){
                        Utility.showIndicator()
                        let url = "\(PSYCHOLOGIST_DETAIL)\(loginDetails.data?.id ?? 0)"
                        HomeServices.shared.getPsychologistProfile(url: url, success: { (statusCode, PsychologistDetailModel) in
                            Utility.hideIndicator()
                            self.psychologistDetailModel = PsychologistDetailModel.data
                            self.setSettingData()
                        }) { (error) in
                            Utility.hideIndicator()
                            Utility.showAlert(vc: self, message: error)
                        }
                    }else{
                        Utility.hideIndicator()
                        Utility.showNoInternetConnectionAlertDialog(vc: self)
                    }
                }
            }catch{}
        }
    }
    func setSettingData(){
        if(isFromSetting){
            backButton.isHidden = false
            
        }else{
            backButton.isHidden = true
        }
        if(psychologistDetailModel?.gender == 1){
//            femaleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            femaleDotLabel.layer.borderWidth = 0.5
//            maleDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            maleDotLabel.layer.borderWidth = 0.0
            
            maleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
                 femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            genderType = 1
        }else{
//            maleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            maleDotLabel.layer.borderWidth = 0.5
//            femaleDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            femaleDotLabel.layer.borderWidth = 0.0
            
            maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            femaleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            genderType = 0
        }
        
       
             
        
        for i in 0...specialityArray.count-1{
            let object  = specialityArray[i]
            if((psychologistDetailModel!.specialityId!.contains(i+1))){
                object.isSelected = true
            }else{
                object.isSelected = false
            }
        }
        aboutMeTextView.text = self.psychologistDetailModel?.aboutme
        experiencedInTextView.text = self.psychologistDetailModel?.experience
        experienceTextField.text = self.psychologistDetailModel?.yearOfExperience
        educationTextView.text = self.psychologistDetailModel?.education
        individualPriceTextField.text  = self.psychologistDetailModel?.consultationPrice ?? ""
        couplePriceTextField.text = self.psychologistDetailModel?.coupleConsultationPrice ?? ""
        familyPriceTextField.text = self.psychologistDetailModel?.familyConsultationPrice ?? ""
        chatPriceTextField.text = self.psychologistDetailModel?.chatConsultationPrice ?? ""
        if(((psychologistDetailModel?.services)!.contains(2))){
            
            audio = 2
            audioButton.isSelected = true
//            audioDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            audioDotLabel.layer.borderWidth = 0.0
            audioCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        }
        else{
            audio = -1
            audioButton.isSelected = false
//            audioDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            audioDotLabel.layer.borderWidth = 0.5
            audioCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        
        if(((psychologistDetailModel?.services)!.contains(1))){
            chatButton.isSelected = true
//            chatDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            chatDotLabel.layer.borderWidth = 0.0
            
            chatCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            chat = 1
            
        }
        else{
            chatButton.isSelected = false
            chat = -1
//            chatDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            chatDotLabel.layer.borderWidth = 0.5
            chatCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        
        if(((psychologistDetailModel?.services)!.contains(3))){
            video = 3
            videoButton.isSelected = true
//            videoDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            videoDotLabel.layer.borderWidth = 0.0
            videoCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        }
        else{
            video = -1
            videoButton.isSelected = false
//            videoDotLabel.backgroundColq
            videoCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        
        funFactTextView.text = psychologistDetailModel?.funFact
        self.loadSpecialityTable()
        let pointsArr = psychologistDetailModel?.languages?.split(separator: ",")
        for i in 0...pointsArr!.count-1{
            let object = LanguageData(name:String((pointsArr?[i])!))
            selectedLanguageArray.append(object)
        }
        firstNameTextField.text = psychologistDetailModel?.firstname
        lastNameTextField.text = psychologistDetailModel?.lastname
        self.languageCollectionView.reloadData()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
        }, completion: { (finished) -> Void in
            self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
        });
    }
    
    func setLeftPaddingTextField()  {
        let textFieldArray = [experienceTextField,consultationPriceTextField]
        for textField in textFieldArray {
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 14, height: 2.0))
            textField?.leftView = leftView
            textField?.leftViewMode = .always
        }
    }
    //MARK: Load Speciality Table
    func loadSpecialityTable(){
        // Set automatic dimensions for row height
        specialityTableView.dataSource = nil
        specialityItem = Observable.just(specialityArray)
        specialityItem.bind(to: specialityTableView.rx.items(cellIdentifier: "SpecialityTableCell", cellType:SpecialityCell.self)){(row,item,cell) in
            print(item)
            cell.selectionStyle = .none
            cell.specialityTypeLabel.text = item.speciality
            if(item.isSelected!){
                cell.tapButton.isSelected = true
//                cell.dotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//                cell.dotLabel.layer.borderWidth = 0.0
                cell.checkMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            }else{
                cell.tapButton.isSelected = false
//                cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                cell.dotLabel.layer.borderWidth = 0.5
                cell.checkMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            }
        }.disposed(by: disposeBag)
        
        Observable
            .zip(specialityTableView.rx.itemSelected, specialityTableView.rx.modelSelected(SpecialityInformationModel.self))
            .bind { [unowned self] indexPath, model in
                if let cell = self.specialityTableView.cellForRow(at: indexPath) as? SpecialityCell {
                    if(cell.tapButton.isSelected)
                    {
                        cell.tapButton.isSelected = true
//                        cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                        cell.dotLabel.layer.borderWidth = 0.5
                        cell.checkMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
                        model.isSelected = false
                    }
                    else
                    {
                        cell.tapButton.isSelected = false
//                        cell.dotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//                        cell.dotLabel.layer.borderWidth = 0.0
                         cell.checkMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
                        model.isSelected = true
                    }
                }
        }
        .disposed(by: disposeBag)
    }
    
    func loadLanguageTable(){
        languageTableView.dataSource = nil
        languageItem = Observable.just(searchLanguageResultArray)
        languageItem.bind(to: languageTableView.rx.items(cellIdentifier: "LanguageTableCell", cellType:LanguageTableCell.self)){(row,item,cell) in
            print(item)
            cell.selectionStyle = .none
            cell.languageLabel.text = (self.searchLanguageResultArray[row]).name
        }.disposed(by: disposeBag)
        
        languageTableView.rx.itemSelected.subscribe(onNext : {
            [weak self] indexPath in
            if(indexPath.row < self!.searchLanguageResultArray.count){
                if(self?.selectedLanguageArray.count == 0)
                {
                    self!.languageCollectionHeightConstraint.constant = 25
                }
                if( !self!.selectedLanguageArray.contains(where: {$0.name == (self!.searchLanguageResultArray[indexPath.row]).name})){
                    self!.selectedLanguageArray.append((self!.searchLanguageResultArray[indexPath.row]))
                    self!.languageTableHeightConstraint.constant = 0
                    self!.languageCollectionView.reloadData()
                    //                    self!.loadSelectedLanguageCollection()
                    self!.searchLanguageTextField.text = ""
                    self!.view.endEditing(true)
                }
            }
        }).disposed(by: disposeBag)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
        }, completion: { (finished) -> Void in
            self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
        });
    }
    
    func loadSelectedLanguageCollection(){
        languageCollectionView.dataSource = nil
        selectedLanguageItem = Observable.just(selectedLanguageArray)
        print("selected language:\(selectedLanguageArray)")
        selectedLanguageItem.bind(to: languageCollectionView.rx.items(cellIdentifier: "LanguageCollectionCell", cellType:LanguageCollectionCell.self)){(row,item,cell) in
            // print(item)
            cell.layoutIfNeeded()
            if(row < self.selectedLanguageArray.count)
            {
                cell.languageName.text = "- \((self.selectedLanguageArray[row]).name ?? "")"
                cell.cancelButton.rx.tap.first()
                    .subscribe({ _ in
                        if(row < self.selectedLanguageArray.count)
                        {
                            self.selectedLanguageArray.remove(at: row)
                            if(self.selectedLanguageArray.count == 0)
                            {
                                self.languageCollectionHeightConstraint.constant = 0
                            }
                            else{
                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                }, completion: { (finished) -> Void in
                                    self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
                                });
                            }
                        }
                        self.loadSelectedLanguageCollection()
                    })
                    .disposed(by: self.disposeBag)
            }
            
            
        }.disposed(by: disposeBag)
    }
    
    //MARK:UIButton Action
    
    @IBAction func onChat(_ sender: UIButton) {
        if(sender.isSelected)
        {
            chat = -1
            sender.isSelected = false
//            chatDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            chatDotLabel.layer.borderWidth = 0.5
            chatCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        else{
            
            chat = 1
            sender.isSelected = true
//            chatDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            chatDotLabel.layer.borderWidth = 0.0
            chatCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        }
    }
    
    @IBAction func onAudio(_ sender: UIButton) {
        if(sender.isSelected)
        {
            audio = -1
            sender.isSelected = false
//            audioDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            audioDotLabel.layer.borderWidth = 0.5
            audioCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        else{
            
            audio = 2
            sender.isSelected = true
//            audioDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            audioDotLabel.layer.borderWidth = 0.0
            audioCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        }
    }
    
    @IBAction func onVideo(_ sender: UIButton) {
        if(sender.isSelected)
        {
            
             video = -1
            sender.isSelected = false
//            videoDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            videoDotLabel.layer.borderWidth = 0.5
             videoCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        }
        else{
           video = 3
            sender.isSelected = true
//            videoDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            videoDotLabel.layer.borderWidth = 0.0
            videoCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        }
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        let selectedSpecialityArrayOfDictionary = specialityArray.filter { $0.isSelected == true }
        let selectedSpecialityArray = selectedSpecialityArrayOfDictionary.compactMap({ $0.id })
        if(firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_FIRSTNAME"))
            return
        }else if(lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
           Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_LASTNAME"))
            return
        }
        if aboutMeTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_ENTER_ABOUT_ME_INFORMATION"))
            return
        }
        else if(selectedSpecialityArray.count == 0){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_SELECT_AT_LEAST_ONE_SPECIALITY"))
            return
        }
//        else if experiencedInTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
//            Utility.showAlert(vc: self, message: "Please enter your other experince")
//            return
//        }
        else if experienceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_EXPERINCE"))
            return
        }
        else if educationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_EDUCATION"))
            return
        }
//        else if individualPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && couplePriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" && familyPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
//            Utility.showAlert(vc: self, message: "Please enter at-least one price for any of the consulting")
//            return
//        }
//        else if   individualPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
//            let value = (individualPriceTextField.text! as NSString).doubleValue
//            if(value < 0.2){
//                Utility.showAlert(vc: self, message: "Minimum price must be greater than or equal to 0.2")
//            }
//        }
//        else if   couplePriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
//            let value = (couplePriceTextField.text! as NSString).doubleValue
//            if(value < 0.2){
//                Utility.showAlert(vc: self, message: "Minimum price must be greater than or equal to 0.2")
//            }
//        }
//        else if   familyPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
//            let value = (familyPriceTextField.text! as NSString).doubleValue
//            if(value < 0.2){
//               Utility.showAlert(vc: self, message: "Minimum price must be greater than or equal to 0.2")
//            }
//        }
        
        else if chat == -1 && video == -1 && audio == -1{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_AT_LEAST_ONE_SERVICE"))
            return
        }
        else if genderType == -1{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_YOUR_GENDER"))
            return
        }
        
        self.addPsychologistInformation(selectedSpecialityArray: selectedSpecialityArray)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onMale(_ sender: UIButton) {
      maleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
     femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        genderType = 1
    }
    
    @IBAction func onFemale(_ sender: UIButton) {
        maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")

        genderType = 0
    }
    
    func addPsychologistInformation(selectedSpecialityArray: [Int]) {
        var servicesArray = [Int]()
        if(chat != -1){
            servicesArray.append(chat)
        }
        if(audio != -1){
            servicesArray.append(audio)
        }
        if(video != -1){
            servicesArray.append(video)
        }
        var langArray = [String]()
        if(selectedLanguageArray.count == 0){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SELECT_AT_LEAST_ONE_LANGAUGE"))
            return
        }else{
            for i in 0...selectedLanguageArray.count - 1{
                let obj = selectedLanguageArray[i]
                langArray.append(obj.name ?? "")
            }
        }
        let languageString = langArray.joined(separator: ",")
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                
                
                let parameters = [ABOUT_ME:aboutMeTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "firstname":firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "lastname":lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "speciality":selectedSpecialityArray,
                                  "experience":experiencedInTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "yearOfExperience":experienceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "education":educationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                  "languages":languageString,
                                  "services":servicesArray,
                                  "gender":genderType,
                                  "funFact":funFactTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    ] as [String : Any]
//                "consultationPrice":individualPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
//                "coupleConsultationPrice":couplePriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
//                "familyConsultationPrice":familyPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                PsychologistSelfServices.shared.addPsychologistInformation(parameters: parameters, success: { [self] (statusCode, psychologistModel) in
                    
                    Utility.hideIndicator()
                    if(self.isFromSetting){
                        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                            do{
                                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                    if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                                    loginDetails.data?.firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                    loginDetails.data?.lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                    }else{
                                        loginDetails.data?.firstnameAr = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                        loginDetails.data?.lastnameAr = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                    }
                                    do{
                                        let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                        UserDefaults.standard.set(data, forKey: USER_DETAILS)

                                    }catch{
                                        print(error)
                                    }
                                }
                            }catch{}
                        self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                            do{
                                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                    loginDetails.data?.userInfo?.isDetailsAdded = 1
                                    do{
                                        let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                        UserDefaults.standard.set(data, forKey: USER_DETAILS)
//                                        let storyBoard = UIStoryboard(name: "PsychologistSelf", bundle: nil)
//                                        let control = storyBoard.instantiateViewController(withIdentifier: "AvailableSessionScreen") as! AvailableSessionScreen
//                                        self.navigationController?.pushViewController(control, animated: true)
                                        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
                                                                   let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
                                                                   self.navigationController?.pushViewController(control, animated: true)
                                    }catch{
                                        print(error)
                                    }
                                }
                            }catch{}
                        }
                    }
                    //                    Utility.showAlert(vc: self, message: loginModel.message!)
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
    
    //MARK:Get Speciality list Api Call
    func getSpecialityList() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            HomeServices.shared.getSpeciality(success: { (statusCode, specialityModel) in
                Utility.hideIndicator()
                self.specialityArray = specialityModel.data!
                self.loadSpecialityTable()
                if(self.isFromSetting){
                    self.getPsychologistProfile()
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
    
    func getLanguageList() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            HomeServices.shared.getLanguage(success: { (statusCode, specialityModel) in
                Utility.hideIndicator()
                self.languageArray = specialityModel.data!                
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
//MARK:UITableViewDelegate
extension PsychologistSelfScreen:UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView == specialityTableView){
            self.specialityTableHeightConstraint.constant = self.specialityTableView.contentSize.height
            self.specialityTableView.layoutIfNeeded()
        }
        
    }
}
//MARK:UITextFieldDelegate
extension PsychologistSelfScreen:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchLanguageTextField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == searchLanguageTextField)
        {
            
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                let namePredicate = NSPredicate(format: "self CONTAINS [cd] %@",updatedText);
                
                searchLanguageResultArray = languageArray.filter {
                    namePredicate.evaluate(with: $0.name)
                }
                print("names = ,\(searchLanguageResultArray)");
                if searchLanguageResultArray.count == 0
                {
                    languageBorderLabel.isHidden = true
                    languageTableHeightConstraint.constant = 0
                }
                else
                {
                    languageBorderLabel.isHidden = false
                    languageTableHeightConstraint.constant = CGFloat(searchLanguageResultArray.count * 36)
                }
                
            }
            // let searchToSearch = textField.text
            loadLanguageTable()
        }
        return true
        // print(matchingTerms)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end....")
        if searchLanguageTextField.text == ""
        {
            languageBorderLabel.isHidden = true
            languageTableHeightConstraint.constant = 0
            searchLanguageResultArray.removeAll()
            loadLanguageTable()
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""
        {
            languageBorderLabel.isHidden = true
            languageTableHeightConstraint.constant = 0
            searchLanguageResultArray.removeAll()
            loadLanguageTable()
        }
    }
    
}

class MyLeftCustomFlowLayout:UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = 2.0
        
        let horizontalSpacing:CGFloat = 5
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY
                || layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            
            if layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            else {
                layoutAttribute.frame.origin.x = leftMargin
            }
            
            leftMargin += layoutAttribute.frame.width + horizontalSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
extension PsychologistSelfScreen : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedLanguageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCollectionCell", for: indexPath) as! LanguageCollectionCell
        cell.languageName.text = "- \((self.selectedLanguageArray[indexPath.row]).name ?? "")"
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(cancelClicked(sender:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc func cancelClicked(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        selectedLanguageArray.remove(at: buttonTag)
        if(self.selectedLanguageArray.count == 0)
        {
            self.languageCollectionHeightConstraint.constant = 0
        }
        else{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
            }, completion: { (finished) -> Void in
                self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
            });
        }
        languageCollectionView.reloadData()
    }
}
