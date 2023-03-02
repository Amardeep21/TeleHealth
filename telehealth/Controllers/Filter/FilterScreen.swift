//
//  FilterScreen.swift
//  telehealth
//
//  Created by iroid on 18/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRangeSlider

class FilterScreen: UIViewController {
    
    //MARK:UITextField IBOutlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var maxTextfield: UITextField!
    @IBOutlet weak var minTextfield: UITextField!
    
    //MARK:UITableView IBOutlet
    @IBOutlet weak var specialityTableView: UITableView!
    @IBOutlet weak var newlanguageTableView: UITableView!
    @IBOutlet weak var languageCollectionView: UICollectionView!
    
    @IBOutlet weak var languageTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageCollectionHeightConstraint: NSLayoutConstraint!
    
    //MARK:NSLayoutConstraint IBOutlet
    @IBOutlet weak var tableContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var consulationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearExperienceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var genderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK:UILabel IBOutlet
    @IBOutlet weak var allDotLabel: UILabel!
    @IBOutlet weak var minMaxDotLabel: UILabel!
    @IBOutlet weak var yearOfExperienceLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var maleDotLabel: UILabel!
    @IBOutlet weak var femaleDotLabel: UILabel!
    //MARK:UIImageView IBOutlet
    @IBOutlet weak var specialityDownIconImageView: UIImageView!
    @IBOutlet weak var consultationDownIconImageView: UIImageView!
    @IBOutlet weak var languageDownIconImageView: UIImageView!
    @IBOutlet weak var yearExperienceDownIconImageView: UIImageView!
    @IBOutlet weak var genderDownArrowImageView: UIImageView!
    
    @IBOutlet weak var languageDownArrowImageView: UIImageView!
    //MARK:UIView IBOutlet
    @IBOutlet weak var specialityContainerView: UIView!
    @IBOutlet weak var consultationPriceView: UIView!
    @IBOutlet weak var languageContainerView: UIView!
    @IBOutlet weak var yearOfExperienceContainerView: UIView!
    @IBOutlet weak var searchOuterView: UIView!
    
    @IBOutlet weak var genderContainerView: UIView!
    @IBOutlet weak var yearOfExperienceSlider: RangeSlider!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var confirmationAlertView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var languageBorderLabel: UILabel!
    @IBOutlet weak var searchLanguageTextField: UITextField!
    
    @IBOutlet weak var allCheckMarkImageView: UIImageView!
    @IBOutlet weak var minMaxCheckMarkImageView: UIImageView!
    
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    
    var itemPsychologistsObservale : Observable<[PsychologistsInformationModel]>!
    var selectedLanguageItem : Observable<[LanguageData]>!
    var psychologistsArray = [PsychologistsInformationModel]()
    
    var metaData:MetaDataModel!
    //MARK: Variables
    var specialityItem : Observable<[SpecialityInformationModel]>!
    var specialityArray = [SpecialityInformationModel]()
    var languageArray:[LanguageData] = []
    var languageItem : Observable<[LanguageData]>!
    
