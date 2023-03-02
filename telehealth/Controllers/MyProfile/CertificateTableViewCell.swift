//
//  CertificateTableViewCell.swift
//  telehealth
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class CertificateTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
