//
//  QuestionOptionNewTableViewCell.swift
//  telehealth
//
//  Created by iroid on 05/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class QuestionOptionNewTableViewCell: UITableViewCell {

    @IBOutlet weak var checkUncheckImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
