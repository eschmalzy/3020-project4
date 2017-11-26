//
//  ItemCell.swift
//  Homepwner
//
//  Created by Ethan Schmalz on 9/29/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var drawnImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        detailLabel.adjustsFontForContentSizeCategory = true
        
        
    }
    
}
