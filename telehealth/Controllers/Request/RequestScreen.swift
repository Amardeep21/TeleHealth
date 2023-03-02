//
//  RequestScreen.swift
//  telehealth
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class RequestScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var upcommingButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var empthyView: UIView!
    
    var requestArray = [RequestModel]()
    var metaData:MetaDataModel!
    var currentType:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizedDetails()
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
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onUpcomming(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pastButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pastButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1), for: .normal)
        requestArray.removeAll()
        currentType = 2
        self.metaData = nil
        self.getRequestList(type: currentType)
    }
    
    @IBAction func onPast(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.6524584293, blue: 0.6421023607, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        upcommingButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        upcommingButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1), for: .normal)
        requestArray.removeAll()
        currentType = 1
        self.metaData = nil
        self.getRequestList(type: currentType)
        
    }
    
    func initalizedDetails(){
        self.requestTableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        self.empthyView.isHidden = true
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            if #available(iOS 11.0, *){
                upcommingButton.clipsToBounds = false
                upcommingButton.layer.cornerRadius = 8
                upcommingButton.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            }
            if #available(iOS 11.0, *){
                pastButton.clipsToBounds = false
                pastButton.layer.cornerRadius = 8
                pastButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }
        }else{
            if #available(iOS 11.0, *){
                upcommingButton.clipsToBounds = false
                upcommingButton.layer.cornerRadius = 8
                upcommingButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }
            if #available(iOS 11.0, *){
                pastButton.clipsToBounds = false
                pastButton.layer.cornerRadius = 8
                pastButton.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            }
        }
        getRequestList(type: currentType)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.requestArray[indexPath.row]
        let cell = self.requestTableView.dequeueReusableCell(withIdentifier: "RequestCell", for:indexPath) as! RequestTableViewCell
        cell.nameLabel.text = item.username
        Utility.setImage(item.profile, imageView: cell.profileImageView)
        cell.onProfileButton.tag = indexPath.row
        cell.messageButton.tag = indexPath.row
        cell.onBook.tag = indexPath.row
        cell.onDelete.tag = indexPath.row
        if(currentType == 1){
            cell.onDelete.isHidden = true
        }else{
            cell.onDelete.isHidden = false
        }
        cell.onProfileButton.addTarget(self,action:#selector(profileButtonClicked(sender:)), for: .touchUpInside)
        cell.onBook.addTarget(self,action:#selector(bookButtonClicked(sender:)), for: .touchUpInside)
        cell.onDelete.addTarget(self,action:#selector(deleteButtonClicked(sender:)), for: .touchUpInside)
        cell.messageButton.addTarget(self,action:#selector(messageButtonClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func profileButtonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let item = self.requestArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.profile ?? ""
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    @objc func messageButtonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let item = self.requestArray[buttonRow]
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ChatScreen") as! ChatScreen
        confirmAlertController.requestModel = item
        confirmAlertController.isFromRequest = true
        self.navigationController?.pushViewController(confirmAlertController, animated: true)
    }
    
    @objc func bookButtonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let item = self.requestArray[buttonRow]
        let storyBoard = UIStoryboard(name: "UserCalendar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "SelectSessionByUserScreen") as! SelectSessionByUserScreen
        control.isFromRequest = true
        if(currentType == 1){
            control.isFromPastRequest = true
        }else{
            control.isFromPastRequest = false
        }
        control.requestModel = item
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @objc func deleteButtonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let item = self.requestArray[buttonRow]
        onCancelRequest(requestID:item.requestId!,index:buttonRow)
    }
    
    func checkForEmpthyArray(){
        if(requestArray.count == 0){
            empthyView.isHidden = false
        }else{
            empthyView.isHidden = true
        }
    }
    
    func onCancelRequest(requestID:Int,index:Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            RequestServices.shared.cancelFreeSession(url: "\(CANCEL_REQUEST)\(requestID)", success: { (statusCode, requestModel) in
                Utility.hideIndicator()
                self.requestArray.remove(at: index)
                self.checkForEmpthyArray()
                self.requestTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let model = self.requestArray[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(requestArray.count - 1 == indexPath.row){
            if(self.metaData.has_more_pages != nil){
                if(self.metaData.has_more_pages!){
                    self.getRequestList(type: currentType)
                }
            }
        }
    }
    
    func loadMoreUrl(type:Int = 1) -> String{
        var url = String()
        if(self.metaData == nil){
            url = "\(GET_REQUEST_LIST)\(type)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            
            url = "\(GET_REQUEST_LIST)\(urlArray?.last ?? "")"
        }
        return url
    }
    
    func getRequestList(type:Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = self.loadMoreUrl(type: type)
            RequestServices.shared.getRequest(parameters: [:],url: url, success: { (statusCode, requestModel) in
                Utility.hideIndicator()
                if(self.metaData == nil){
                    self.requestArray = []
                    self.requestArray = requestModel.data!
                }else{
                    self.requestArray.append(contentsOf: requestModel.data!)
                }
                self.checkForEmpthyArray()
                self.metaData = requestModel.meta
                self.requestTableView.reloadData()
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
