//
//  ReadingTableViewCell.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 05.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import UIKit

class ReadingTableViewCell: UITableViewCell {

    @IBOutlet weak var DateText: UITextField!
    
    @IBOutlet weak var ValueText: UITextField!
    
    @IBOutlet weak var SensorText: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
