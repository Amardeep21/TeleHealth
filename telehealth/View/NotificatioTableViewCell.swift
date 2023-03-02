//
//  NotificatioTableViewCell.swift
//  telehealth
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class NotificatioTableViewCell: UITableViewCell {

    @IBOutlet weak var timeIcon: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileIcon: dateSportImageView!
    
    @IBOutlet weak var onProfiileButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
