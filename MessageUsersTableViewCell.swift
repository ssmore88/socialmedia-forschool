//
//  MessageUsersTableViewCell.swift
//  bruincave
//
//  Created by user128030 on 10/14/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class MessageUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var userPicImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
