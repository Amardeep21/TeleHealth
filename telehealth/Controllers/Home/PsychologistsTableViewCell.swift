//
//  PsychologistsTableViewCell.swift
//  telehealth
//
//  Created by Apple on 17/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class PsychologistsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityDiscriptionLabel: UILabel!
    @IBOutlet weak var yearExpLabel: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var audioVideoLable: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        bounds = bounds.inset(by: padding)
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
