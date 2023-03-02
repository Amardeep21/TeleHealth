//
//  PayAndConfirmTableViewCell.swift
//  telehealth
//
//  Created by iroid on 11/02/21.
//  Copyright © 2021 iroid. All rights reserved.
//

import UIKit

class PayAndConfirmTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var audioVideoButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    var onPayAndConfirm : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utility.setLocalizedValuesforView(parentview: self.contentView, isSubViews: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onPayAndConfirm(_ sender: Any) {
        self.onPayAndConfirm!()
    }
    
    
}
