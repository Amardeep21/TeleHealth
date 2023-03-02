//
//  QuestionTableViewCell.swift
//  telehealth
//
//  Created by Apple on 04/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit


protocol CollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: QuestionOptionCollectionViewCell?, index: Int, didTappedInTableViewCell: QuestionTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionsCollectionView: UICollectionView!
    weak var cellDelegate: CollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let cellNib = UINib(nibName: "QuestionOptionCollectionViewCell", bundle: nil)
                self.optionsCollectionView.register(cellNib, forCellWithReuseIdentifier: "OptionsCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//extension QuestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    // The data we passed from the TableView send them to the CollectionView Model
//    func updateCellWith() {
////        self.rowWithColors = row
//        self.optionsCollectionView.reloadData()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
////    func numberOfSections(in collectionView: UICollectionView) -> Int {
////        return 1
////    }
//    
//    // Set the data for each cell (color and color name)
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as? QuestionOptionCollectionViewCell {
//            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//          let cell = collectionView.cellForItem(at: indexPath) as? QuestionOptionCollectionViewCell
//          self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
//      }
//      
//        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: self.contentView.frame.width - 40, height: 50)
//           
//    }
//    
//    // Add spaces at the beginning and the end of the collection view
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
////    }
//}
//extension QuestionTableViewCell: CollectionViewCellDelegate {
//    func collectionView(collectionviewcell: QuestionOptionCollectionViewCell?, index: Int, didTappedInTableViewCell: QuestionTableViewCell) {
////        if let colorsRow = didTappedInTableViewCell.rowWithColors {
////            print("You tapped the cell \(index) in the row of colors \(colorsRow)")
////            // You can also do changes to the cell you tapped using the 'collectionviewcell'
////        }
//    }
//}
