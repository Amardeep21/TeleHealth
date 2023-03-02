//
//  NotificationListScreen.swift
//  telehealth
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

class NotificationListScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    @IBOutlet weak var bacckButton: UIButton!
    
    var notificationArray = [NotificationModel]()
    //    var notificatioItems : Observable<[NotificationModel]>!
    var metaData:MetaDataModel!
    // var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        
        if(Utility.getCurrentLanguage() == "ar"){
            bacckButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            bacckButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initalizedDetails(){
        notificationTableView.register(UINib(nibName: "NotificatioTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        notificationTableView.register(UINib(nibName: "PayAndConfirmTableViewCell", bundle: nil), forCellReuseIdentifier: "PayAndConfirmCell")
        getNotification()
    }
    
    func loadMoreUrl() -> String{
        var url = String()
        if(self.metaData == nil){
            url = "\(GET_NOTIFICATION_API)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            
            url = "\(urlArray?.last ?? "")"
        }
        return url
    }
    
    //    func loadNotificationList(){
    //        notificationTableView.dataSource = nil
    //        notificatioItems = Observable.just(notificationArray)
    //        notificatioItems.bind(to: notificationTableView.rx.items(cellIdentifier: "NotificationCell", cellType:NotificatioTableViewCell.self)){(row,item,cell) in
    //
    //        }.disposed(by: disposeBag)
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.notificationArray[indexPath.row]
        if(item.type == 10){
            let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: "PayAndConfirmCell", for:indexPath) as! PayAndConfirmTableViewCell
            cell.messageLabel.text = item.body
            cell.profileButton.tag = indexPath.row
            
            cell.dateLabel.text = Utility.UTCToLocal(date: (item.initialSession?.session ?? ""), fromFormat: YYYY_MM_DDHHMMSS, toFormat: MMM_DD_YYYY)
            cell.timeLabel.text = Utility.UTCToLocal(date: (item.initialSession?.session ?? ""), fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            cell.audioVideoButton.isHidden = true
            cell.priceLabel.text = "\(item.initialSession?.consultationPrice ?? "0") KD"
            if(item.initialSession?.services == "2"){
                cell.audioVideoButton.setImage(UIImage(named: "call_pink.png"), for: .normal)
                cell.audioVideoButton.isHidden = false
            }else if(item.initialSession?.services == "3"){
                cell.audioVideoButton.setImage(#imageLiteral(resourceName: "video_icon_session_screen"), for: .normal)
                cell.audioVideoButton.isHidden = false
            }
            cell.onPayAndConfirm = {
               let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
                let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "AppointmentSessionScreen") as! AppointmentSessionScreen
                confirmAlertController.notificationModel = item
                confirmAlertController.isFromPayAndConfirm = true
                self.navigationController?.pushViewController(confirmAlertController, animated: true)
            }
            cell.profileButton.addTarget(self,action:#selector(onProfilePayAndConfirm(sender:)), for: .touchUpInside)
            return cell
        }else{
            let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for:indexPath) as! NotificatioTableViewCell
            cell.messageLabel.text = item.body
            Utility.setImage(item.image, imageView: cell.profileIcon)
            cell.timeIcon.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDAMPM)
            cell.onProfiileButton.tag = indexPath.row
            cell.onProfiileButton.addTarget(self,action:#selector(onProfile(sender:)), for: .touchUpInside)
            return cell
            
        }
    }
    @objc func onProfilePayAndConfirm(sender:UIButton) {
        
        let buttonRow = sender.tag
        let item = self.notificationArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.initialSession?.profile ?? ""
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    @objc func onProfile(sender:UIButton) {
        
        let buttonRow = sender.tag
        let item = self.notificationArray[buttonRow]
        let storyboard = UIStoryboard(name: "Blog", bundle: nil)
        let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl = item.image ?? ""
        confirmAlertController.modalPresentationStyle = .overFullScreen
        self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    @objc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.notificationArray[indexPath.row]
        if(model.type == 7){
            let storyBoard = UIStoryboard(name: "Blog", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "BlogDetailScreen") as! BlogDetailScreen
            control.blogId = model.id!
            self.navigationController?.pushViewController(control, animated: true)
        }else if(model.type == 1 || model.type == 2 || model.type == 4 || model.type == 3 || model.type == 5){
            let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
            controller.sessionId = model.id!
            controller.isFromUpcomingOrPast = 1
            self.navigationController?.pushViewController(controller, animated: true)
        }else if(model.type == 6){
            let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "ChatListScreen") as! ChatListScreen
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(notificationArray.count - 1 == indexPath.row){
            if(self.metaData.has_more_pages != nil){
                if(self.metaData.has_more_pages!){
                    self.getNotification()
                }
            }
        }
    }
        
    func getNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = self.loadMoreUrl()
            NotificationServices.shared.getNotifications(parameters: [:],url: url, success: { (statusCode, notificationModel) in
                Utility.hideIndicator()
                if(self.metaData == nil){
                    self.notificationArray = []
                    self.notificationArray = notificationModel.data!
                }else{
                    self.notificationArray.append(contentsOf: notificationModel.data!)
                }
                self.metaData = notificationModel.meta
                self.notificationTableView.reloadData()
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
