//
//  ChatScreen.swift
//  socketIOChatDemo
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator
import IQKeyboardManagerSwift
import KMPlaceholderTextView
import RxAlamofire
import Alamofire
import SDWebImage
import MobileCoreServices
import PDFKit
import Foundation
import CryptoSwift

class ChatScreen: UIViewController, UIScrollViewDelegate,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource {
    
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activateDeactivateChatButton: UISwitch!
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    

    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var statusView: dateSportView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var deActivateChatView: UIView!
    @IBOutlet weak var bacckButton: UIButton!
    
    var appointmentDeatilModel :AppointmentDataModel?
    var chatListArray = [ChatModel]()
    let disposeBag = DisposeBag()
    var userId = Int()
    var metaData:MetaDataModel!
    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfCustomData>?
    var receiverID = Int()
    var isFromChatScreen: Bool = false
    var chatListModel : ChatListModel!
    var filterDictionary = [String:[ChatModel]]()
    var imageData: Data? = nil
    var scrollTop = false
    var typeIsPdf : Bool = false
    var isFromPushNotification : Bool = false
    var userDataDictionary = NSDictionary()
    var finalDictionary = [SectionOfCustomData]()
    var oldOffSet = 0.0
    var requestModel:RequestModel?
    var isFromRequest:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        deActivateChatView.isHidden = true
        
        initializedDetails()
       // self.dismissKey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            bacckButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
            messageTextView.textAlignment = .right
        }else{
            bacckButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
            messageTextView.textAlignment = .left
        }
      let notificationCenter = NotificationCenter.default

           notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        

       }
   
    @objc func appBecomeActive() {
//        print("App become active")
        let parameter = ["senderId": userId,
                                                "receiverId":receiverID] as [String:Any]
        SocketHelper.shared.socket.off( "newMessage")
        SocketHelper.shared.socket.off( "userAdded")
        SocketHelper.shared.socket.off("newMessage")
        SocketHelper.shared.socket.off( "DisplayTyping")
        SocketHelper.shared.socket.off("statusOnline")
        SocketHelper.shared.socket.off("chatDeactivated")
         SocketHelper.Events.addUser.emit(params: parameter)
        socketListenMethods(parameter: parameter)
    }
    
    func initializedDetails(){
        
        self.messageTextView.delegate = self
        var parameter = [String: Any]()
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    userId = loginDetails.data?.id as! Int
                    if(isFromChatScreen){
                        parameter = ["senderId": loginDetails.data?.id ?? 0,
                                     "receiverId":chatListModel.userId ?? 0] as [String:Any]
                        Utility.setImage(chatListModel.profile, imageView:profileImageView)
                        userNameLabel.text = "\( chatListModel.username ?? "")"
                        receiverID = chatListModel.userId ?? 0
                    }else  if(isFromRequest){
                        parameter = ["senderId": loginDetails.data?.id ?? 0,
                                     "receiverId":requestModel?.userId ?? 0] as [String:Any]
                        Utility.setImage(requestModel!.profile ?? "", imageView:profileImageView)
                        userNameLabel.text = "\( requestModel?.username ?? "")"
                        receiverID = requestModel?.userId ?? 0
                    }
                    
                    else if(isFromPushNotification){
                        parameter = ["senderId": loginDetails.data?.id ?? 0,
                                     "receiverId": (Int(userDataDictionary.object(forKey: "senderId") as! String))!] as [String:Any]
                                            Utility.setImage(userDataDictionary.object(forKey: "profile") as? String ?? "", imageView:profileImageView)
                                            userNameLabel.text = "\( userDataDictionary.object(forKey: "username") as? String ?? "")"
                        receiverID = (Int(userDataDictionary.object(forKey: "senderId") as! String)!)
                    }else{
                        if(loginDetails.data?.role == 1){
                            parameter = ["senderId": loginDetails.data?.id ?? 0,
                                         "receiverId":appointmentDeatilModel?.psychologistId ?? 0] as [String:Any]
                            Utility.setImage(appointmentDeatilModel?.profile, imageView:profileImageView)
                            userNameLabel.text = "\( appointmentDeatilModel?.firstname ?? "") \( appointmentDeatilModel?.lastname ?? "")"
                            receiverID = appointmentDeatilModel?.psychologistId ?? 0
                        }else{
                            parameter = ["senderId": loginDetails.data?.id ?? 0,
                                         "receiverId":appointmentDeatilModel?.userId ?? 0] as [String:Any]
                            Utility.setImage(appointmentDeatilModel?.profile, imageView:profileImageView)
                            userNameLabel.text = "\(appointmentDeatilModel?.username ?? "") "
                            receiverID = appointmentDeatilModel?.userId ?? 0
                        }
                    }
                    SocketHelper.Events.addUser.emit(params: parameter)
                }
            }catch{}
        }
        self.socketListenMethods(parameter: parameter)
        self.setupTextView(parameter: parameter)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        chatListTableView.register(UINib(nibName: "EncryptionTableViewCell", bundle: nil), forCellReuseIdentifier: "EncryptCell")
        chatListTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        chatListTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        chatListTableView.register(UINib(nibName: "SenderImageCell", bundle: nil), forCellReuseIdentifier: "sImageCell")
        chatListTableView.register(UINib(nibName: "ReceiverImageCell", bundle: nil), forCellReuseIdentifier: "rImageCell")
        chatListTableView.register(UINib(nibName: "PdfTableViewCell", bundle: nil), forCellReuseIdentifier: "PdfSenderCell")
        chatListTableView.register(UINib(nibName: "PdfReciverTableViewCell", bundle: nil), forCellReuseIdentifier: "PdfReciverCell")
        
