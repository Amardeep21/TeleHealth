//
//  SettingTableViewCell.swift
//  telehealth
//
//  Created by Apple on 11/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var circleView: dateSportView!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var bottomLineLabel: UILabel!
    @IBOutlet weak var cellSelectButton: UIButton!
    @IBOutlet weak var nextArrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
