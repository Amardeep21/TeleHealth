//
//  SessionsTableViewCell.swift
//  telehealth
//
//  Created by iroid on 21/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class SessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var videoOrAudioButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var sessionTypeLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var serviceTellingConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
