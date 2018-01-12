//
//  SensorTableViewCell.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 12.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descText: UITextField!
    
       
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
