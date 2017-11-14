//
//  FavoriteVideoCell.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class FavoriteVideoCell: UITableViewCell {
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoID: UILabel!
    @IBOutlet weak var videoDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
