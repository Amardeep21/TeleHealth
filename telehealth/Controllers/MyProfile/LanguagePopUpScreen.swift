//
//  LanguagePopUpScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class LanguagePopUpScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onDismissLanguageView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEnglish(_ sender: UIButton) {
        //Utility.setLanguage(langStr: ENGLISH_LANG_CODE)
//        UserDefaults.standard.set(ENGLISH_LANG_CODE, forKey: LANGUAGE)
        UserDefaults.standard.set(ENGLISH_LANG_CODE, forKey: LANGUAGE)
        Utility.setLanguage(langStr: ENGLISH_LANG_CODE)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.dismiss(animated: true, completion: {
            
            
            
            let objStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let rootNav = objStoryboard.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
                        UIApplication.shared.keyWindow?.rootViewController = rootNav
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(controller, animated: false)
        })
    }
    @IBAction func onArabic(_ sender: UIButton) {
        //Utility.setLanguage(langStr: ARABIC_LANG_CODE)
        
        UserDefaults.standard.set(ARABIC_LANG_CODE, forKey: LANGUAGE)
        Utility.setLanguage(langStr: ARABIC_LANG_CODE)
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        self.dismiss(animated: true, completion: {
            let objStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let rootNav = objStoryboard.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
                        UIApplication.shared.keyWindow?.rootViewController = rootNav
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(controller, animated: false)
        })
       }
    
}