//        chatListTableView.rx
//            .willDisplayCell
//            .subscribe(onNext: { cell, indexPath in
//                let lastRowIndex = self.chatListTableView.numberOfRows(inSection: 0)
//                if indexPath.row == lastRowIndex - 1 {
//                    //self.chatListTableView.scrollToBottom(animated: true)
//                }
//            })
//            .disposed(by: disposeBag)
        
        sendButton.setImage(UIImage(named: "gallery"), for: .normal)
        sendButton.setImage(UIImage(named: "send_message"), for: .selected)
        
        activateDeactivateChatButton
                  .rx
                  .controlEvent(.valueChanged)
                  .withLatestFrom(activateDeactivateChatButton.rx.value)
                  .subscribe(onNext : { bool in
                      if(bool){
                        self.onDeactivateChat()
                      }else{
                        self.onDeactivateChat()
                      }
                  })
                  .disposed(by: disposeBag)
     
        if messageTextView.text == "" {
            sendButton.isSelected = false
        }
        uesrRole = (UserDefaults.standard.object(forKey: "UserType") as? Int)!
        if(uesrRole != 1){
            activateDeactivateChatButton.isHidden = false
        }else{
            activateDeactivateChatButton.isHidden = true
        }
      
        self.getChat()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            messageViewBottomConstraint.constant = keyboardHeight
            //reloadData()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
          messageViewBottomConstraint.constant = 0
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == chatListTableView {
//            if chatListTableView.contentOffset.y < 50 {
//                print("scrolling")
//                if(metaData != nil){
//                    if(self.metaData.has_more_pages! && !scrollTop){
//                        scrollTop = true
//                        print("getChatCall")
//                        self.getChat()
////                        let oldContentSizeHeight = chatListTableView.contentSize.height
////
////                        chatListTableView.reloadNewData { [self] in
////                            let newContentSizeHeight = self.chatListTableView.contentSize.height
////                            self.chatListTableView.contentOffset = CGPoint(x:chatListTableView.contentOffset.x,y:newContentSizeHeight - oldContentSizeHeight)
////                        }
//
//                    }
//                }
//            }
//        }
//    }
    //MARK:Scrollview delegate method
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if scrollView == self.chatListTableView && !decelerate {
                self.scrollingFinished()
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            self.scrollingFinished()
        }
        
        func scrollingFinished(){
            var visibleRect = CGRect()
            visibleRect.origin = self.chatListTableView.contentOffset
            visibleRect.size = self.chatListTableView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = self.chatListTableView.indexPathForRow(at: visiblePoint) else { return }
            if chatListTableView.contentOffset.y < 50 {
                if(self.metaData.has_more_pages!){
                getChat()
                }
            }
        }
    
    func onDeactivateChat(){
        if(metaData.isChatDeactivated == 0 ){
            let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "DEACTIVATE"), message: Utility.getLocalizdString(value: "CHAT_DEACTIVATED"), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "YES"), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                let parameter = ["senderId": self.userId,
                                 "receiverId":self.receiverID,"isDeactivate":1] as [String:Any]
                SocketHelper.Events.DeactiveChat.emit(params:parameter)
                self.metaData.isChatDeactivated = 1
                self.deActivateChatView.isHidden = false
                self.messageTextView.resignFirstResponder()
                     
            }))
            
            refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }else{
            let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "ACTIVATE"), message: Utility.getLocalizdString(value: "CHAT_ACTIVATE_MSG"), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "YES"), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                let parameter = ["senderId": self.userId,
                                 "receiverId":self.receiverID,"isDeactivate":0] as [String:Any]
                SocketHelper.Events.DeactiveChat.emit(params:parameter)
                self.deActivateChatView.isHidden = true
                self.messageTextView.resignFirstResponder()
                self.metaData.isChatDeactivated = 0
            }))
            
            refreshAlert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func setupTextView(parameter:[String:Any]){
        Observable.zip(messageTextView.rx.text,
                       messageTextView.rx.text.skip(1))
            .throttle(0.5, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (old, new) in
                if(new != ""){
                    self.sendButton.isSelected = true
                }else{
                    self.sendButton.isSelected = false
                   
                }
                NSObject.cancelPreviousPerformRequests(
                    withTarget: self,
                    selector: #selector(self.getHintsFromTextField),
                    object: self.messageTextView)
                self.perform(
                    #selector(self.getHintsFromTextField),
                    with: self.messageTextView,
                    afterDelay: 0.5)
                self.perform(
                #selector(self.updateTypingStatus),
                with: self.messageTextView,
                afterDelay: 1.0)
//                let parameter = [
//                    "receiverId":self.receiverID] as [String:Any]
                let parameter = ["senderId": self.userId,
                             "receiverId":self.receiverID] as [String:Any]
                SocketHelper.Events.typing.emit(params:parameter)
            }).disposed(by: disposeBag)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    
    func socketListenMethods(parameter: [String:Any])
    {
        SocketHelper.Events.userAdded.listen { [weak self] (result) in
            //            print(result)
            SocketHelper.Events.getOnlineStatus.emit(params: parameter)
            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
           
        }
        
        SocketHelper.Events.DisplayTyping.listen { [weak self] (result) in
            do{
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String:Any] {
                if(((dictFromJSON["senderId"] as! NSNumber).intValue) == self?.receiverID){
                    self!.statusLabel.text = Utility.getLocalizdString(value: "TYPING")
                }
                
            }
            }catch{}
        }
       
        
        SocketHelper.Events.chatDeactivated.listen { [weak self] (result) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    if(((dictFromJSON["senderId"] as! NSNumber).intValue) == self?.receiverID){
                        if((dictFromJSON["isDeactivate"] as! Int) == 0){
                            self!.activateDeactivateChatButton.setOn(true, animated: true)
                            self!.deActivateChatView.isHidden = true
                            self!.messageTextView.resignFirstResponder()
                        }else{
                            self!.activateDeactivateChatButton.setOn(false, animated: true)
                            self!.deActivateChatView.isHidden = false
                            self!.messageTextView.resignFirstResponder()
                        }
                    }
                }
            }catch{}
        }
        
        SocketHelper.Events.removeTypingMessage.listen { [weak self] (result) in
            self!.statusLabel.text = Utility.getLocalizdString(value: "ONLINE")
        }
        
        SocketHelper.Events.statusOnline.listen { [weak self] (result) in
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    if(((dictFromJSON["senderId"] as! NSNumber).intValue) == self?.receiverID){
                        if(((dictFromJSON["isOnline"] as! NSNumber).intValue) == 1){
                            self?.statusLabel.text =  Utility.getLocalizdString(value: "ONLINE")
                            self?.statusView.backgroundColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.537254902, alpha: 1)
                        }else{
                            self?.statusLabel.text = Utility.getLocalizdString(value: "OFFLINE")
                            self?.statusView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
        SocketHelper.Events.newMessage.listen { [weak self] (result) in
            print(result)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    let model = Mapper<ChatModel>().map(JSON: dictFromJSON)
//                    model?.createdAt = Utility.UTCToLocal(date: (model?.createdAt)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                    self!.addNewElementIntoDictionary(model: model!,currentKey: Utility.UTCToLocal(date: (model?.createdAt)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD))
//                    self!.reloadData()
//                    self!.loadTable()
                    self!.chatListTableView.reloadData()
                    self!.chatListTableView.scrollToBottom()
                    let  parameter = ["senderId":model?.senderId ?? 0,
                                      "receiverId":model?.receiverId ?? 0,"messageId":model?.messageId ?? 0] as [String:Any]
                    SocketHelper.Events.ReadMessage.emit(params: parameter)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reloadData(){
        self.chatListTableView.reloadData()
//        self.loadTable()
        DispatchQueue.main.async {
            let scrollPoint = CGPoint(x: 0, y: self.chatListTableView.contentSize.height  - self.chatListTableView.frame.size.height)
            self.chatListTableView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let scrollPoint = CGPoint(x: 0, y: self.chatListTableView.contentSize.height - self.chatListTableView.frame.size.height)
        self.chatListTableView.setContentOffset(scrollPoint, animated: false)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    
    @objc func getHintsFromTextField(textField: UITextView) {
        print("Hints for textField: \(textField)")
        if(textField.text != ""){
            self.sendButton.isSelected = true
        } else{
            self.sendButton.isSelected = false
        }
        let parameter = ["senderId": self.userId,
        "receiverId":self.receiverID] as [String:Any]
        SocketHelper.Events.removeTyping.emit(params: parameter)
    }
    
    @objc func updateTypingStatus() {
        let parameter = ["senderId": self.userId,
                         "receiverId":self.receiverID] as [String:Any]
        SocketHelper.Events.removeTyping.emit(params: parameter)
    }
    
    
    func loadMoreUrl() -> String{
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        var oppenentId = Int()
        if(isFromChatScreen){
            oppenentId =  chatListModel.userId ?? 0
        }else if(isFromPushNotification){
            let number:Int = Int(userDataDictionary.object(forKey: "senderId") as! String)!
            oppenentId = (number)
            
        }else if(isFromRequest){
            
            oppenentId = requestModel?.userId ?? 0
            
        }
        else {
            if(uesrRole == 1){
                oppenentId =  appointmentDeatilModel?.psychologistId ?? 0
            }else{
                oppenentId = appointmentDeatilModel?.userId ?? 0
            }
        }
        var url = String()
        if(self.metaData == nil){
            url = "\(MESSAGE_API)/\(oppenentId)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "?")
            
            url = "\(MESSAGE_API)/\(oppenentId)?\(urlArray?.last  ?? "")"
        }
        return url
    }
    
    func getChat(){
        if Utility.isInternetAvailable(){
            DispatchQueue.main.async {
                Utility.showIndicator()
            }
           
            let url = self.loadMoreUrl()
            ChatServices.shared.getChat(url: url, success: { [self] (statusCode, chatModel) in
                
                if(self.metaData == nil){
                    Utility.hideIndicator()
                    self.chatListArray = []
                    self.chatListArray = chatModel.data ?? []
                    self.chatListArray.append(ChatModel(message: "", type: 99, senderId: 0, receiverId: 0, createdAt: ""))
                    self.metaData = chatModel.meta
                    self.formatttedArray()
                    self.chatListTableView.reloadData()
                    self.chatListTableView.scrollToBottom()
                }else{
                    //self.chatListArray.append(contentsOf: chatModel.data ?? [])
//                    self.formatttedArray()
                    let datesArray = (chatModel.data ?? []).compactMap { $0.createdAt } // return array of date
                    var dic = [String:[ChatModel]]() // Your required result
                    datesArray.forEach {
                        let dateKey = Utility.UTCToLocal(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)
                        let filterArray = (chatModel.data ?? []).filter { Utility.UTCToLocal(date: $0.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)  == dateKey }
                        dic[Utility.UTCToLocal(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)] = filterArray
                    }
                    print(dic)
                    let componentArray = Array(dic.keys)
                    for key in componentArray{
                        if self.filterDictionary.index(forKey: key) != nil {
                            var lastDateDictionaryArray = dic[key]!
                            lastDateDictionaryArray.append(contentsOf: self.filterDictionary[key]!)
                            self.filterDictionary[key] = lastDateDictionaryArray
                        }else{
                            var newArray = [ChatModel]()
                            newArray.append(contentsOf: dic[key]!)
                            self.filterDictionary[key] = newArray
                        }
                    }
                    self.finalDictionary = []
                    let fruitsTupleArray = self.filterDictionary.sorted { $0.key.localizedCompare($1.key) == .orderedAscending  }
                    for (key, value) in fruitsTupleArray {
                        self.finalDictionary.append( SectionOfCustomData(header: key, items: value))
                    }
                    print(self.filterDictionary)
                    self.metaData = chatModel.meta
                    self.scrollTop = false
                    Utility.hideIndicator()
//                    self.chatListTableView.reloadData()
                    let oldContentSizeHeight = self.chatListTableView.contentSize.height
                    self.chatListTableView.reloadData()
                    let newContentSizeHeight = self.chatListTableView.contentSize.height
                    self.chatListTableView.contentOffset = CGPoint(x:self.chatListTableView.contentOffset.x,y:newContentSizeHeight - (oldContentSizeHeight-self.chatListTableView.layer.frame.height))
                }
                if(self.metaData.isChatDeactivated == 1){
                    self.activateDeactivateChatButton.setOn(false, animated: true)
                          self.deActivateChatView.isHidden = false
                }else{
                    self.activateDeactivateChatButton.setOn(true, animated: true)
                    self.deActivateChatView.isHidden = true
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
    
    
    
    @objc func keyboardChangedFrame(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        messageViewBottomConstraint.constant -= keyboardHeight
        DispatchQueue.main.async {
            let scrollPoint = CGPoint(x: 0, y: self.chatListTableView.contentSize.height - self.chatListTableView.frame.size.height)
            self.chatListTableView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
//    func didSelect(){
//        Observable
//            .zip(chatListTableView.rx.itemSelected, chatListTableView.rx.modelSelected(ChatModel.self))
//            .bind { [unowned self] indexPath, model in
//
//                print("click")
//
//        }.disposed(by: disposeBag)
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return finalDictionary.count
    }
//
     func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        let dateString = finalDictionary[section]
        return (dateString.header)
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let messagesArray = finalArray.object(at: section)
//
//        return (messagesArray).count
        let dateString = finalDictionary[section]
//        let messagesArray = chatMessageDictionary.object(forKey: dateString) as! NSMutableArray
        return dateString.items.count
    }
//
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        //        let heightLabel = heightForView(text: self.tableView(tableView, titleForHeaderInSection: section)!, font: UIFont(name: "Segoe UI", size: 18)!, width:chatMessageTableView.bounds.size.width-40)

        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:tableView.bounds.size.width-40, height: 30))
        headerLabel.font = UIFont(name: "ArialRoundedMTBold", size: 10)
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.black
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.addSubview(headerLabel)

        return headerView
    }
//
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainArray = finalDictionary[indexPath.section]
//        if(mainArray.items.count > indexPath.row){
        let item = mainArray.items[indexPath.row]
    if(item.type == 1){
        var decryptedMessage = String()

        decryptedMessage = (item.message ?? "").aesDecrypt() ?? ""

        if((item.senderId ?? 0) == self.userId){
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderTableViewCell
            cell.messageLabel.text = decryptedMessage
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            return cell
        }
        else {
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverTableViewCell

            cell.messageLabel.text = decryptedMessage
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            return cell
        }
    }else if(item.type == 99){
         let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "EncryptCell", for: indexPath) as! EncryptionTableViewCell
        return cell
    }else if(item.type == 3){
        if((item.senderId ?? 0) == self.userId){
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "PdfSenderCell", for: indexPath) as! PdfTableViewCell
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            return cell
        }
        else {
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "PdfReciverCell", for: indexPath) as! PdfReciverTableViewCell
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            return cell
        }
    }else{
        if((item.senderId ?? 0) == self.userId){
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "sImageCell", for: indexPath) as! SenderImageCell
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            var decryptedMessage = String()
            cell.senderImageView.image = nil
            decryptedMessage = (item.message ?? "").aesDecrypt() ?? ""
            let imageName = self.returnImageName(imageUrl: decryptedMessage)
            let localImage = self.readImageFromDocs(fileName: imageName)

            if(localImage == nil){
                cell.senderImageView.image = nil
                cell.senderImageView.alpha = 0.05
                cell.downloadImageButton.isHidden = false
                Utility.setImage(decryptedMessage, imageView: cell.senderImageView)

            }else{
                cell.senderImageView.alpha = 1.0
                cell.downloadImageButton.isHidden = true

                DispatchQueue.main.async {

                    let path = "file://\(localImage ?? "")"
                    SDWebImageManager.shared.loadImage(with: NSURL.init(string: path ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                        print(recieved,expected)
                    }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
                        DispatchQueue.main.async {
                            if downloadedImage != nil{
                                cell.senderImageView.image = nil
                                cell.senderImageView.image = downloadedImage
                            }
                        }
                    })
                }
            }

            cell.downloadImageButton.rx.tap.first()
                .subscribe({ _ in
                    SDWebImageManager.shared.loadImage(with: NSURL.init(string: decryptedMessage ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                        print(recieved,expected)
                    }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
                        DispatchQueue.main.async {
                            if downloadedImage != nil{
                                cell.senderImageView.image = nil
                                cell.senderImageView.image = downloadedImage
                                cell.senderImageView.alpha = 1.0
                                cell.downloadImageButton.isHidden = true
                                self.writeImageToDocs(image: downloadedImage!, imageName: imageName)
                            }
                        }
                    })

                })
                .disposed(by: self.disposeBag)
            return cell
        }else {
            let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "rImageCell", for: indexPath) as! ReceiverImageCell
//                        Utility.setImage(item.message, imageView: cell.receiverImageCell)
            cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            var decryptedMessage = String()

            decryptedMessage = (item.message ?? "").aesDecrypt() ?? ""
            let imageName = self.returnImageName(imageUrl: decryptedMessage)
            let localImage = self.readImageFromDocs(fileName: imageName)
            cell.receiverImageCell.image = nil
            if(localImage == nil){
                cell.receiverImageCell.image = nil
                cell.receiverImageCell.alpha = 0.05
                cell.downloadButton.isHidden = false
                Utility.setImage(decryptedMessage, imageView: cell.receiverImageCell)

            }else{
                cell.receiverImageCell.image = nil
                cell.receiverImageCell.alpha = 1.0
                cell.downloadButton.isHidden = true
                DispatchQueue.main.async {

                    let path = "file://\(localImage ?? "")"
                    SDWebImageManager.shared.loadImage(with: NSURL.init(string: path ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                        print(recieved,expected)
                    }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
                        DispatchQueue.main.async {
                            if downloadedImage != nil{
                                cell.receiverImageCell.image = nil
                                cell.receiverImageCell.image = downloadedImage
                            }
                        }
                    })
                }
            }

            cell.downloadButton.rx.tap.first()
                .subscribe({ _ in
                    SDWebImageManager.shared.loadImage(with: NSURL.init(string: decryptedMessage ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                        print(recieved,expected)
                    }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
                        DispatchQueue.main.async {
                            if downloadedImage != nil{
                                cell.receiverImageCell.image = nil
                                cell.receiverImageCell.image = downloadedImage
                                cell.receiverImageCell.alpha = 1.0
                                cell.downloadButton.isHidden = true
                                self.writeImageToDocs(image: downloadedImage!, imageName: imageName)
                            }
                        }
                    })

                })
                .disposed(by: self.disposeBag)
            return cell
        }
    }
