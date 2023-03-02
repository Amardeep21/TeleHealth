//
//  QuestionAnswerTableViewCell.swift
//  telehealth
//
//  Created by Apple on 05/11/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
