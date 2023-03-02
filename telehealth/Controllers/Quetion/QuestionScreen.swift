//
//  QuestionScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class QuestionScreen: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var IndividualCounsellingImageView: UIImageView!
    @IBOutlet weak var coupleCounsellingImageView: UIImageView!
    @IBOutlet weak var teenageCounsellingImageView: UIImageView!
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var marriedImageView: UIImageView!
    @IBOutlet weak var unmarriedImageView: UIImageView!
    @IBOutlet weak var yesImageView: UIImageView!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var rangePickerView: UIPickerView!
    
    @IBOutlet weak var questionTableViewHeightConstraint: NSLayoutConstraint!
    var counsellingType = Int()
    var gender = Int()
    var relationship = Int()
    var isCounsellingBefore = Int()
    var psychologistId = 0
    var sections = sectionsData
    var questionRootModel:QuestionRootModel?
    var englishModel : [EnglishQuestionModel]?
    var arebicModel : [ArabicQuestionModel]?
    var selectedIndex = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializedDetails()
        questionTableView.rowHeight = UITableView.automaticDimension
        questionTableView.estimatedRowHeight = 600
        self.questionTableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.questionTableView.estimatedSectionHeaderHeight = 25;
        getQuestions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    
                    if(loginDetails.data!.flag == 1){
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }catch{}
        }
    }
    
    func getQuestions()
    {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            QuestionServices.shared.getQuestions(success: { [self] (statusCode, questionModel) in
                self.questionRootModel = questionModel
                self.englishModel = questionModel.data?.en
                self.arebicModel = questionModel.data?.ar
                self.questionTableView.reloadData()
                
                Utility.hideIndicator()
                
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
        
    }
    
    @IBAction func onSkip(_ sender: Any) {
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    UserDefaults.standard.set(loginDetails.data?.role, forKey: "UserType")
                    loginDetails.data?.flag = 1
                    do{
                        let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                        UserDefaults.standard.set(data, forKey: USER_DETAILS)
                        //                                        let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                        //                                                       let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                        //                                        control.psychologistId = self.psychologistId
                        //                                                       self.navigationController?.pushViewController(control, animated: true)
                        self.gotoTabBarScreen()
                    }catch{
                        print(error)
                    }
                }
            }catch{}
        }
        //        self.gotoTabBarScreen()
    }
    @IBAction func onIndividualCounselling(_ sender: UIButton) {
        counsellingType = INDIVIDUAL_COUNSELLING
        IndividualCounsellingImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        coupleCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        teenageCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    @IBAction func onCoupleCounselling(_ sender: UIButton) {
        counsellingType = COUPLE_COUNSELLING
        IndividualCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        coupleCounsellingImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        teenageCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    @IBAction func onTeenageCounselling(_ sender: UIButton) {
        counsellingType = TEENAGE_COUNSELLING
        IndividualCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        coupleCounsellingImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        teenageCounsellingImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
    }
    @IBAction func onMale(_ sender: UIButton) {
        gender = MALE_VALUE
        maleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    @IBAction func onFemale(_ sender: UIButton) {
        gender = FEMALE_VALUE
        maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
    }
    @IBAction func onMarried(_ sender: UIButton) {
        relationship = MARRIED
        marriedImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        unmarriedImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    @IBAction func onUnmarried(_ sender: UIButton) {
        relationship = UNMARRIED
        marriedImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        unmarriedImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
    }
    @IBAction func onYes(_ sender: UIButton) {
        isCounsellingBefore = YES_VALUE
        yesImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        noImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
    }
    @IBAction func onNo(_ sender: UIButton) {
        isCounsellingBefore = NO_VALUE
        yesImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        noImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
    }
    @IBAction func onContinue(_ sender: UIButton) {
       
        self.onQuestion()
    }
    
    @IBAction func onDonePickerView(_ sender: Any) {
        
        
        pickerView.isHidden = true
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Methods
    func initializedDetails(){
        counsellingType = -1
        gender = -1
        relationship = -1
        isCounsellingBefore = -1
        
        //        questionTableView.register(UINib(nibName: "QuestionOptionNewTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionOptionNewCell")
        
        questionTableView.register(UINib(nibName: "QuestionOptionNewTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionOptionNewCell")
        
    }
    
    func onQuestion(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [QUESTIONS:
                                self.questionRootModel?.data?.toJSONString() ?? ""] as [String : Any]
            QuestionServices.shared.sendQuestionAnswers(parameters: parameters, success: { (statusCode, questionModel) in
                Utility.hideIndicator()
                if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                    do{
                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                            UserDefaults.standard.set(loginDetails.data?.role, forKey: "UserType")
                            loginDetails.data?.flag = questionModel.data?.flag
                            do{
                                let data = try NSKeyedArchiver.archivedData(withRootObject: loginDetails, requiringSecureCoding: false)
                                UserDefaults.standard.set(data, forKey: USER_DETAILS)
                                //                                let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                                //                                               let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                                //                                control.psychologistId = self.psychologistId
                                //                                               self.navigationController?.pushViewController(control, animated: true)
                                self.gotoTabBarScreen()
                            }catch{
                                print(error)
                            }
                        }
                    }catch{}
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
    
    func gotoTabBarScreen(){
        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    var PICKER_MIN = 18
    var PICKER_MAX = 99
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PICKER_MAX - PICKER_MIN + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + PICKER_MIN)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        let yearValueSelected = row + 18
        englishModel?[selectedIndex.section].value = "\(yearValueSelected)"
        arebicModel?[selectedIndex.section].value = "\(yearValueSelected)"
        questionTableView.reloadData()
        print(yearValueSelected)
    }
}

extension QuestionScreen: UITableViewDelegate, UITableViewDataSource {
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            return self.arebicModel?.count ?? 0
        }else{
        return self.englishModel?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            if( arebicModel?[section].options?.count == 0){
                return 1
            }
            return arebicModel?[section].options?.count ?? 0
        }else{
            if( englishModel?[section].options?.count == 0){
                return 1
            }
            return englishModel?[section].options?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionOptionNewCell", for:indexPath) as! QuestionOptionNewTableViewCell
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            if(arebicModel?[indexPath.section].options?.count == 0){
                cell.checkUncheckImageView.isHidden = true
                
                if(arebicModel?[indexPath.section].value == ""){
                    cell.optionLabel.text = Utility.getLocalizdString(value: "PLEASE_SELECT_AGE")
                    arebicModel?[indexPath.section].value = ""
                }else{
                    cell.optionLabel.text = "\(arebicModel?[indexPath.section].value ?? "18") \(Utility.getLocalizdString(value: "YEARS"))"
                }
            }
            else{
                cell.checkUncheckImageView.isHidden = false
                let item = arebicModel?[indexPath.section].options?[indexPath.row]
                print(item)
                cell.optionLabel.text = item?.option
                if(!(item?.value ?? false)){
                    cell.checkUncheckImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
                }else{
                    cell.checkUncheckImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
                }
                
            }
        }else{
        if(englishModel?[indexPath.section].options?.count == 0){
            cell.checkUncheckImageView.isHidden = true
            
            if(englishModel?[indexPath.section].value == ""){
                cell.optionLabel.text = Utility.getLocalizdString(value: "PLEASE_SELECT_AGE")
                englishModel?[indexPath.section].value = ""
            }else{
                cell.optionLabel.text = "\(englishModel?[indexPath.section].value ?? "18") \(Utility.getLocalizdString(value: "YEARS"))"
            }
        }
        else{
            cell.checkUncheckImageView.isHidden = false
            let item = englishModel?[indexPath.section].options?[indexPath.row]
            print(item)
            cell.optionLabel.text = item?.option
            if(!(item?.value ?? false)){
                cell.checkUncheckImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            }else{
                cell.checkUncheckImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
            }
            
        }
    }
        //        cell.
        //  detailLabel.text = item.name
        //        print(sections[indexPath.section].collapsed)
        
        
        tableView.tableFooterView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel?
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
         label = {
            let lb = UILabel()
            lb.textAlignment = .right
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.text = arebicModel?[section].question
            lb.textColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
            lb.font = UIFont(name: "Quicksand-SemiBold", size: 18)
            //              lb.backgroundColor = .yellow
            lb.numberOfLines = 0
            
            if("هل شعرت في الآونة الأخيرة  \n\nبمشاعر حزن عميقة" == arebicModel?[section].question){
               
            

                let yourString = (arebicModel?[section].question ?? "")
                let yourAttributedString = NSMutableAttributedString(string: yourString)
                let boldString = "هل شعرت في الآونة الأخيرة"
                let boldRange = (yourString as NSString).range(of: boldString)
                yourAttributedString.addAttribute(.font, value: UIFont(name: "Quicksand-Bold", size: 20)!, range: boldRange)
                lb.attributedText = yourAttributedString
            }
            
            return lb
        }()
        }else{
             label = {
                let lb = UILabel()
                lb.textAlignment = .left
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.text = englishModel?[section].question
                lb.textColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
                lb.font = UIFont(name: "Quicksand-Medium", size: 18)
                //              lb.backgroundColor = .yellow
                lb.numberOfLines = 0
                
                if("Recently, you have experienced \n\noverwhelming feelings of sadness" == englishModel?[section].question){
                   
                

                    let yourString = (englishModel?[section].question ?? "")
                    let yourAttributedString = NSMutableAttributedString(string: yourString)
                    let boldString = "Recently, you have experienced"
                    let boldRange = (yourString as NSString).range(of: boldString)
                    yourAttributedString.addAttribute(.font, value: UIFont(name: "Quicksand-Bold", size: 20)!, range: boldRange)
                    lb.attributedText = yourAttributedString
                }
                
                return lb
            }()

        }
        let header: UIView = {
            let hd = UIView()
            hd.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            hd.addSubview(label!)
            label!.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 8).isActive = true
            label!.topAnchor.constraint(equalTo: hd.topAnchor, constant: 8).isActive = true
            label!.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: -8).isActive = true
            label!.bottomAnchor.constraint(equalTo: hd.bottomAnchor, constant: -8).isActive = true
            return hd
        }()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        73
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionOptionNewCell", for:indexPath) as! QuestionOptionNewTableViewCell
        
        if(englishModel?[indexPath.section].options?.count == 0){
            pickerView.isHidden = false
            selectedIndex = indexPath
        }else{
            let englishItem = englishModel?[indexPath.section].options?[indexPath.row]
            let arabicItem = arebicModel?[indexPath.section].options?[indexPath.row]
            
            for index in 0...englishModel![indexPath.section].options!.count-1{
                let item =  englishModel?[indexPath.section].options?[index]
                let arebicitem =  arebicModel?[indexPath.section].options?[index]
                
                item?.value = false
                arebicitem?.value = false
                
            }
            if(!(englishItem?.value ?? false)){
                cell.checkUncheckImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
                englishItem?.value = true
                arabicItem?.value = true
            }else{
                cell.checkUncheckImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
                englishItem?.value = false
                arabicItem?.value = false
            }
            
            questionTableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.questionTableViewHeightConstraint.constant  = tableView.contentSize.height
        }
    }
    
}
