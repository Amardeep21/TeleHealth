//
//  SpecialityListScreen.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

class SpecialityListScreen: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var specialityListCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:Object Declration with initilization
//    var itemsObservale : Observable<[SpecialityInformationModel]>!
    
    //MARK:Object Declration with initilization
//    let disposeBag = DisposeBag()
    
    //MARK:Variable Declration with initilization
      var specialityArray = [SpecialityInformationModel]()
    
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
//        self.setupCollectionViewSelectMethod()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initalizedDetails(){
        let nibCell = UINib(nibName: "SpecialityCollectionViewCell", bundle: nil)
        specialityListCollectionView.register(nibCell, forCellWithReuseIdentifier: "SpecialityCell")
        self.specialityListCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = specialityArray[indexPath.row]
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
        control.isFromSpeciality = true
        control.specialityModel = item
        self.navigationController?.pushViewController(control, animated: true)
    }
    //MARK: Methods
//       func setupCollectionView(){
//           let nibCell = UINib(nibName: "SpecialityCollectionViewCell", bundle: nil)
//           specialityListCollectionView.register(nibCell, forCellWithReuseIdentifier: "SpecialityCell")
//           itemsObservale = Observable.just(specialityArray)
//           specialityListCollectionView.dataSource = nil
//           itemsObservale.asObservable().bind(to: self.specialityListCollectionView.rx.items(cellIdentifier: "SpecialityCell", cellType: SpecialityCollectionViewCell.self)) { row, data, cell in
//               Utility.setImage(data.icon, imageView: cell.specialityImageView)
//               cell.specialityTitle.text = data.speciality
//           }.disposed(by: disposeBag)
//       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return specialityArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialityCell", for: indexPath) as! SpecialityCollectionViewCell
            let data = specialityArray[indexPath.row]
            Utility.setImage(data.icon, imageView: cell.specialityImageView)
            cell.specialityTitle.text = data.speciality
            return cell
        }
    
//    func setupCollectionViewSelectMethod(){
//        self.specialityListCollectionView.rx.modelSelected(SpecialityInformationModel.self)
//            .takeUntil(self.rx.methodInvoked(#selector(viewWillDisappear)))
//            .subscribe(onNext: {
//                item in
//                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
//                let control = storyBoard.instantiateViewController(withIdentifier: "PsychologistsScreen") as! PsychologistsScreen
//                control.isFromSpeciality = true
//                control.specialityModel = item
//                self.navigationController?.pushViewController(control, animated: true)
//            }).disposed(by: disposeBag)
//    }
}

//MARK: CollectionView FlowLayout Delegate Methods
extension SpecialityListScreen : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 20) / 2 // compute your cell width
        return CGSize(width: cellWidth, height: 160)
       
    }
}