    var minYearExperience = 0
    var maxYearExperience = 30
    var specialityTableHeight = 0.0
    var languageTableHeight = 0.0
    var genderType = -1
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    var searchLanguageResultArray = [LanguageData]()
    var selectedLanguageArray = [LanguageData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDetail()
        self.searchByName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupPsychologistCollectionViewSelectMethod()
//        loadSpecialityTable()
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
            searchTextField.textAlignment = .right
            searchLanguageTextField.textAlignment = .right
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
            searchTextField.textAlignment = .left
            searchLanguageTextField.textAlignment = .left
            
        }   
    }
    //MARK:Initialise Detail
    func initialiseDetail(){
        languageCollectionHeightConstraint.constant = 0
        languageTableHeightConstraint.constant = 0
        languageCollectionView.dataSource = self
        searchTableView.register(UINib(nibName: "PsychologistsTableViewCell", bundle: nil), forCellReuseIdentifier: "PsychologistCell")
        specialityTableView.register(UINib(nibName: "SpecialityCell", bundle: nil), forCellReuseIdentifier: "SpecialityTableCell")
        //        languageTableView.register(UINib(nibName: "SpecialityCell", bundle: nil), forCellReuseIdentifier: "SpecialityTableCell")
        
        newlanguageTableView.register(UINib(nibName: "LanguageTableCell", bundle: nil), forCellReuseIdentifier: "LanguageTableCell")
        languageCollectionView.register(UINib(nibName: "LanguageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LanguageCollectionCell")
        let layout = MyLeftCustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        languageCollectionView.collectionViewLayout = layout
//        searchLanguageTextField.attributedPlaceholder = NSAttributedString(string: "Search Languages",
//                                                                           attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.5) ,.font: UIFont(name: "Quicksand-Regular", size: 13)!])
//        
//        maxTextfield.attributedPlaceholder = NSAttributedString(string:"Max $", attributes:[NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.7)])
//        minTextfield.attributedPlaceholder = NSAttributedString(string:"Min $", attributes:[NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.7)])
//        maxTextfield.layer.borderColor = #colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.7)
//        maxTextfield.layer.borderWidth = 0.5
//        minTextfield.layer.borderColor = #colorLiteral(red: 0.00586764561, green: 0.02545303665, blue: 0.0380487591, alpha: 0.7)
//        minTextfield.layer.borderWidth = 0.5
//        minTextfield.layer.cornerRadius = 4
//        maxTextfield.layer.cornerRadius = 4
        confirmationAlertView.isHidden = true
//        femaleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        femaleDotLabel.layer.borderWidth = 0.5
//        maleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        maleDotLabel.layer.borderWidth = 0.5
        
       
        
        maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        self.getSpecialityList()
        self.getLanguages()
        self.didSelect()
        // self.languageDidSelect()
    }
    func searchByName(){
        Observable.zip(searchTextField.rx.text,
                       searchTextField.rx.text.skip(1))
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (old, new) in
                if(new != ""){
                    self.searchView.isHidden = false
                    //                self.mainScrollView.isHidden = true
                    self.metaData = nil
                    if(old != new){
                       
                        self.getPsychologist()
                    }
                }else{
                    self.searchView.isHidden = true
                    //                self.mainScrollView.isHidden = false
                    self.metaData = nil
                    self.metaData = nil
                }
            }).disposed(by: disposeBag)
        
        searchTableView.rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                if(self.psychologistsArray.count - 1 == indexPath.row){
                    if(self.metaData.has_more_pages!){
                        self.getPsychologist()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    func loadMoreUrl(speciality: Int) -> String{
        var url = String()
        if(self.metaData == nil){
            url = "\(PSYCHOLOGIST_API)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            
            url = "\(urlArray?.last ?? "")"
        }
        return url
    }
    
    func getPsychologist(speciality: Int? = 1){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = self.loadMoreUrl(speciality: speciality!)
            let parameters = [NAME:searchTextField.text!] as [String : Any]
            HomeServices.shared.getPsychologist(parameters: parameters,url: url, success: { (statusCode, psychologistModel) in
                Utility.hideIndicator()
                if(self.metaData == nil){
                    self.psychologistsArray = []
                    self.psychologistsArray.append(contentsOf: (psychologistModel.data)!)
                }else{
                    self.psychologistsArray.append(contentsOf: (psychologistModel.data)!)
                }
                self.itemPsychologistsObservale = Observable.just((self.psychologistsArray))
                self.metaData = psychologistModel.meta
                self.loadPsychologistTable()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func loadPsychologistTable(){
        searchTableView.dataSource = nil
        itemPsychologistsObservale.bind(to: searchTableView.rx.items(cellIdentifier: "PsychologistCell", cellType:PsychologistsTableViewCell.self)){ [self](row,data,cell) in
            Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
            cell.profileButton.tag = row
            cell.profileButton.addTarget(self,action:#selector(self.buttonClicked(sender:)), for: .touchUpInside)
            cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? "")"
            cell.educationLabel.text = data.education
            let education = data.education?.replacingOccurrences(of: "\n", with: ", ") ?? ""
            if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? "")"
                 cell.yearExpLabel.text = "سنوات الخبرة: \(data.yearOfExperience ?? "")"
                cell.educationViewHeightConstraint.constant = 17
                cell.nameTopConstraint.constant = 10
                cell.educationLabel.text = data.education
                cell.educationLabelBottomConstraint.constant = 3
            }else{
                cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? ""), \(education)"
                 cell.yearExpLabel.text = "Experience: \(data.yearOfExperience ?? "") years"
                cell.educationLabelBottomConstraint.constant = 8
                cell.educationViewHeightConstraint.constant = 0
                cell.nameTopConstraint.constant = 17
                cell.educationLabel.text = data.education
            }

            if(data.chatConsultationPrice != nil && data.chatConsultationPrice != "" &&  data.chatConsultationPrice != "0"){
                cell.chatView.isHidden = false
                cell.chatLabel.text = "KD \(data.chatConsultationPrice ?? "")"
            }else{
                cell.chatView.isHidden = true
            }
            if(data.AudioVideoMinConsultationPrice != nil && data.AudioVideoMinConsultationPrice != "" &&  data.AudioVideoMinConsultationPrice != "0"){
                cell.videoView.isHidden = false
                cell.audioVideoLable.text = "KD \(data.AudioVideoMinConsultationPrice ?? "")"
            }else{
                cell.videoView.isHidden = true
            }
            let string = data.speciality?.componentsJoined(by: ",")
//            cell.specialityDiscriptionLabel.text = string
        }.disposed(by: disposeBag)
    }
    
    func setupPsychologistCollectionViewSelectMethod(){
        self.searchTableView.rx.modelSelected(PsychologistsInformationModel.self)
            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
            .subscribe(onNext: {
                item in
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
                //                let storyBoard = UIStoryboard(name: "PsychologistDetail", bundle: nil)
                //                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistDetailScreen") as! PsychologistDetailScreen
                //                control.profileImageUrl = item.profile ?? ""
                //                control.psychologistId = item.id ?? 0
                //                control.psychologistName = "\(item.firstname ?? "") \(item.lastname ?? "")"
                //                self.navigationController?.pushViewController(control, animated: true)
            }).disposed(by: disposeBag)
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
    
    func didSelect(){
        Observable
            .zip(specialityTableView.rx.itemSelected, specialityTableView.rx.modelSelected(SpecialityInformationModel.self))
            .bind { [unowned self] indexPath, model in
                if let cell = self.specialityTableView.cellForRow(at: indexPath) as? SpecialityCell {
                    if(cell.tapButton.isSelected)
                    {
                        cell.tapButton.isSelected = false
                        cell.checkMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
                        model.isSelected = true
                    }
                    else
                    {
                        cell.tapButton.isSelected = true
                        cell.checkMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
                        model.isSelected = false
                    }
                }
        }.disposed(by: disposeBag)
    }
    
    //    func languageDidSelect(){
    //        Observable
    //            .zip(languageTableView.rx.itemSelected, languageTableView.rx.modelSelected(LanguageData.self))
    //            .bind { [unowned self] indexPath, model in
    //                if let cell = self.languageTableView.cellForRow(at: indexPath) as? SpecialityCell {
    //                    if(cell.tapButton.isSelected)
    //                    {
    //                        cell.tapButton.isSelected = false
    //                        cell.dotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
    //                        cell.dotLabel.layer.borderWidth = 0.0
    //                        model.isSelected = true
    //                    }
    //                    else
    //                    {
    //                        cell.tapButton.isSelected = true
    //                        cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //                        cell.dotLabel.layer.borderWidth = 0.5
    //                        model.isSelected = false
    //                    }
    //                }
    //        }
    //        .disposed(by: disposeBag)
    //    }
    
    
    func loadLanguageTable(){
        newlanguageTableView.dataSource = nil
        languageItem = Observable.just(searchLanguageResultArray)
        languageItem.bind(to: newlanguageTableView.rx.items(cellIdentifier: "LanguageTableCell", cellType:LanguageTableCell.self)){(row,item,cell) in
            print(item)
            cell.selectionStyle = .none
            cell.languageLabel.text = (self.searchLanguageResultArray[row]).name
        }.disposed(by: disposeBag)
        
        newlanguageTableView.rx.itemSelected.subscribe(onNext : {
            [weak self] indexPath in
            if(indexPath.row < self!.searchLanguageResultArray.count){
                if(self?.selectedLanguageArray.count == 0)
                {
                    self!.languageCollectionHeightConstraint.constant = 25
                }
                if( !self!.selectedLanguageArray.contains(where: {$0.name == (self!.searchLanguageResultArray[indexPath.row]).name})){
                    self!.selectedLanguageArray.append((self!.searchLanguageResultArray[indexPath.row]))
                    self!.languageTableHeightConstraint.constant = 0
                    //                    self!.loadSelectedLanguageCollection()
                    self?.languageCollectionView.reloadData()
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
    
    
    //    func loadSelectedLanguageCollection(){
    //        languageCollectionView.dataSource = nil
    //        selectedLanguageItem = Observable.just(selectedLanguageArray)
    //        print("selected language:\(selectedLanguageArray)")
    //        selectedLanguageItem.bind(to: languageCollectionView.rx.items(cellIdentifier: "LanguageCollectionCell", cellType:LanguageCollectionCell.self)){(row,item,cell) in
    //            // print(item)
    //            cell.layoutIfNeeded()
    //            if(row < self.selectedLanguageArray.count)
    //            {
    //                cell.languageName.text = "- \((self.selectedLanguageArray[row]).name ?? "")"
    //                cell.cancelButton.rx.tap.first()
    //                    .subscribe({ _ in
    //                        if(row < self.selectedLanguageArray.count)
    //                        {
    //                            self.selectedLanguageArray.remove(at: row)
    //                            if(self.selectedLanguageArray.count == 0)
    //                            {
    //                                self.languageCollectionHeightConstraint.constant = 0
    //                            }
    //                            else{
    //                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
    //                                }, completion: { (finished) -> Void in
    //                                    self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
    //                                });
    //                            }
    //                        }
    //                        self.loadSelectedLanguageCollection()
    //                    })
    //                    .disposed(by: self.disposeBag)
    //            }
    //
    //
    //        }.disposed(by: disposeBag)
    //    }
    
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
        print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
        minYearExperience = (Int(rangeSlider.lowerValue))
        maxYearExperience = (Int(rangeSlider.upperValue))
        yearOfExperienceLabel.text = "\(((Int(rangeSlider.lowerValue))))" + " \(Utility.getLocalizdString(value: "YEAR_FILTER")) - " + "\(((Int(rangeSlider.upperValue))))" + "+ \(Utility.getLocalizdString(value: "YEARS_FILTER"))"
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClearAll(_ sender: UIButton) {
        self.view.endEditing(true)
        confirmationAlertView.isHidden = false
    }
    
    @IBAction func onSpeciality(_ sender: UIButton) {
        if(sender.isSelected){
            specialityContainerView.isHidden = false
            sender.isSelected = false
            tableContainerHeightConstraint.constant = CGFloat(specialityTableHeight)
            specialityDownIconImageView.image = UIImage(named: "up_down_arrow.png")
        }
        else{
            sender.isSelected = true
            specialityContainerView.isHidden = true
            tableContainerHeightConstraint.constant = 0
            specialityDownIconImageView.image = UIImage(named: "drop_down_arrow.png")
        }
    }
    
    @IBAction func onConsultationPrice(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            consulationViewHeightConstraint.constant = 83
            consultationPriceView.isHidden = false
            consultationDownIconImageView.image = UIImage(named: "up_down_arrow.png")
        }
        else{
            sender.isSelected = true
            consulationViewHeightConstraint.constant = 0
            consultationPriceView.isHidden = true
            consultationDownIconImageView.image = UIImage(named: "drop_down_arrow.png")
        }
    }
    
    @IBAction func onAll(_ sender: UIButton) {
//        minMaxDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        minMaxDotLabel.layer.borderWidth = 0.5
//        allDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//        allDotLabel.layer.borderWidth = 0.0
        allCheckMarkImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        minMaxCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        
        minTextfield.text = ""
        maxTextfield.text = ""
        view.endEditing(true)
    }    
    
    @IBAction func onLanguage(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            searchContainerView.isHidden = false
            searchViewHeightConstraint.constant =  36
             if(languageArray.count > 0)
             {
                self.languageCollectionHeightConstraint.constant = self.languageCollectionView.collectionViewLayout.collectionViewContentSize.height
            }
             else{
                languageCollectionHeightConstraint.constant = 0
            }
            searchViewTopConstraint.constant = 15
            searchOuterView.isHidden = false
            languageBorderLabel.isHidden = false
            languageDownArrowImageView.image = UIImage(named: "up_down_arrow.png")
        }
        else{
            sender.isSelected = true
            languageBorderLabel.isHidden = true
            searchContainerView.isHidden = true
            searchViewHeightConstraint.constant = 0
            searchViewTopConstraint.constant = 0
            searchOuterView.isHidden = true
            languageCollectionHeightConstraint.constant = 0
            languageDownArrowImageView.image = UIImage(named: "drop_down_arrow.png")
            self.view.endEditing(true)
        }
    }
    
    
    @IBAction func onYearOfExperience(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            yearOfExperienceContainerView.isHidden = false
            yearExperienceHeightConstraint.constant = 121
            yearExperienceDownIconImageView.image = UIImage(named: "up_down_arrow.png")
        }
        else{
            sender.isSelected = true
            yearOfExperienceContainerView.isHidden = true
            yearExperienceHeightConstraint.constant = 0
            yearExperienceDownIconImageView.image = UIImage(named: "drop_down_arrow.png")
        }
    }
    
    
    @IBAction func onGender(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            genderContainerView.isHidden = false
            genderViewHeightConstraint.constant = 79
            genderDownArrowImageView.image = UIImage(named: "up_down_arrow.png")
        }
        else{
            sender.isSelected = true
            genderContainerView.isHidden = true
            genderViewHeightConstraint.constant = 0
            genderDownArrowImageView.image = UIImage(named: "drop_down_arrow.png")
        }
    }
    
    @IBAction func onMale(_ sender: UIButton) {
//        femaleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        femaleDotLabel.layer.borderWidth = 0.5
//        maleDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//        maleDotLabel.layer.borderWidth = 0.0
        
        maleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
       
        
        genderType = 1
    }
    
    @IBAction func onFemale(_ sender: UIButton) {
//        maleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        maleDotLabel.layer.borderWidth = 0.5
//        femaleDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//        femaleDotLabel.layer.borderWidth = 0.0
        maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
              femaleImageView.image = #imageLiteral(resourceName: "radio_check_mark_icon")
        genderType = 0
    }
    
    @IBAction func onApply(_ sender: UIButton) {
        
        var parameter = [String:Any]()
        let selectedSpecialityArrayOfDictionary = specialityArray.filter { $0.isSelected == true }
        let selectedSpecialityArray = selectedSpecialityArrayOfDictionary.compactMap({ $0.id })
        print(selectedSpecialityArray)

        let selectedLanguageNameString : [String] = selectedLanguageArray.map ({ $0.name! })
        if  minTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" &&  maxTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            parameter = ["speciality":selectedSpecialityArray,
                         "maxPrice":maxTextfield.text!,
                         "minPrice":minTextfield.text!,
                         "experienceFrom":minYearExperience,
                         "experienceTo":maxYearExperience,
                         "languages":selectedLanguageNameString,
                         "gender":genderType
                ] as [String : Any]
        }else{
            parameter = ["speciality":selectedSpecialityArray,
                         "maxPrice":maxTextfield.text!,
                         "minPrice":minTextfield.text!,
                         "experienceFrom":minYearExperience,
                         "experienceTo":maxYearExperience,
                         "languages":selectedLanguageNameString,
                         "gender":genderType
                ] as [String : Any]
        }
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
        control.parameter = parameter
        control.isFromFilter = true
        self.navigationController?.pushViewController(control, animated: true)
        confirmationAlertView.isHidden = true
    }
    
    @IBAction func onApplyConfirm(_ sender: UIButton) {
        //        self.clearAllData()
        var parameter = [String:Any]()
        let selectedSpecialityArrayOfDictionary = specialityArray.filter { $0.isSelected == true }
        let selectedSpecialityArray = selectedSpecialityArrayOfDictionary.compactMap({ $0.id })
        print(selectedSpecialityArray)
        let selectedLanguageModel : [LanguageData] = languageArray.filter {$0.isSelected == true}
        let selectedLanguageArray : [String] = selectedLanguageModel.map ({ $0.name! })
        if  minTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" &&  maxTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            parameter = ["speciality":selectedSpecialityArray,
                         "maxPrice":maxTextfield.text!,
                         "minPrice":minTextfield.text!,
                         "experienceFrom":minYearExperience,
                         "experienceTo":maxYearExperience,
                         "languages":selectedLanguageArray,
                         "gender":genderType
                ] as [String : Any]
        }else{
            parameter = ["speciality":selectedSpecialityArray,
                         "maxPrice":maxTextfield.text!,
                         "minPrice":minTextfield.text!,
                         "experienceFrom":minYearExperience,
                         "experienceTo":maxYearExperience,
                         "languages":selectedLanguageArray,
                         "gender":genderType
                ] as [String : Any]
        }
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
        control.parameter = parameter
        control.isFromFilter = true
        self.navigationController?.pushViewController(control, animated: true)
        confirmationAlertView.isHidden = true
    }
    
    @IBAction func onDiscard(_ sender: UIButton) {
        confirmationAlertView.isHidden = true
        clearAllData()
    }
    
    //MARK:Get Speciality list Api Call
    func getSpecialityList() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            HomeServices.shared.getSpeciality(success: { (statusCode, specialityModel) in
                Utility.hideIndicator()
                self.specialityArray = specialityModel.data!
                self.loadSpecialityTable()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
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
            cell.tapButton.isSelected = true
            cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.dotLabel.layer.borderWidth = 0.5
        }.disposed(by: disposeBag)
    }
    
    func clearAllData(){
        searchTextField.text = ""
        searchView.isHidden = true
        if(specialityArray.count > 0){
            for i in 0...specialityArray.count-1{
                let object = specialityArray[i]
                object.isSelected = false
            }
        }
        if(languageArray.count>0){
            for i in 0...languageArray.count-1{
                let object = languageArray[i]
                object.isSelected = false
            }
        }
        selectedLanguageArray.removeAll()
        languageCollectionView.reloadData()
        
        loadLanguageTable()
        loadSpecialityTable()
        minTextfield.text = ""
        maxTextfield.text = ""
        //minMaxDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //minMaxDotLabel.layer.borderWidth = 0.5
        allDotLabel.layer.borderWidth = 0.0
        yearOfExperienceSlider.minimumValue = 0
        yearOfExperienceSlider.maximumValue = 30
        yearOfExperienceSlider.upperValue = 30
        yearOfExperienceSlider.lowerValue = 0
        //allDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      //  allDotLabel.layer.borderWidth = 0.5
        
        allCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        minMaxCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        yearOfExperienceLabel.text = Utility.getLocalizdString(value: "ZERO_YEAR_30")
        minYearExperience = 0
        maxYearExperience = 30
        genderType = -1
//        femaleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        femaleDotLabel.layer.borderWidth = 0.5
//        maleDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        maleDotLabel.layer.borderWidth = 0.5
        
        maleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
        femaleImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")

    }
    //MARK:Get getLanguages list Api Call
    func getLanguages() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            FilterServices.shared.getLanguage(success: { (statusCode, LanguageModel) in
                Utility.hideIndicator()
                self.languageArray.append(contentsOf: LanguageModel.data!)
                self.loadLanguageTable()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: Load Language Table
    //    func loadLanguageTable(){
    //        // Set automatic dimensions for row height
    //        languageTableView.dataSource = nil
    //        languageItem = Observable.just(languageArray)
    //        languageItem.bind(to: languageTableView.rx.items(cellIdentifier: "SpecialityTableCell", cellType:SpecialityCell.self)){(row,item,cell) in
    //            print(item)
    //            cell.selectionStyle = .none
    //            cell.specialityTypeLabel.text = item.name
    //            cell.tapButton.isSelected = true
    //            cell.dotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //            cell.dotLabel.layer.borderWidth = 0.5
    //        }.disposed(by: disposeBag)
    //
    //    }
}
//MARK:UITableViewDelegate
extension FilterScreen:UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == specialityTableView{
            self.tableContainerHeightConstraint.constant = self.specialityTableView.contentSize.height + 15
            self.specialityTableView.layoutIfNeeded()
            self.specialityTableHeight = Double(self.tableContainerHeightConstraint.constant)
        }else{
            DispatchQueue.main.async {
                //                self.languageTableView.layoutIfNeeded()
                //                self.languageViewHeightConstraint.constant = tableView.contentSize.height + 20
                //                self.languageTableHeight = Double(self.languageViewHeightConstraint.constant)
            }
        }
        
    }
}
extension FilterScreen: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchLanguageTextField != textField{
//            minMaxDotLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//            minMaxDotLabel.layer.borderWidth = 0.0
//            allDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            allDotLabel.layer.borderWidth = 0.5
            
            allCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            minMaxCheckMarkImageView.image =  #imageLiteral(resourceName: "radio_check_mark_icon")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchLanguageTextField == textField{
            if searchLanguageTextField.text == ""
            {
                languageBorderLabel.isHidden = true
                languageTableHeightConstraint.constant = 0
                searchLanguageResultArray.removeAll()
                loadLanguageTable()
            }
        }else{
            if  minTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" &&  maxTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
//                minMaxDotLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                minMaxDotLabel.layer.borderWidth = 0.5
               
                minMaxCheckMarkImageView.image = #imageLiteral(resourceName: "uncheckmark_icon")
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if searchLanguageTextField == textField{
            if textField.text == ""
            {
                languageBorderLabel.isHidden = true
                languageTableHeightConstraint.constant = 0
                searchLanguageResultArray.removeAll()
                loadLanguageTable()
            }
        }
        
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
}
extension FilterScreen : UICollectionViewDataSource,UICollectionViewDelegate{
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


