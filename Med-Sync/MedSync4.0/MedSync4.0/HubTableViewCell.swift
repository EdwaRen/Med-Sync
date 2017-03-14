//
//  HubTableViewCell.swift
//  MedSync4.0
//
//  Created by - on 2017/01/24.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit

class HubTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
