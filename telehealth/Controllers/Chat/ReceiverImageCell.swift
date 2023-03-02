//
//  ReceiverImageCell.swift
//  telehealth
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class ReceiverImageCell: UITableViewCell {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var receiverImageCell: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
