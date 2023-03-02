//
//  CountryScreen.swift
//  telehealth
//
//  Created by iroid on 07/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol selectedCountryDelegate: class {
    func getSelectedCountryData(CountryData:CountryInformation)
   
}

class CountryScreen: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var upDownButton: UIButton!
    
    var cityInformationArray:[CountryInformation] = []
    var delegate:selectedCountryDelegate?
    var searchCityInformationArray:[CountryInformation] = []
    
    var search:String = ""
    var searching:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewConstraint = containerViewConstraint.setMultiplier(multiplier: 0.40)
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.register(UINib(nibName: "OnCountryTableViewCell", bundle: nil), forCellReuseIdentifier: "OnCountryCell")
        countryTableView.tableFooterView = UIView()
        getCountryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    @IBAction func onUpDownButton(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            containerViewConstraint = containerViewConstraint.setMultiplier(multiplier: 0.40)
        }else{
            sender.isSelected = true
            print(containerViewConstraint.constant)
            containerViewConstraint = containerViewConstraint.setMultiplier(multiplier: 0.80)
            print(containerViewConstraint.constant)
        }
        
    }
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:Get country list Api Call
    func getCountryList() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            PsychologistsServices.shared.getCountry(success: { (statusCode, CityModel) in
                Utility.hideIndicator()
                self.cityInformationArray.append(contentsOf: (CityModel.data?.data)!)
                    self.countryTableView.reloadData()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }
    }
    
    func filterContentForSearchText(searchText: String) {
         searchCityInformationArray = cityInformationArray.filter { term in
            return (term.name?.lowercased().contains(searchText.lowercased()))!
          }
        }
     

}

extension CountryScreen : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching){
            return searchCityInformationArray.count
        }else{
            return cityInformationArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnCountryCell", for: indexPath) as! OnCountryTableViewCell
        if(searching){
            cell.countryLabel.text =  searchCityInformationArray[indexPath.row].name
            Utility.setImage(searchCityInformationArray[indexPath.row].flag, imageView: cell.countryFlagImageView)
        }else{
            cell.countryLabel.text =  cityInformationArray[indexPath.row].name
            Utility.setImage(cityInformationArray[indexPath.row].flag, imageView: cell.countryFlagImageView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searching){
             delegate?.getSelectedCountryData(CountryData: searchCityInformationArray[indexPath.row])
        }else{
          delegate?.getSelectedCountryData(CountryData: cityInformationArray[indexPath.row])
        }
       
        self.dismiss(animated: true, completion: nil)
    }
}
extension CountryScreen : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        upDownButton.isSelected = true
        containerViewConstraint = containerViewConstraint.setMultiplier(multiplier: 0.80)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
             search = String(search.dropLast())
         }
        else
        {
            search=textField.text!+string
        }
        if search == ""{
              searching = false
             countryTableView.reloadData()
             return true
        }
        searching = true
        filterContentForSearchText(searchText: search)
        countryTableView.reloadData()
        print(searchCityInformationArray)
        return true
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
