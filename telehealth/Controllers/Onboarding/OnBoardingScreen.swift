//
//  OnboardingScreen.swift
//  telehealth
//
//  Created by iroid on 28/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class OnBoardingScreen: UIViewController {
    
    //MARK:UIImageView Outlet
    @IBOutlet weak var pageDotImageView: UIImageView!
    
    //MARK:UICollectionView Outlet
    @IBOutlet weak var onBoardingCollectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: dateSportButton!
    //MARK:Object Declration with initilization
    var onBoardingArray = [
        OnBoardingModel(imageName: "onboarding_1.png", title: Utility.getLocalizdString(value: "WE_CARE_FOR_YOU"), message: Utility.getLocalizdString(value: "YOU_CAN_DO_GREAT")),
        OnBoardingModel(imageName: "onboarding_2.png", title: Utility.getLocalizdString(value: "MENTAL_CARE"), message:  Utility.getLocalizdString(value: "THERE_IS_HOPE")),
        OnBoardingModel(imageName: "onboarding_3.png", title: Utility.getLocalizdString(value: "HEALTH_CARE"), message:  Utility.getLocalizdString(value: "IT_IS_EXERCISE_ALONE")),
        OnBoardingModel(imageName: "onboarding_4.png", title: Utility.getLocalizdString(value: "STRESS_RELAXATION") , message:  Utility.getLocalizdString(value: "IF_YOU_WANT_TO_CONQUER")),
    ]
    
    //MARK:Object Declration with initilization
    var itemsObservale : Observable<[OnBoardingModel]>!
    
    //MARK:Object Declration with initilization
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
        onBoardingCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        setupCollectionView()
//        [self.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
    }
    
    //MARK:UIButton Actions
    @IBAction func onNext(_ sender: UIButton) {
        let visibleItems: NSArray = self.onBoardingCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
        if currentItem.item == 3{
            let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
            let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
            self.navigationController?.pushViewController(control, animated: true)
            return
        }
            let nextItem: NSIndexPath = NSIndexPath(row: currentItem.row + 1, section: 0)
            self.onBoardingCollectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }
        else{
            if currentItem.item == 0{
                let storyBoard = UIStoryboard(name: "Choose", bundle: nil)
                let control = storyBoard.instantiateViewController(withIdentifier: "ChooseScreen") as! ChooseScreen
                self.navigationController?.pushViewController(control, animated: true)
                return
            }
            let nextItem: NSIndexPath = NSIndexPath(row: currentItem.row - 1, section: 0)
            self.onBoardingCollectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }
  
        }
        
        //MARK: Methods
        func setupCollectionView(){
            let nibCell = UINib(nibName: "OnBoardCollectionViewCell", bundle: nil)
            onBoardingCollectionView.register(nibCell, forCellWithReuseIdentifier: "OnBoardCell")
            if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
                itemsObservale = Observable.just(onBoardingArray.reversed())
            }else{
                itemsObservale = Observable.just(onBoardingArray)
            }
            
            onBoardingCollectionView.dataSource = nil
            itemsObservale.asObservable().bind(to: self.onBoardingCollectionView.rx.items(cellIdentifier: "OnBoardCell", cellType: OnBoardCollectionViewCell.self)) { row, data, cell in
                cell.mainImageView.image = UIImage(named: data.imageName ?? "")
                cell.titleLabel.text = data.title
                cell.messageLabel.text = data.message
                if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE) {
                    cell.titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.messageLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
                if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                        case 1136:
                            cell.titleLabel.font = UIFont(name: "Quicksand-Bold", size: 21)
                            cell.messageLabel.font = UIFont(name: "Quicksand-Regular", size: 18)
                        case 1334:
                            cell.titleLabel.font = UIFont(name: "Quicksand-Bold", size: 21)
                            cell.messageLabel.font = UIFont(name: "Quicksand-Regular", size: 18)
                            print("IPHONE 6,7,8 IPHONE 6S,7S,8S ")
                        case 1920, 2208:
                            print("IPHONE 6PLUS, 6SPLUS, 7PLUS, 8PLUS")
                        case 2436:
                            print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                        case 2688:
                            print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                        case 1792:
                            print("IPHONE XR, IPHONE 11")
                        default:
                            print("UNDETERMINED")
                        }
                    }
            }.disposed(by: disposeBag)
        }
    }

//MARK: CollectionView FlowLayout Delegate Methods
extension OnBoardingScreen : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height-20)
    }
}

//MARK: ScrollView  Delegate Methods
extension OnBoardingScreen : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let index = onBoardingCollectionView.indexPathForItem(at: center) {
            if index.row == 0{
                pageDotImageView.image = UIImage(named: "page_dot_first_icon.png")
            }else if index.row == 1{
                pageDotImageView.image = UIImage(named: "page_dot_second_icon.png")
            }else if index.row == 2{
                pageDotImageView.image = UIImage(named: "page_dot_third_icon.png")
            }else{
                pageDotImageView.image = UIImage(named: "page_dot_four_icon.png")
            }
        }
    }
}
