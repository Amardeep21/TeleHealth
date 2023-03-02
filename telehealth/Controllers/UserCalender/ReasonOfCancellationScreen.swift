//
//  ReasonOfCancellationScreen.swift
//  telehealth
//
//  Created by iroid on 04/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift

class ReasonOfCancellationScreen: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var appointmentId = Int()
    private let presentedViewControllerDismiss = BehaviorSubject(value: false)
       var controllerDismissed:Observable<Bool> {
           return presentedViewControllerDismiss.asObservable()
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        if descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utility.showAlert(vc: self, message: Utility.getLocalizdString(value: "PLEASE_ENTER_YOUR_REASON"))
            return
        }
        onCancelSession()
    }
    @IBAction func onCanecl(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onCancelSession(){
        weak var pvc = self.presentingViewController

        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(CANCEL_APPOINTMENT)\(appointmentId)"
            var parameters = [
                "reason":descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)] as [String : Any]
            SessionServices.shared.cencelSession(parameters: parameters, url: url, success:{ (statusCode, commanModel) in
                Utility.hideIndicator()
                self.dismiss(animated: true, completion:{
                     let refreshAlert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: commanModel.message, preferredStyle: UIAlertController.Style.alert)

                                    refreshAlert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "TELEHEALTH"))", style: .default, handler: { (action: UIAlertAction!) in
                                        self.presentedViewControllerDismiss.onNext(true)
                                      }))
                      NotificationCenter.default.post(name: Notification.Name("REFRESH_DATA"), object: nil, userInfo:nil)
                    pvc!.present(refreshAlert, animated: true, completion: nil)
                })
               
               
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