//    }
//        return UITableViewCell()
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainArray = finalDictionary[indexPath.section]
        let model = mainArray.items[indexPath.row]
        var decryptedMessage = String()

        decryptedMessage = (model.message)?.aesDecrypt() ?? ""
        if(self.returnImageOrNot(url: decryptedMessage)){
     
            let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
            control.titleType = "Pdf"
            control.url =  decryptedMessage
            self.navigationController?.pushViewController(control, animated: true)
        }
        else if(model.type == 2){
            var decryptedMessage = String()

            decryptedMessage = (model.message ?? "").aesDecrypt() ?? ""
            let storyboard = UIStoryboard(name: "Blog", bundle: nil)
            let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
            confirmAlertController.imageUrl =  decryptedMessage
            confirmAlertController.modalPresentationStyle = .overFullScreen
            self.present(confirmAlertController, animated: true, completion: nil)
        }
    }
    
   
    
//    func loadTable(){
//        chatListTableView.dataSource = nil
//        chatListTableView.delegate = nil
//
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
//            configureCell: { ds, tv, indexPath, item in
//                if(item.type == 1){
//                    var decryptedMessage = String()
//
//                    decryptedMessage = (item.message ?? "").aesDecrypt() ?? ""
//
//                    if((item.senderId ?? 0) == self.userId){
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderTableViewCell
//                        cell.messageLabel.text = decryptedMessage
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        return cell
//                    }
//                    else {
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverTableViewCell
//
//                        cell.messageLabel.text = decryptedMessage
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        return cell
//                    }
//                }else if(item.type == 99){
//                    let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "EncryptCell", for: indexPath) as! EncryptionTableViewCell
//                    return cell
//                }else if(item.type == 3){
//                    if((item.senderId ?? 0) == self.userId){
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "PdfSenderCell", for: indexPath) as! PdfTableViewCell
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        return cell
//                    }
//                    else {
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "PdfReciverCell", for: indexPath) as! PdfReciverTableViewCell
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        return cell
//                    }
//                }else{
//                    if((item.senderId ?? 0) == self.userId){
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "sImageCell", for: indexPath) as! SenderImageCell
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        let imageName = self.returnImageName(imageUrl: item.message!)
//                        let localImage = self.readImageFromDocs(fileName: imageName)
//
//                        if(localImage == nil){
//                            cell.senderImageView.alpha = 0.05
//                            cell.downloadImageButton.isHidden = false
//                            Utility.setImage(item.message, imageView: cell.senderImageView)
//
//                        }else{
//                            cell.senderImageView.alpha = 1.0
//                            cell.downloadImageButton.isHidden = true
//
//                            DispatchQueue.main.async {
//
//                                let path = "file://\(localImage ?? "")"
//                                SDWebImageManager.shared.loadImage(with: NSURL.init(string: path ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
//                                    print(recieved,expected)
//                                }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
//                                    DispatchQueue.main.async {
//                                        if downloadedImage != nil{
//                                            cell.senderImageView.image = downloadedImage
//                                        }
//                                    }
//                                })
//                            }
//                        }
//
//                        cell.downloadImageButton.rx.tap.first()
//                            .subscribe({ _ in
//                                SDWebImageManager.shared.loadImage(with: NSURL.init(string: item.message! ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
//                                    print(recieved,expected)
//                                }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
//                                    DispatchQueue.main.async {
//                                        if downloadedImage != nil{
//                                            cell.senderImageView.image = downloadedImage
//                                            cell.senderImageView.alpha = 1.0
//                                            cell.downloadImageButton.isHidden = true
//                                            self.writeImageToDocs(image: downloadedImage!, imageName: imageName)
//                                        }
//                                    }
//                                })
//
//                            })
//                            .disposed(by: self.disposeBag)
//                        return cell
//                    }else {
//                        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "rImageCell", for: indexPath) as! ReceiverImageCell
//                        //                        Utility.setImage(item.message, imageView: cell.receiverImageCell)
//                        cell.timeLabel.text = Utility.UTCToLocal(date: item.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
//                        let imageName = self.returnImageName(imageUrl: item.message!)
//                        let localImage = self.readImageFromDocs(fileName: imageName)
//
//                        if(localImage == nil){
//                            cell.receiverImageCell.alpha = 0.05
//                            cell.downloadButton.isHidden = false
//                            Utility.setImage(item.message, imageView: cell.receiverImageCell)
//
//                        }else{
//                            cell.receiverImageCell.alpha = 1.0
//                            cell.downloadButton.isHidden = true
//                            DispatchQueue.main.async {
//
//                                let path = "file://\(localImage ?? "")"
//                                SDWebImageManager.shared.loadImage(with: NSURL.init(string: path ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
//                                    print(recieved,expected)
//                                }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
//                                    DispatchQueue.main.async {
//                                        if downloadedImage != nil{
//                                            cell.receiverImageCell.image = downloadedImage
//                                        }
//                                    }
//                                })
//                            }
//                        }
//
//                        cell.downloadButton.rx.tap.first()
//                            .subscribe({ _ in
//                                SDWebImageManager.shared.loadImage(with: NSURL.init(string: item.message! ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
//                                    print(recieved,expected)
//                                }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
//                                    DispatchQueue.main.async {
//                                        if downloadedImage != nil{
//                                            cell.receiverImageCell.image = downloadedImage
//                                            cell.receiverImageCell.alpha = 1.0
//                                            cell.downloadButton.isHidden = true
//                                            self.writeImageToDocs(image: downloadedImage!, imageName: imageName)
//                                        }
//                                    }
//                                })
//
//                            })
//                            .disposed(by: self.disposeBag)
//                        return cell
//                    }
//                }
//            },
//            titleForHeaderInSection: { ds, index in
//                return ds.sectionModels[index].header
//            }
//        )
//    }
    
    func formatttedArray(){
        let datesArray = chatListArray.compactMap { $0.createdAt }
        if(filterDictionary.count == 0){
            datesArray.forEach {
                let dateKey = Utility.UTCToLocal(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)
                let filterArray = chatListArray.filter { Utility.UTCToLocal(date: $0.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)  == dateKey }
                filterDictionary[Utility.UTCToLocal(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)] = filterArray
            }
            print(filterDictionary)
        }
        let fruitsTupleArray = filterDictionary.sorted { $0.key.localizedCompare($1.key) == .orderedAscending  }
        for (key, value) in fruitsTupleArray {
            finalDictionary.append( SectionOfCustomData(header: key, items: value))
        }
    }
    
    func returnImageName(imageUrl: String)->String{
        let urlArray = imageUrl.split(separator: "/")
        return "\(urlArray.last ?? "")"
    }
    
    func writeImageToDocs(image:UIImage,imageName:String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(imageName)
        
        debugPrint("destination path is",destinationPath)
        
        do {
            try image.pngData()?.write(to: destinationPath)
        } catch {
            debugPrint("writing file error", error)
        }
    }
    
    func readImageFromDocs(fileName:String)->String?{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return  filePath
        } else {
            return nil
        }
    }
    
    func returnImageOrNot(url: String) -> Bool{
        if(url == nil || url == ""){
            return false
        }
        let url: URL? = NSURL(fileURLWithPath: url) as URL
        let pathExtention = url?.pathExtension
            if ["pdf"].contains(pathExtention!)
            {
                print("Image URL: \(String(describing: url))")
                return true
                // Do something with it
            }else
            {
               print("pdf URL: \(String(describing: url))")
                return false
            }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor.clear
//        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        let backGroundBlueView = UIView()
//        backGroundBlueView.frame = CGRect(x: (header.layer.frame.width/2)-((header.textLabel?.intrinsicContentSize.width)!/2), y: 0, width: 100, height: header.layer.frame.height)
//        backGroundBlueView.layer.cornerRadius = header.layer.frame.height/2
//        //        backGroundBlueView.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8156862745, alpha: 1)
//
//        //        header.addSubview(backGroundBlueView)
//        header.textLabel?.textColor = #colorLiteral(red: 0.4352941176, green: 0.4901960784, blue: 0.5019607843, alpha: 1)
//        header.textLabel?.textAlignment = .center
//        header.textLabel?.font = UIFont(name: "Quicksand-SemiBold", size: 12.0)
        //        backGroundBlueView.bringSubviewToFront(header)
        
    }
    
