//
//  favoriteDB.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import Foundation
import UIKit

let DBChange = "DB_CHANGED"

class FavoriteDB {
    static var sharedInstance = FavoriteDB()
    
    var videos: [Int] = [170001] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(DBChange), object: self)
        }
    }
    var uploaders : [Int] = [7483880] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(DBChange), object: self)
        }
    }
}
