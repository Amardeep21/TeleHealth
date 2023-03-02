//
//  FeedbackScreen.swift
//  telehealth
//
//  Created by iroid on 01/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa
class FeedbackScreen: UIViewController {
    
    @IBOutlet weak var feedbackTextView: dateSportTextView!
    @IBOutlet weak var rattingView: CosmosView!
    
    var rate = 0
    var psychologistId = 0
    var onDoneBlock2 : ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)

//        if(Utility.getCurrentLanguage() == "ar"){
//            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
//        }else{
//            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
//        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if(self.onDoneBlock2 != nil){
        self.onDoneBlock2!(true)
        }
    }
    func initalizedDetails(){
        rattingView.didTouchCosmos = didTouchCosmos
        rattingView.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating(requiredRating: nil)
    }
    private func updateRating(requiredRating: Double?) {
        var newRatingValue: Double = 0
        
        if let nonEmptyRequiredRating = requiredRating {
            newRatingValue = nonEmptyRequiredRating
        }
        rattingView.rating = newRatingValue
        rate = Int(newRatingValue)
        // rate = FeedbackScreen.formatValue(newRatingValue)
        
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.0f", value)
    }
    private func didTouchCosmos(_ rating: Double) {
        print(rating)
        updateRating(requiredRating: rating)
        
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        //      ratingSlider.value = Float(rating)
        print(rating)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        giveRating()
    }
    
    //MARK: Ratting Success Alert
    func rattingSuccessAlert(msg:String) {
        let alert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: {
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:post giveRating list Api Call
    func giveRating() {
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                
                let parameters = [RATING:rate ,
                                  PSYCHOLOGIST_ID:psychologistId,
                                  CONTENT:feedbackTextView.text!
                    ] as [String : Any]
                
                FeedbackService.shared.setFeedback(parameters: parameters, success: { (statusCode, commanModel) in
                    Utility.hideIndicator()
                    self.rattingSuccessAlert(msg: commanModel.message!)
//                    self.onDoneBlock2!(true)
                }) { (error) in
                    Utility.hideIndicator()
                    Utility.showAlert(vc: self, message: error)
                }
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
}
