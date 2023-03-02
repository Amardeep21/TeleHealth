//
//  ChatTableViewCell.swift
//  Medics2you
//
//  Created by Techwin iMac-2 on 20/04/20.
//  Copyright © 2020 Techwin iMac-2. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var messageCountLabel: dateSportLabel!
    @IBOutlet weak var doctorImage: dateSportImageView!
    @IBOutlet weak var onlineView: dateSportLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
