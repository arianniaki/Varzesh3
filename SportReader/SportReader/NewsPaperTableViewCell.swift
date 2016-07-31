//
//  NewsPaperTableViewCell.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/9/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit

class NewsPaperTableViewCell: UITableViewCell {

    @IBOutlet weak var newspaperTitle: UILabel!
    
    @IBOutlet weak var newspaperImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
