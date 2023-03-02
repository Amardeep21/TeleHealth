//
//  AboutUsScreen.swift
//  telehealth
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class AboutUsScreen: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    
    @IBAction func onFaq(_ sender: Any) {
        
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "FAQ"), url: ARABIC_FAQ_URL)
        }
        else{
            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "FAQ"), url: FAQ_URL)
        }
    }
   
    @IBAction func onAboutUs(_ sender: Any) {
         
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "ABOUT_US"), url: ARABIC_ABOUT_US_URL)
        }
        else{
            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "ABOUT_US"), url: ABOUT_US_URL)
        }
    }
    
    @IBAction func onTermsAndCondition(_ sender: Any) {
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    if(loginDetails.data?.role == 1){
                     
                        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "TERMS_AND_CONDITION"), url: ARABIC_TERMS_URL_CLIENT)
                        }
                        else{
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "TERMS_AND_CONDITION"), url: TERMS_URL_CLIENT)
                        }
                    }else{
                        
                        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "TERMS_AND_CONDITION"), url: ARABIC_TERMS_URL_THERPIST)
                        }
                        else{
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "TERMS_AND_CONDITION"), url: TERMS_URL_THERPIST)
                        }
                    }
                    
                   
                }
            }catch{}
        }
        
    }
    
    @IBAction func onPrivacyPolicy(_ sender: Any) {
        if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
            do{
                if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                    if(loginDetails.data?.role == 1){
                        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
                        self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "PRIVACY_POLICY"), url: PRIVACY_URL_CLIENT)
                        }else{
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "PRIVACY_POLICY"), url: ARABIC_PRIVACY_URL_CLIENT)
                        }
                    }else{
                       
                        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "PRIVACY_POLICY"), url: ARABIC_PRIVACY_URL_THERPIST)
                        }else{
                            self.navigateToWebviewScreen(title: Utility.getLocalizdString(value: "PRIVACY_POLICY"), url: PRIVACY_URL_THERPIST)
                        }
                    }
                    
                   
                }
            }catch{}
        }
        
       
    }
    
    func navigateToWebviewScreen(title:String,url:String){
        let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
        control.titleType = title
        control.url = url
        self.navigationController?.pushViewController(control, animated: true)
    }
}