//    func addNewElementIntoDictionary(model:ChatModel,currentKey: String){
//        if filterDictionary.index(forKey: currentKey) != nil {
//            var lastDateDictionaryArray = filterDictionary[currentKey]
//            lastDateDictionaryArray?.append(model)
//            filterDictionary[currentKey] = lastDateDictionaryArray
//        }else{
//            var newArray = [ChatModel]()
//            newArray.append(model)
//            filterDictionary[currentKey] = newArray
//        }
//    }
    func addNewElementIntoDictionary(model:ChatModel,currentKey: String){
        var index = finalDictionary.count
        if(index == 0){
            index = 0
        }else{
            index = index - 1
        }
        if(finalDictionary.count == 0){
            var newArray = [ChatModel]()
            newArray.append(model)
            finalDictionary.append(SectionOfCustomData(header: currentKey, items: newArray))
        }else{
            var object = finalDictionary[index]
        if (object.header == currentKey){
            object.items.append(model)
            finalDictionary[index] = object
        }else{
            var newArray = [ChatModel]()
            newArray.append(model)
            finalDictionary.append(SectionOfCustomData(header: currentKey, items: newArray))
        }
        }
    }
    
    func uploadPhoto(_ url: String, image: Data, params: [String : Any], header: [String:String],mimeType: String) {
        let httpHeaders = HTTPHeaders(header)
        AF.upload(multipartFormData: { multiPart in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            multiPart.append(image, withName: "attachment", fileName: "file.jpg", mimeType: mimeType)
        }, to: url, method: .post, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                print("upload success result: \(resut)")
                do{
                    let json = try JSONSerialization.jsonObject(with: resut!, options: []) as? [String : Any]
                    print(json!["data"] as! [String : Any])
                    let model = Mapper<ChatModel>().map(JSON: json!["data"] as! [String : Any])
                    let objectResponse = json!["data"] as! [String : Any]
                    let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en")

                    dateFormatter.dateFormat = YYYY_MM_DDHHMMSS
                    let dateInFormat = dateFormatter.string(from: NSDate() as Date)
                    model?.createdAt = Utility.localToUTC(date: dateInFormat, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                    model?.type = ((objectResponse["type"] as! NSString).integerValue)
                    var encryptedMessage = String()
                    encryptedMessage = model?.message?.aesEncrypt() ?? ""
                    let imageUrl = model?.message! ?? ""
                    model?.message = encryptedMessage
                    let currentKey = Utility.UTCToLocal(date: (model?.createdAt)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)
                    self.addNewElementIntoDictionary(model: model!,currentKey: currentKey)
                    
                    let imageName = self.returnImageName(imageUrl: imageUrl)
               
                    if(self.typeIsPdf){
                        let parameter = ["message":encryptedMessage,
                                         "senderId":self.userId ,
                                         "receiverId":model?.receiverId ?? 0,
                                         "type":3,
                                         "createdAt":model?.createdAt ?? "",
                                         "messageId":model?.messageId ?? 0
                        ] as [String:Any]
                        SocketHelper.Events.sendMessage.emit(params: parameter)
                    }else{
                        self.writeImageToDocs(image: UIImage(data: self.imageData!)!, imageName: imageName)
                        let parameter = ["message":encryptedMessage,
                                         "senderId":self.userId ,
                                         "receiverId":model?.receiverId ?? 0,
                                         "type":2,
                                         "createdAt":model?.createdAt ?? "",
                                         "messageId":model?.messageId ?? 0
                        ] as [String:Any]
                        SocketHelper.Events.sendMessage.emit(params: parameter)
                    }
                    
                    Utility.hideIndicator()
                    self.chatListTableView.reloadData()
                    self.chatListTableView.scrollToBottom()
                }catch{
                    Utility.hideIndicator()
                }
            case .failure(let err):
                Utility.hideIndicator()
                print("upload err: \(err)")
            }
        }
    }
    
    func pdfThumbnail(data: Data, width: CGFloat = 240) -> UIImage? {
     
        let page = PDFDocument(data: data)?.page(at: 0)

        let pageSize = page!.bounds(for: .mediaBox)
      let pdfScale = width / pageSize.width

      // Apply if you're displaying the thumbnail on screen
      let scale = UIScreen.main.scale * pdfScale
      let screenSize = CGSize(width: pageSize.width * scale,
                              height: pageSize.height * scale)

        return page!.thumbnail(of: screenSize, for: .mediaBox)
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
     return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
     
    
    
    @IBAction func onSendMessage(_ sender: Any) {
        if(sendButton.isSelected == true){
            if(messageTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                return
            }
            let chars = (messageTextView.text).components(separatedBy: " ")
            var valid:Bool = false
            for i in 0...chars.count-1{
                let string = chars[i] as String
                if(self.validate(YourEMailAddress: string)){
                    valid = true
                    break
                }
                if(string.isValidPhone()){
                    valid = true
                    break
                }
            }
            var encryptedMessage = String()
       
                encryptedMessage = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).aesEncrypt()!
          
            if(valid){
                let refreshAlert = UIAlertController(title: "Warning", message: "Any communication or arrangements outside of Juthoor is strictly prohibited and against our Terms of Service and may result in a ban to your account. If you are not sharing personal contact information outside of the scope of Juthoor, please ignore and press send", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction!) in
                
                    uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                                   var parameter = [String:Any]()
                                   if uesrRole == 1{
                                    parameter = ["message":encryptedMessage ,
                                                 "senderId":self.userId,
                                                 "receiverId":self.receiverID,
                                                    "type":1] as [String:Any]
                                   }else{
                                    parameter = ["message":encryptedMessage ,
                                                 "senderId":self.userId,
                                                 "receiverId":self.receiverID,
                                                    "type":1] as [String:Any]
                                   }
                                   let model = Mapper<ChatModel>().map(JSON: parameter)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = YYYY_MM_DDHHMMSS
                                        dateFormatter.locale = Locale(identifier: "en")
                                   let dateInFormat = dateFormatter.string(from: NSDate() as Date)
                                   model?.createdAt = Utility.localToUTC(date: dateInFormat, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                                   let currentKey = Utility.UTCToLocal(date: (model?.createdAt)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)
                                   self.addNewElementIntoDictionary(model: model!,currentKey: currentKey)
                    self.chatListTableView.reloadData()
                    self.chatListTableView.scrollToBottom()
                                   SocketHelper.Events.sendMessage.emit(params: parameter)
                    self.messageTextView.text = ""
                                   
                    
                  }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                  }))

                self.present(refreshAlert, animated: true, completion: nil)
            }else{
                uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
                var parameter = [String:Any]()
                if uesrRole == 1{
                    parameter = ["message":encryptedMessage ,
                                 "senderId":userId,
                                 "receiverId":receiverID,
                                 "type":1] as [String:Any]
                }else{
                    parameter = ["message":encryptedMessage,
                                 "senderId":userId,
                                 "receiverId":receiverID,
                                 "type":1] as [String:Any]
                }
                let model = Mapper<ChatModel>().map(JSON: parameter)
                let dateFormatter = DateFormatter()
                
                    dateFormatter.locale = Locale(identifier: "en")

                
                dateFormatter.dateFormat = YYYY_MM_DDHHMMSS
                let dateInFormat = dateFormatter.string(from: NSDate() as Date)
                model?.createdAt = Utility.localToUTC(date: dateInFormat, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
                let currentKey = Utility.UTCToLocal(date: (model?.createdAt)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DD)
                self.addNewElementIntoDictionary(model: model!,currentKey: currentKey)
//                self.loadTable()
                self.chatListTableView.reloadData()
                chatListTableView.scrollToBottom()
                //            self.reloadData()
                SocketHelper.Events.sendMessage.emit(params: parameter)
                messageTextView.text = ""
                
            }
        }else{
            view.endEditing(true)
            self.uploadDocumentOptionAlert(controller: self)
        }
    }
        
    @IBAction func onBack(_ sender: Any) {

            let parameter = ["senderId": self.userId,
                             "receiverId":self.receiverID] as [String:Any]
            self.navigationController?.popViewController(animated: true)

    }
    
    //Show alert to selected the media source type.
        func uploadDocumentOptionAlert(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "GALLERY"), style: .default, handler: { (_) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CAMERA"), style: .default, handler: { (_) in
            self.getImage(fromSourceType: .camera)
        }))
        
            alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "DOCUMENT"), style: .default, handler: { (_) in
            self.getDocument()
        }))
        
        alert.addAction(UIAlertAction(title: Utility.getLocalizdString(value: "CANCEL"), style: .destructive, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func getDocument(){
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = .fullScreen
        present(documentPickerController, animated: true, completion: nil)
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
             if(Utility.isInternetAvailable()){
            Utility.showIndicator()
            self!.typeIsPdf = false
            self!.imageData = image.jpegData(compressionQuality:0.2)!
            let parameter = ["receiverId":self!.receiverID,"type":"2"] as [String : Any]
            let headerDic = self!.getHeader()
            self!.uploadPhoto("\(BASE_URL)\(SEND_MESSAGE)", image: self!.imageData!, params: parameter, header: headerDic, mimeType: "image/jpg")
             }else{
                Utility.showNoInternetConnectionAlertDialog(vc: self!)
            }
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getHeader() -> [String:String] {
        var headerDic = [String:String]()
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

        if(UserDefaults.standard.object(forKey: USER_DETAILS) == nil)
        {
            headerDic = [
                ACCEPT:APLLICATION_JSON,
                 TIMEZONE:localTimeZoneIdentifier,
                "Content-Language":Utility.getCurrentLanguage()
            ]
        }
        else
        {
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginResponse = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        let accessToken = (loginResponse.data?.auth?.accessToken ?? "") as String
                        let authorization = "\(loginResponse.data?.auth?.tokenType! ?? "") \(accessToken)"
                        if (accessToken != "")
                        {
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                 TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }else{
                            headerDic = [
                                AUTHORIZATION:authorization,
                                ACCEPT:APLLICATION_JSON,
                                 TIMEZONE:localTimeZoneIdentifier,
                                "Content-Language":Utility.getCurrentLanguage()
                            ]
                        }
                    }
                }catch{}
            }
        }
        return headerDic
    }
    
}


