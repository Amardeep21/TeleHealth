//
//  ChooseScreen.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class ChooseScreen: UIViewController {
    
    var isFromApi:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.hideIndicator()
        if(isFromApi){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "SESSION_EXPIRED"))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    @IBAction func onPsychologists(_ sender: UIButton) {
        self.gotoLoginScreen(type: "2")
    }
    @IBAction func onPatients(_ sender: UIButton) {
        self.gotoLoginScreen(type: "1")
    }
    
    func gotoLoginScreen(type: String){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginScreen
        control.role = type
        self.navigationController?.pushViewController(control, animated: true)
    }
}
