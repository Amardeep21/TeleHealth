//
//  SpecialityCollectionViewCell.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class SpecialityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var specialityImageView: UIImageView!
    
    @IBOutlet weak var specialityTitle: UILabel!
    
    @IBOutlet weak var specialitySelectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
