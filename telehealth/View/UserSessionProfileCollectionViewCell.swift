//
//  UserSessionProfileCollectionViewCell.swift
//  telehealth
//
//  Created by Apple on 02/10/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class UserSessionProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userProfileImageView: dateSportImageView!
    @IBOutlet weak var userNameImageView: UILabel!
    @IBOutlet weak var audioOrVideoButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var chatButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
