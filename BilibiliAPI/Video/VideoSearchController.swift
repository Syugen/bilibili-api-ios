//
//  VideoSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/10/15.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoSearchController: UITableViewController {
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var upImage: UIImageView!
    @IBOutlet weak var upName: UILabel!
    @IBOutlet weak var videoamount: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var upsign: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var danmakuCount: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var coinCount: UILabel!
    @IBOutlet weak var ShareCount: UILabel!
    @IBOutlet weak var curRanking: UILabel!
    @IBOutlet weak var hisRanking: UILabel!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var uploaderCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var videoTitleCell: UITableViewCell!
    @IBOutlet var statTable: UITableView!
    
    let searchBar = UISearchBar()
    var searchButtonPressed = false
    var info_set = false
    var aid: String!
    var uid: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = searchBar
        self.searchBar.keyboardType = UIKeyboardType.numberPad
        self.searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        self.statTable.isHidden = true
        self.favoriteIcon.addTarget(self, action: #selector(favoritePressed), for: UIControlEvents.touchUpInside)
        
        let searchButton = UIBarButtonItem(title: "Search".localized, style: .plain, target: self, action: #selector(searchPressed))
        self.navigationItem.setRightBarButton(searchButton, animated: true)
        reset_views()
        if self.searchButtonPressed {
            self.searchButtonPressed = false
            search()
        }
    }
    
    func reset_views() {
        self.videoName.text = ""
        self.upImage.image = nil
        self.upName.text = ""
        self.videoamount.text = ""
        self.following.text = ""
        self.follower.text = ""
        self.upsign.text = ""
        self.videoImage.image = nil
        self.desc.text = ""
        self.viewCount.text = ""
        self.danmakuCount.text = ""
        self.replyCount.text = ""
        self.favoriteCount.text = ""
        self.coinCount.text = ""
        self.ShareCount.text = ""
        self.curRanking.text = ""
        self.hisRanking.text = ""
        self.copyright.text = ""
        self.info_set = false
        self.uid = nil
        self.videoTitleCell.isUserInteractionEnabled = false
        self.uploaderCell.isUserInteractionEnabled = false
        self.descriptionCell.isUserInteractionEnabled = false
        self.videoTitleCell.accessoryType = UITableViewCellAccessoryType.none
        self.uploaderCell.accessoryType = UITableViewCellAccessoryType.none
        self.descriptionCell.accessoryType = UITableViewCellAccessoryType.none
        self.favoriteIcon.isHidden = true
        self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
    }
    
    @objc func searchPressed(_ sender: UIBarButtonItem) {
        search()
    }
    
    @objc func favoritePressed() {
        if let index = DB.shared.videoIDs.index(of: self.aid) {
            self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
            DB.shared.videoTitles.remove(at: index)
            DB.shared.videoImgs.remove(at: index)
            DB.shared.videoIDs.remove(at: index)
            let alertController = UIAlertController(title: "Favorite removed".localized, message:
                "This video has been removed from your favorite collection.".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            DB.shared.videoTitles.append(self.videoName.text)
            DB.shared.videoImgs.append(self.videoImage.image)
            DB.shared.videoIDs.append(self.aid)
            let alertController = UIAlertController(title: "Favorite added".localized, message:
                "This video has been added to your favorite collection.".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func search() {
        self.reset_views()
        self.searchBar.resignFirstResponder()
        
        self.aid = self.searchBar.text
        if Int(self.aid) == nil {
            let alertController = UIAlertController(title: "Error".localized, message:
                "Video ID should be an integer".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.statTable.isHidden = false
            if DB.shared.videoIDs.contains(self.aid) {
                self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            }
            getRequest("bili_video", "api.bilibili.com", "https://api.bilibili.com/archive_stat/stat?aid=" + self.searchBar.text!)
            getRequest("jiji_video", "www.jijidown.com", "http://www.jijidown.com/Api/AvToCid/" + self.aid)
            getRequest("webpage", "bilibili.com webpage", "http://bili.utoptutor.com/videopage?aid=" + self.aid)
        }
    }
    
    func getRequest(_ type: String, _ site: String, _ urlstr: String) {
        let url = URL(string: urlstr)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String: Any] {
                        DispatchQueue.main.async(execute: { self.displayInfo(type, json) })
                    }
                } catch _ as NSError {
                    let alertController = UIAlertController(title: "Error".localized, message:
                        String(format: "Unfortunately, the JSON data returned by %@ is malformed, so it cannot be processed".localized, site), preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }.resume()
    }
    
    func displayInfo(_ type: String, _ json: [String: Any]) {
        if type == "bili_video" {
            if let code = json["code"] as? Int, code == 0,
                let data = json["data"] as? [String: Any?] {
                self.viewCount.text = intToString(data["view"])
                self.danmakuCount.text = intToString(data["danmaku"])
                self.replyCount.text = intToString(data["reply"])
                self.favoriteCount.text = intToString(data["favorite"])
                self.coinCount.text = intToString(data["coin"])
                self.ShareCount.text = intToString(data["share"])
                let curRank = intToString(data["now_rank"])
                let hisRank = intToString(data["his_rank"])
                let cp = intToString(data["copyright"])
                self.curRanking.text = curRank == "0" ? ">100" : curRank
                self.hisRanking.text = hisRank == "0" ? ">1000" : hisRank
                self.copyright.text = cp == "0" ? "No" : (cp == "1" ? "Yes" : cp)
            } else {
                self.videoName.text = "(Unknown)".localized
                let alertController = UIAlertController(title: "Error".localized, message:
                    "This video does not exist.".localized, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        } else if type == "jiji_video" {
            if let code = json["code"] as? Int, code == 0 {
                print(self.info_set)
                if self.info_set == false {
                    self.info_set = true
                    self.videoName.text = json["title"] as? String ?? "(Unknown)".localized
                    self.upName.text = json["up"] as? String ?? "(Unknown)".localized
                    self.desc.text = json["desc"] as? String ?? "(Unknown)".localized
                    if DB.shared.downloadImage {
                        setImage(self.upImage, json["upimg"] as? String)
                    }
                    self.favoriteIcon.isHidden = false
                    self.videoTitleCell.isUserInteractionEnabled = true
                    self.videoTitleCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    self.descriptionCell.isUserInteractionEnabled = true
                    self.descriptionCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
                if DB.shared.downloadImage {
                    setImage(self.videoImage, json["img"] as? String)
                }
            }
        } else if type == "webpage" {
            if let error = json["error"] as? Bool, !error {
                if self.info_set == false {
                    self.info_set = true
                    self.videoName.text = json["title"] as? String ?? "(Unknown)".localized
                    self.upName.text = json["upName"] as? String ?? "(Unknown)".localized
                    self.desc.text = json["description"] as? String ?? "(Unknown)".localized
                    if DB.shared.downloadImage {
                        setImage(self.upImage, json["upAvatar"] as? String)
                    }
                    self.favoriteIcon.isHidden = false
                    self.videoTitleCell.isUserInteractionEnabled = true
                    self.videoTitleCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    self.descriptionCell.isUserInteractionEnabled = true
                    self.descriptionCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
                let sign = json["upSign"] as? String ?? "(Unknown)".localized
                self.upsign.text = sign == "" ? "Signature not set".localized : sign
                
                if let uid = json["uid"] as? String {
                    self.uid = uid
                    getRequest("video_amount", "api.bilibili.com", "http://api.bilibili.com/x/space/navnum?mid=" + uid)
                    getRequest("follow_amount", "api.bilibili.com", "http://api.bilibili.com/x/relation/stat?vmid=" + uid)
                    self.uploaderCell.isUserInteractionEnabled = true
                    self.uploaderCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
            }
        } else if type == "video_amount" {
            if let code = json["code"] as? Int, code == 0,
                let data = json["data"] as? [String: Any?] {
                self.videoamount.text = "(" + intToString(data["video"]) + " videos)".localized
            }
        } else if type == "follow_amount" {
            if let code = json["code"] as? Int, code == 0,
                let data = json["data"] as? [String: Any?] {
                self.following.text = "Following: ".localized + intToString(data["following"])
                self.follower.text = "Follower: ".localized + intToString(data["follower"])
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            searchBar.resignFirstResponder()
            if #available(iOS 11.0, *) {
                searchBar.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            searchBar.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoTitle" {
            let vcDest = segue.destination as! WebKitController
            vcDest.videoTitle = self.videoName.text
            vcDest.urlStr = self.aid
        } else if segue.identifier == "uploader" {
            if self.uid != nil {
                let vcDest = segue.destination as! UserSearchController
                vcDest.searchBar.text = self.uid
                vcDest.searchButtonPressed = true
            } else {
                // Based on current implementation, this alert should never be triggered.
                let alertController = UIAlertController(title: "Error".localized, message:
                    "This video is probably a movie or an episode of a bangumi, and its webpage layout is different from a usual one, thus the user ID of the uploader is not loaded, thus unable to view their profile.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        } else if segue.identifier == "description" {
            let vcDest = segue.destination as! VideoDescriptionController
            vcDest.descriptionText.text = self.desc.text
        }
    }
}
