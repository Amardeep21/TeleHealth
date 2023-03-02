//
//  SpecialityCell.swift
//  telehealth
//
//  Created by iroid on 17/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

protocol SpecialityCellDelegate:NSObjectProtocol {
    func didTapCell(_ cell:SpecialityCell)
}
class SpecialityCell: UITableViewCell {

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var specialityTypeLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    var delegate:SpecialityCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureData(speciality:String){
        specialityTypeLabel.text = speciality
    }
    
}
