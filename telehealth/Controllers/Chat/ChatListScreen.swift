//
//  ChatListScreen.swift
//  telehealth
//
//  Created by Apple on 11/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatListScreen: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    var metaData:MetaDataModel!
    var chatListArray = [ChatListModel]()
    var items : Observable<[ChatListModel]>!
    let disposeBag = DisposeBag()
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        self.getChatList()
        self.didSelect()
        firstTime = false
        Observable.zip(searchTextField.rx.text,
                       searchTextField.rx.text.skip(1))
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (old, new) in
                if(new != ""){
                    if(old != new){
                        self.metaData = nil
                        self.getChatList(shouldShow: false)
                    }
                }else{
                    self.metaData = nil
                    self.metaData = nil
                     self.getChatList(shouldShow: false)
                }
            }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(firstTime){
            chatListArray = []
            items = nil
            metaData = nil
            self.getChatList(shouldShow: false)
        }else{
            firstTime = true
        }
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
   
    func loadMoreUrl() -> String{
        var url = String()
        if(self.metaData == nil){
            url = "\(CHAT_LIST)?page=1"
        }else{
            let urlArray = (metaData.next_page_url)?.split(separator: "/")
            
            url = "\(urlArray?.last ?? "")"
        }
        return url
    }
    
    func loadListTable(){
        chatTableView.dataSource = nil
        items.bind(to: chatTableView.rx.items(cellIdentifier: "ChatCell", cellType:ChatTableViewCell.self)){(row,item,cell) in
            Utility.setImage(item.profile, imageView: cell.doctorImage)
            cell.doctorNameLabel.text = item.username
            if(item.type == 1){
                var decryptedMessage = String()
                decryptedMessage = (item.message ?? "").aesDecrypt() ?? ""
                cell.messageLabel.text = decryptedMessage
            }else if(item.type == 2){
                cell.messageLabel.text = "Attachment"
            }else{
                cell.messageLabel.text = "File"
            }
            cell.timeLabel.text = Utility.UTCToLocal(date: item.time ?? "", fromFormat: YYYY_MM_DDHHMMSS, toFormat: HHMMA)
            if(item.unseenMessage == 0){
                cell.messageCountLabel.isHidden = true
            }else{
                cell.messageCountLabel.isHidden = false
                cell.messageCountLabel.text = "\(item.unseenMessage ?? 0)"
            }
            if(item.isOnline == 0){
                cell.onlineView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
            }else{
                cell.onlineView.backgroundColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.537254902, alpha: 1)
            }
        }.disposed(by: disposeBag)
    }
    
    func didSelect(){
        Observable
            .zip(chatTableView.rx.itemSelected, chatTableView.rx.modelSelected(ChatListModel.self))
            .bind { [unowned self] indexPath, model in
               
                    let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "ChatScreen") as! ChatScreen
                    control.isFromChatScreen = true
                    control.chatListModel = model
                    self.navigationController?.pushViewController(control, animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    func getChatList(shouldShow:Bool=true){
        if Utility.isInternetAvailable(){
            if(shouldShow){
                Utility.showIndicator()
            }
            var parameters: [String : Any] = [:]
            if(searchTextField.text != ""){
              parameters = ["search":searchTextField.text!] as [String : Any]
            }
            let url = self.loadMoreUrl()
            ChatServices.shared.getChatList(parameters: parameters,url: url, success: { (statusCode, chatModel) in
                Utility.hideIndicator()
                if(self.metaData == nil){
                    self.chatListArray = []
                    self.chatListArray.append(contentsOf:  chatModel.data ?? [])
                }else{
                    self.chatListArray.append(contentsOf: chatModel.data ?? [])
                }
                self.metaData = chatModel.meta
                self.items = Observable.just(chatModel.data ?? [])
                self.loadListTable()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


