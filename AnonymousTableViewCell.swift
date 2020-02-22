//
//  AnonymousTableViewCell.swift
//  bruincave
//
//  Created by user128030 on 10/14/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class AnonymousTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    var onViewCommentsTapped : (() -> Void)? = nil
    @IBAction func viewComments(_ sender: UIButton) {
        if let onViewCommentsTapped = self.onViewCommentsTapped {
            onViewCommentsTapped()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
