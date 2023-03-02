//
//  SenderTableViewCell.swift
//  socketIOChatDemo
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
