//
//  RequestTableViewCell.swift
//  telehealth
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var onDelete: UIButton!
    @IBOutlet weak var onBook: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var onProfileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
