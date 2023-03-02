//
//  ChangePasswordScreen.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class ChangePasswordScreen: UIViewController {
    
    //MARK: UITextField Outlets
    @IBOutlet weak var currantPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: UIImageView Outlets
    @IBOutlet weak var newPasswordVisibleOrNotVisibleImage: UIImageView!
    @IBOutlet weak var currantPasswordVisibleOrNotVisibleImage: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
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
    
    @IBAction func onCurrantPassword(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            currantPasswordTextField.isSecureTextEntry = true
            currantPasswordVisibleOrNotVisibleImage.image = UIImage(named: "password_not_visible.png")
            
        }else{
            sender.isSelected = true
            currantPasswordTextField.isSecureTextEntry = false
            currantPasswordVisibleOrNotVisibleImage.image = UIImage(named: "password_visible.png")
        }
    }
    @IBAction func onNewPassword(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            newPasswordTextField.isSecureTextEntry = true
            newPasswordVisibleOrNotVisibleImage.image = UIImage(named: "password_not_visible.png")
            
        }else{
            sender.isSelected = true
            newPasswordTextField.isSecureTextEntry = false
            newPasswordVisibleOrNotVisibleImage.image = UIImage(named: "password_visible.png")
        }
    }
    
    @IBAction func onConfirmPassword(_ sender: UIButton) {
        if sender.isSelected{
                 sender.isSelected = false
                 confirmPasswordTextField.isSecureTextEntry = true
                 confirmPasswordImageView.image = UIImage(named: "password_not_visible.png")
                 
             }else{
                 sender.isSelected = true
                 confirmPasswordTextField.isSecureTextEntry = false
                 confirmPasswordImageView.image = UIImage(named: "password_visible.png")
             }
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if currantPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_ENTER_CURRENT_PASSWORD"))
            return
        }else if newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_ENTER_NEW_PASSWORD"))
            return
        }else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_ENTER_CONFIRM_PASSWORD"))
            return
        }
        else if newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines){
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "OLD_PASS_NEW_PASS_MUST_BE_SAME"))
            return
        }
        self.onChangePassword()
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onChangePassword(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = [CURRENTPASSWORD :currantPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                              NEWPASSWORD:newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                ] as [String : Any]
            ProfileServices.shared.changePassword(parameters: parameters, success: { (statusCode, changePasswordModel) in
                Utility.hideIndicator()
                let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: changePasswordModel.message!, preferredStyle: UIAlertController.Style.alert)
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
extension ChangePasswordScreen :UITextFieldDelegate{
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            switch textField{
            case currantPasswordTextField:
                if newText.count >= 1 &&  newPasswordTextField.text!.count >= 1 && !((newPasswordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                    saveButton.backgroundColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 1)
                   
                }else{
                    saveButton.backgroundColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 0.6)
                }
                case newPasswordTextField:
                if currantPasswordTextField.text!.count >= 1 &&  newText.count >= 1  {
                     saveButton.backgroundColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 1)
                }else{
                    saveButton.backgroundColor = #colorLiteral(red: 0, green: 0.6954650283, blue: 0.8513801098, alpha: 0.6)
                }
            
            default: break
                
            }
             return true
}
}
