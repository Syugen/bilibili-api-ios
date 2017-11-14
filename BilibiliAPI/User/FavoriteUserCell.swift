//
//  FavoriteUserCell.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/13.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class FavoriteUserCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
