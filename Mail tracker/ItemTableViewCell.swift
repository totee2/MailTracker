//
//  ItemTableViewCell.swift
//  Mail tracker
//
//  Created by Antonia Schmidt-Lademann on 13/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var sentControl: SentControl!
    @IBOutlet weak var date: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
