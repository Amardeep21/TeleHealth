//
//  ForgotPasswordScreen.swift
//  telehealth
//
//  Created by iroid on 30/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class ForgotPasswordScreen: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(string: Utility.getLocalizdString(value: "EMAIL"),
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Utility.getUIcolorfromHex(hex: "#3B56A5")])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSendEmail(_ sender: UIButton) {
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "ENTER_YOUR_EMAIL"))
            return
        }
        else if !emailTextField.text.isEmailValid(){
            Utility.showAlert(vc: self, message: "Please enter a valid email")
            return
        }
        self.onForgotPassword()
    }
    
    //MARK:Forgot Password Api Call
    func onForgotPassword() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [EMAIL : emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                ] as [String : Any]
            LoginServices.shared.forgotPassword(parameters: parameters, success: { (statusCode, forgotPasswordModel) in
                Utility.hideIndicator()
                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: forgotPasswordModel.message!, preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: .default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
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
