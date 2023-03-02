//
//  PsychologistsCollectionViewCell.swift
//  telehealth
//
//  Created by Apple on 15/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class PsychologistsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var chatPriceLabel: UILabel!
    
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var audioVideoPriceLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var yearOfExpLabel: UILabel!
    @IBOutlet weak var audioVideoView: UIView!
    @IBOutlet weak var chatView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
