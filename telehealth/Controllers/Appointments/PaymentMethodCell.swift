//
//  PaymentMethodCell.swift
//  telehealth
//
//  Created by iroid on 18/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentIconImageView: UIImageView!
    @IBOutlet weak var tapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
