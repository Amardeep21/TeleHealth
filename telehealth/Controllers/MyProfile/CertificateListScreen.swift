//
//  CertificateListScreen.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CertificateListScreen: UIViewController {
    
    @IBOutlet weak var certificateListTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var items : Observable<[Certificate]>!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializedDetails()
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
    
    func initializedDetails(){
              certificateListTableView.register(UINib(nibName: "CertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "CertificateCell")
                 if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                     do{
                        
                        if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                            items = Observable.just((loginDetails.data?.userInfo?.certificates)!)
                        }
                     }catch{}
                 }
        self.loadCertificateTable()
    }
    
    func loadCertificateTable(){
        certificateListTableView.dataSource = nil
        items.bind(to: certificateListTableView.rx.items(cellIdentifier: "CertificateCell", cellType:CertificateTableViewCell.self)){(row,item,cell) in
            cell.titleLabel.text = item.title
            cell.iconImageView.image = UIImage(named: "certificate_new_icon")
        }.disposed(by: disposeBag)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
