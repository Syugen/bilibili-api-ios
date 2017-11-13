//
//  favoriteDB.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import Foundation
import UIKit

let VideoDBChange = "VIDEO_DB_CHANGED"
let UserDBChange = "USER_DB_CHANGED"

class FavoriteDB {
    static var sharedInstance = FavoriteDB()
    
    var videoIDs: [String] = ["170001"] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(VideoDBChange), object: self)
        }
    }
    var videoTitles: [String?] = ["asdf"]
    var videoImgs: [UIImage?] = [nil]
    
    var userIDs : [String] = ["7483880"] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(UserDBChange), object: self)
        }
    }
}
