//
//  PsychologistsScreen.swift
//  telehealth
//
//  Created by Apple on 17/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PsychologistsScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var psychologistTableView: UITableView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var specialityFilterView: dateSportView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var specialityFilterViewHeightConstraint: NSLayoutConstraint!
    var itemPsychologistsObservale : Observable<[PsychologistsInformationModel]>!
    
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    
    var psychologistsArray = [PsychologistsInformationModel]()
    var specialityModel:SpecialityInformationModel!
    var metaData:MetaDataModel!
    var isFromSpeciality = Bool()
    var isFromFilter = Bool()
    var parameter = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
//        self.setupPsychologistCollectionViewSelectMethod()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onFilterScreen(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "FilterScreen") as! FilterScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    
    @IBAction func onCancelSpeciality(_ sender: Any) {
        specialityFilterView.isHidden = true
        specialityFilterViewHeightConstraint.constant = 0
        isFromSpeciality = false
        self.metaData = nil
        self.getPsychologist()
    }
    
    func initalizedDetails(){
           psychologistTableView.register(UINib(nibName: "PsychologistsTableViewCell", bundle: nil), forCellReuseIdentifier: "PsychologistCell")
        if(isFromSpeciality){
            specialityFilterView.isHidden = false
            specialityFilterViewHeightConstraint.constant = 25
        }else{
            specialityFilterView.isHidden = true
            specialityFilterViewHeightConstraint.constant = 0
        }
        if(isFromSpeciality){
            filterLabel.text = specialityModel.speciality
            getPsychologist(speciality: specialityModel!.id)
        }else{
            getPsychologist()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.psychologistsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.psychologistsArray[indexPath.row]
        let cell = self.psychologistTableView.dequeueReusableCell(withIdentifier: "PsychologistCell", for:indexPath) as! PsychologistsTableViewCell
        Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
        
        let education = data.education?.replacingOccurrences(of: "\n", with: ", ") ?? ""
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? "")"
    //            cell.yearExpLabel.text = "\(education)"
             cell.yearExpLabel.text = "سنوات الخبرة: \(data.yearOfExperience ?? "")"
    //            let string = data.speciality?.componentsJoined(by: ",")
//            let language = data.languages!.replacingOccurrences(of: ",", with: ", ")
//            cell.specialityDiscriptionLabel.text = "\(language ) :\(Utility.getLocalizdString(value: "LANGUAGE"))"
            cell.educationViewHeightConstraint.constant = 17
            cell.nameTopConstraint.constant = 10
            cell.educationLabel.text = data.education
            cell.educationLabelBottomConstraint.constant = 3
        }else{
            cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? ""), \(education)"
    //            cell.yearExpLabel.text = "\(education)"
             cell.yearExpLabel.text = "Experience: \(data.yearOfExperience ?? "") years"
    //            let string = data.speciality?.componentsJoined(by: ",")
//            let language = data.languages!.replacingOccurrences(of: ",", with: ", ")
//            cell.specialityDiscriptionLabel.text = "Languages: \(language )"
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
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
//            cell.specialityDiscriptionLabel.text = "Language: English,Arabic"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = psychologistsArray[indexPath.row]
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
     
    
    
//    func loadPsychologistTable(){
//          psychologistTableView.dataSource = nil
//        itemPsychologistsObservale.bind(to: psychologistTableView.rx.items(cellIdentifier: "PsychologistCell", cellType:PsychologistsTableViewCell.self)){(row,data,cell) in
//            Utility.setImage(data.profile ?? "", imageView: cell.profileImageView)
//
//            let education = data.education!.replacingOccurrences(of: "\n", with: ", ")
//            cell.nameLabel.text = "\(data.firstname ?? "") \(data.lastname ?? ""), \(education)"
////            cell.yearExpLabel.text = "\(education)"
//             cell.yearExpLabel.text = "Experience: \(data.yearOfExperience ?? "") years"
////            let string = data.speciality?.componentsJoined(by: ",")
//            let language = data.languages!.replacingOccurrences(of: ",", with: ", ")
//            cell.specialityDiscriptionLabel.text = "Languages: \(language )"
////            cell.specialityDiscriptionLabel.text = "Language: English,Arabic"
//        }.disposed(by: disposeBag)
//      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(psychologistsArray.count - 1 == indexPath.row){
            if(self.metaData.has_more_pages != nil){
                if(self.metaData.has_more_pages!){
                    self.getPsychologist()
                }
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
            var parameters = [:] as [String : Any]
            if(isFromFilter){
                parameters = self.parameter
            }else if(isFromSpeciality){
                var specialityArray = [Int]()
                specialityArray.append(specialityModel.id!)
                 parameters = ["speciality":specialityArray]
            }
            HomeServices.shared.getPsychologist(parameters: parameters,url: url, success: { (statusCode, psychologistModel) in
                Utility.hideIndicator()
                self.psychologistsArray.append(contentsOf: (psychologistModel.data)!)
                self.itemPsychologistsObservale = Observable.just((self.psychologistsArray))
                if(self.psychologistsArray.count > 0){
                    self.noDataFoundView.isHidden = true
                }else{
                    self.noDataFoundView.isHidden = false
                }
                self.metaData = psychologistModel.meta
//                self.loadPsychologistTable()
                self.psychologistTableView.reloadData()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
//    func setupPsychologistCollectionViewSelectMethod(){
//        self.psychologistTableView.rx.modelSelected(PsychologistsInformationModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//
//                                }
////                let storyBoard = UIStoryboard(name: "Question", bundle: nil)
////                let control = storyBoard.instantiateViewController(withIdentifier: "QuestionScreen") as! QuestionScreen
////                control.psychologistId = item.id ?? 0
////                self.navigationController?.pushViewController(control, animated: true)
//            }).disposed(by: disposeBag)
//    }
//}

//MARK:UITableViewDelegate
//extension PsychologistsScreen:UITableViewDelegate{
//
//}
}
