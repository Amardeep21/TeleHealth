//
//  AppSecurityScreen.swift
//  telehealth
//
//  Created by iroid on 08/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AppSecurityScreen: UIViewController {
    
    @IBOutlet weak var pinOnOffSwitch: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
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
        pinOnOffSwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(pinOnOffSwitch.rx.value)
            .subscribe(onNext : { bool in
                // this is the value of mySwitch
                if(bool){
                    UserDefaults.standard.set(true, forKey: APP_SECURITY)
                }else{
                    UserDefaults.standard.set(false, forKey: APP_SECURITY)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    @IBAction func onChangeLocalPasscode(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
        control.isFromChangePasscode = true
        self.navigationController?.pushViewController(control, animated: true)
    }
    
}
