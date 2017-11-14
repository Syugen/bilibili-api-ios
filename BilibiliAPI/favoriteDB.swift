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

let VideoImgs = "VIDEO_IMGS"
let VideoIDs = "VIDEO_IDS"
let VideoTitles = "VIDEO_TITLES"
let UserImgs = "USER_IMGS"
let UserIDs = "USER_IDS"
let UserNames = "USER_NAMES"

class FavoriteDB {
    static var sharedInstance = FavoriteDB()
    
    var videoIDs: [String] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(VideoDBChange), object: self)
        }
    }
    var videoTitles: [String?]
    var videoImgs: [UIImage?]
    
    var userIDs : [String] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(UserDBChange), object: self)
        }
    }
    var userNames: [String?]
    var userImgs: [UIImage?]
    
    init() {
        self.videoIDs = UserDefaults.standard.object(forKey: VideoIDs) as? [String] ?? []
        self.videoTitles = UserDefaults.standard.object(forKey: VideoTitles) as? [String?] ?? []
        if let imgs = UserDefaults.standard.object(forKey: VideoImgs) as? Data {
            self.videoImgs = NSKeyedUnarchiver.unarchiveObject(with: imgs) as? [UIImage?] ?? []
        } else {
            self.videoImgs = []
        }
        
        self.userIDs = UserDefaults.standard.object(forKey: UserIDs) as? [String] ?? []
        self.userNames = UserDefaults.standard.object(forKey: UserNames) as? [String?] ?? []
        if let imgs = UserDefaults.standard.object(forKey: UserImgs) as? Data {
            self.userImgs = NSKeyedUnarchiver.unarchiveObject(with: imgs) as? [UIImage?] ?? []
        } else {
            self.userImgs = []
        }
        
        if self.videoIDs.count != self.videoTitles.count ||
            self.videoIDs.count != self.videoImgs.count {
            removeVideos()
        }
        
        if self.userIDs.count != self.userNames.count ||
            self.userIDs.count != self.userImgs.count {
            removeUsers()
        }
    }
    
    func removeVideos() {
        let videoImages = NSKeyedArchiver.archivedData(withRootObject: [])
        UserDefaults.standard.set(videoImages, forKey: VideoImgs)
        UserDefaults.standard.set([], forKey: VideoIDs)
        UserDefaults.standard.set([], forKey: VideoTitles)
        self.videoIDs = []
        self.videoTitles = []
        self.videoImgs = []
    }
    
    func removeUsers() {
        let userImages = NSKeyedArchiver.archivedData(withRootObject: [])
        UserDefaults.standard.set(userImages, forKey: UserImgs)
        UserDefaults.standard.set([], forKey: UserIDs)
        UserDefaults.standard.set([], forKey: UserNames)
        self.userIDs = []
        self.userNames = []
        self.userImgs = []
    }
}
