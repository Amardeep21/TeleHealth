//
//  OnCountryTableViewCell.swift
//  telehealth
//
//  Created by iroid on 07/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class OnCountryTableViewCell: UITableViewCell {
  @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
