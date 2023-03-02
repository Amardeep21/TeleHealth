//
//  ManageNotificationScreen.swift
//  telehealth
//
//  Created by Apple on 25/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ManageNotificationScreen: UIViewController {
    
    @IBOutlet weak var blogSwitch: UISwitch!
    @IBOutlet weak var ucommingSessiionSwitch: UISwitch!
    @IBOutlet weak var messageSwitch: UISwitch!
    
    @IBOutlet weak var backButton: UIButton!
    var disposBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            blogSwitch.semanticContentAttribute = .forceRightToLeft
            ucommingSessiionSwitch.semanticContentAttribute = .forceRightToLeft
            messageSwitch.semanticContentAttribute = .forceRightToLeft
        }else{
            blogSwitch.semanticContentAttribute = .forceLeftToRight
            ucommingSessiionSwitch.semanticContentAttribute = .forceLeftToRight
            messageSwitch.semanticContentAttribute = .forceLeftToRight
        }
        // Do any additional setup after loading the view.
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
    
    func initalizedDetails(){
        if(UserDefaults.standard.object(forKey: "upcommingSession") == nil){
            UserDefaults.standard.set(false, forKey: "upcommingSession")
        }else{
            if(UserDefaults.standard.object(forKey: "upcommingSession") as! Bool == true){
                ucommingSessiionSwitch.setOn(true, animated: true)
            }else{
                ucommingSessiionSwitch.setOn(false, animated: true)
            }
            
        }
        if(UserDefaults.standard.object(forKey: "messageSwitch") == nil){
            UserDefaults.standard.set(false, forKey: "messageSwitch")
        }else{
            messageSwitch.setOn((UserDefaults.standard.object(forKey: "messageSwitch") != nil), animated: true)
            if(UserDefaults.standard.object(forKey: "messageSwitch") as! Bool == true){
                messageSwitch.setOn(true, animated: true)
            }else{
                messageSwitch.setOn(false, animated: true)
            }
        }
        if(UserDefaults.standard.object(forKey: "blogSwitch") == nil){
            
            UserDefaults.standard.set(false, forKey: "blogSwitch")
        }else{
            blogSwitch.setOn((UserDefaults.standard.object(forKey: "blogSwitch") != nil), animated: true)
            if(UserDefaults.standard.object(forKey: "blogSwitch") as! Bool == true){
                blogSwitch.setOn(true, animated: true)
            }else{
                blogSwitch.setOn(false, animated: true)
            }
        }
        
        ucommingSessiionSwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(ucommingSessiionSwitch.rx.value)
            .subscribe(onNext : { bool in
                if(bool){
                    self.onSetting()
                }else{
                    self.onSetting()
                }
            })
            .disposed(by: disposBag)
        
        messageSwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(messageSwitch.rx.value)
            .subscribe(onNext : { bool in
                if(bool){
                    self.onSetting()
                }else{
                    self.onSetting()
                }
            })
            .disposed(by: disposBag)
        
        blogSwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(blogSwitch.rx.value)
            .subscribe(onNext : { bool in
                if(bool){
                    self.onSetting()
                }else{
                    self.onSetting()
                }
            })
            .disposed(by: disposBag)
    }
    
    func onSetting(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = ["sessionReminder":ucommingSessiionSwitch.isOn,
                              "blogReminder":blogSwitch.isOn,
                              "chatReminder":messageSwitch.isOn
                ] as [String : Any]
            ProfileServices.shared.setting(parameters: parameters, success: { (statusCode, changePasswordModel) in
                Utility.hideIndicator()
                UserDefaults.standard.set(changePasswordModel.data?.sessionReminder, forKey: "upcommingSession")
                UserDefaults.standard.set(changePasswordModel.data?.chatReminder, forKey: "messageSwitch")
                UserDefaults.standard.set(changePasswordModel.data?.blogReminder, forKey: "blogSwitch")
//                let refreshAlert = UIAlertController(title: APPLICATION_NAME, message: changePasswordModel.message!, preferredStyle: UIAlertController.Style.alert)
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//
//                }))
//                self.present(refreshAlert, animated: true, completion: nil)
//                self.navigationController?.popViewController(animated: true)
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
