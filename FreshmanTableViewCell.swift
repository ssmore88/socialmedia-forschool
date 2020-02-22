//
//  FreshmanTableViewCell.swift
//  bruincave
//
//  Created by user128030 on 8/20/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class FreshmanTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postedImageView: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
