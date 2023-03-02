//
//  SessionBookTableViewCell.swift
//  telehealth
//
//  Created by iroid on 19/02/21.
//  Copyright © 2021 iroid. All rights reserved.
//

import UIKit

class SessionBookTableViewCell: UITableViewCell {

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
