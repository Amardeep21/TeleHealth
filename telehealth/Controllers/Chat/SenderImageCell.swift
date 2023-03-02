//
//  SenderImageCell.swift
//  telehealth
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class SenderImageCell: UITableViewCell {

    @IBOutlet weak var downloadImageButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var senderImageView: dateSportImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