struct SectionOfCustomData {
    var header: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = ChatModel
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
    
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}

extension UIViewController {
func dismissKey()
{
let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}
@objc func dismissKeyboard()
{
view.endEditing(true)
}
}
extension ChatScreen :UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        //Get document url
        if(Utility.isInternetAvailable()){
        Utility.showIndicator()
        typeIsPdf = true
        print(urls.first!.fileSize)
        if(((urls.first!.fileSize)/1000000) > 3){
            Utility.showAlert(vc: self, message: "file size should be less than or equal to 3mb")
            Utility.hideIndicator()
            return
        }
        do{
        imageData = try Data.init(contentsOf: urls.first!)
        }catch{}
        let parameter = ["receiverId":self.receiverID,"type":"3"] as [String : Any]
        let headerDic = self.getHeader()
        self.uploadPhoto("\(BASE_URL)\(SEND_MESSAGE)", image: self.imageData!, params: parameter, header: headerDic, mimeType: "application/pdf")
        }else{
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}

extension String {
    func isValidPhone() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
extension String {
//func aesEncrypt() throws -> String {
//    let encrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
//    return Data(encrypted).toHexString()
//}
//
//func aesDecrypt() throws -> String {
//    guard let data = Data(base64Encoded: self) else { return "" }
//    let decrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).decrypt([UInt8](data))
//    return String(bytes: decrypted, encoding: .utf8) ?? self
//}
    func aesEncrypt() -> String? {
//          let data = try! JSONEncoder().encode(self)
        let encrypted = try? AES(key: Array(KEY.data(using: .utf8)!), blockMode: CBC(iv: Array(IV.data(using: .utf8)!)), padding: .pkcs5).encrypt(Array(self.utf8))
        return encrypted?.toHexString()
    }
    
    /// AES Decryption Method using `CryptoSwift` dependency.
    func aesDecrypt() -> String? {
        guard let key = String(data: KEY.data(using: .utf8)!, encoding: .utf8), let iv = String(data: IV.data(using: .utf8)!, encoding: .utf8) else { return nil }
        let aes = try? AES(key: key, iv: iv)
        let byteArray = Array<UInt8>(hex: self)
        if let decrypted = try? aes!.decrypt(byteArray) {
            return String(data: Data(decrypted), encoding: .utf8)
        }
        return nil
    }
}


extension UITableView {
 func reloadNewData(completion:@escaping ()->()) {
    UIView.animate(withDuration:1.0, animations: {
                        DispatchQueue.main.async {
                            self.reloadData()
                        } })
         { _ in
        completion()
     }
 }
}
