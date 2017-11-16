//
//  VideoDescriptionController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/14.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoDescriptionController: UIViewController {
    var descriptionText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = self.descriptionText
        navigationItem.title = "Description".localized
        self.descriptionText.font = UIFont.systemFont(ofSize: 17)
    }
}
