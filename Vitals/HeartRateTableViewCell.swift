//
//  HeartRateTableViewCell.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 10/18/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit

class HeartRateTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewDate: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var tableViewTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
