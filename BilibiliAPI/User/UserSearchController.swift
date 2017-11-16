//
//  UserSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserSearchController: UITableViewController {

    @IBOutlet weak var upName: UILabel!
    @IBOutlet weak var upImage: UIImageView!
    @IBOutlet weak var upsign: UILabel!
    @IBOutlet weak var videoamount: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var videoamountCell: UITableViewCell!
    @IBOutlet weak var levelInfoView: UserLevelInfoView!
    @IBOutlet weak var followingCell: UITableViewCell!
    @IBOutlet weak var followerCell: UITableViewCell!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var totalview: UILabel!
    @IBOutlet weak var regdate: UILabel!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    @IBOutlet var statTable: UITableView!
    
    let searchBar = UISearchBar()
    var searchButtonPressed = false
    var uid: String!
    var taskFinished = 0
    
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
        self.upName.text = ""
        self.upImage.image = nil
        self.upsign.text = ""
        self.videoamount.text = ""
        self.following.text = ""
        self.follower.text = ""
        self.gender.text = ""
        self.birthday.text = ""
        self.location.text = ""
        self.totalview.text = ""
        self.regdate.text = ""
        self.badge.text = ""
        self.levelInfoView.isHidden = true
        self.taskFinished = 0
        self.videoamountCell.isUserInteractionEnabled = false
        self.followingCell.isUserInteractionEnabled = false
        self.followerCell.isUserInteractionEnabled = false
        self.videoamountCell.isUserInteractionEnabled = false
        self.videoamountCell.accessoryType = UITableViewCellAccessoryType.none
        self.followingCell.accessoryType = UITableViewCellAccessoryType.none
        self.followerCell.accessoryType = UITableViewCellAccessoryType.none
        self.favoriteIcon.isHidden = true
        self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
    }

    @objc func searchPressed(_ sender: UIBarButtonItem) {
        search()
    }
    
    @objc func favoritePressed() {
        if let index = DB.shared.userIDs.index(of: self.uid) {
            self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
            DB.shared.userNames.remove(at: index)
            DB.shared.userImgs.remove(at: index)
            DB.shared.userIDs.remove(at: index)
            let alertController = UIAlertController(title: "Favorite removed".localized, message:
                "This user has been removed from your favorite collection.".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            DB.shared.userNames.append(self.upName.text)
            DB.shared.userImgs.append(self.upImage.image)
            DB.shared.userIDs.append(self.uid)
            let alertController = UIAlertController(title: "Favorite added".localized, message:
                "This user has been added to your favorite collection.".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func search() {
        self.reset_views()
        self.searchBar.resignFirstResponder()
        
        self.uid = self.searchBar.text
        if Int(self.uid) == nil {
            let alertController = UIAlertController(title: "Error".localized, message:
                "Video ID should be an integer".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.statTable.isHidden = false
            if DB.shared.userIDs.contains(self.uid) {
                self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            }
            postRequest("user_info", "http://space.bilibili.com/ajax/member/GetInfo")
            getRequest("video_amount", "http://api.bilibili.com/x/space/navnum?mid=" + self.uid)
            getRequest("follow_amount", "http://api.bilibili.com/x/relation/stat?vmid=" + self.uid)
        }
    }
    
    func getRequest(_ type: String, _ urlstr: String) {
        let url = URL(string: urlstr)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async(execute: { self.parseToJSON(data, type) })
        }.resume()
    }
    
    func postRequest(_ type: String, _ urlstr: String) {
        let url: NSURL = NSURL(string: urlstr)!
        let paramString = "mid=" + self.uid
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        request.setValue("https://space.bilibili.com/" + self.uid + "/", forHTTPHeaderField: "Referer")
        URLSession.shared.dataTask(with: request as URLRequest ) { (data, response, error) in
            DispatchQueue.main.async(execute: { self.parseToJSON(data, type) })
        }.resume()
    }
    
    func parseToJSON(_ data: Data?, _ type: String) {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any] {
                    self.displayInfo(type, json)
                }
            } catch _ as NSError {
                let alertController = UIAlertController(title: "Error".localized, message:
                    String(format: "Unfortunately, the JSON data returned by %@ is malformed, so it cannot be processed".localized, "api.bilibili.com"), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func displayInfo(_ type: String, _ json: [String: Any]) {
        if type == "user_info" {
            if let status = json["status"] as? Bool, status,
                let data = json["data"] as? [String: Any?] {
                self.upName.text = data["name"] as? String ?? "(Unknown)".localized
                if DB.shared.downloadImage {
                    setImage(self.upImage, data["face"] as? String)
                }
                let sign = data["sign"] as? String
                self.upsign.text = sign == "" ? "Signature not set".localized : sign
                
                if let levelInfo = data["level_info"] as? [String: Any?] {
                    self.levelInfoView.isHidden = false
                    self.levelInfoView.curExp = levelInfo["current_exp"] as? Int
                    self.levelInfoView.curLevel = levelInfo["current_level"] as? Int
                    self.levelInfoView.nextExp = levelInfo["next_exp"] as? Int
                    self.levelInfoView.setNeedsDisplay()
                    let levelViewWidth = self.levelInfoView.frame.size.width
                    self.levelInfoView.frame.size.width = 0
                    UIView.animate(withDuration: 1.0, animations: {
                        self.levelInfoView.frame.size.width = levelViewWidth
                    })
                }
                
                if let birthday = data["birthday"] as? String {
                    let index = birthday.index(birthday.startIndex, offsetBy: 5)
                    self.birthday.text = String(birthday[index...])
                    let gender = ["": "Not set", "男": "Male", "女": "Female"]
                    self.gender.text = gender[data["sex"] as? String ?? ""]?.localized
                    let location = data["place"] as? String ?? ""
                    self.location.text = location == "" ? "Not set".localized : location
                    
                    if let timeResult = data["regtime"] as? Int {
                        let date = NSDate(timeIntervalSince1970: TimeInterval(timeResult))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                        let localDate = dateFormatter.string(from: date as Date)
                        self.regdate.text = localDate
                    }
                } else {
                    self.birthday.text = "Secret".localized
                    self.gender.text = "Secret".localized
                    self.location.text = "Secret".localized
                    self.regdate.text = "Secret".localized
                }
                self.totalview.text = intToString(data["playNum"])
                if let badge = data["fans_badge"] as? Bool {
                    self.badge.text = (badge ? "Available" : "Not Available").localized
                }
                enableInteraction();
            } else {
                self.upName.text = "(Unknown)".localized
                let alertController = UIAlertController(title: "Error".localized, message:
                    "This user does not exist.".localized, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        } else if type == "video_amount" {
            if let code = json["code"] as? Int, code == 0,
                let data = json["data"] as? [String: Any?] {
                self.videoamount.text = intToString(data["video"])
                enableInteraction();
            }
        } else if type == "follow_amount" {
            if let code = json["code"] as? Int, code == 0,
                let data = json["data"] as? [String: Any?] {
                self.following.text = intToString(data["following"])
                self.follower.text = intToString(data["follower"])
                enableInteraction();
            }
        }
    }
    
    func enableInteraction() {
        self.taskFinished += 1
        if self.taskFinished == 3 {
            self.favoriteIcon.isHidden = false
            self.videoamountCell.isUserInteractionEnabled = true
            self.followingCell.isUserInteractionEnabled = true
            self.followerCell.isUserInteractionEnabled = true
            self.videoamountCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            self.followingCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            self.followerCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "videoList" {
            let vcDest = segue.destination as! UserVideoController
            vcDest.username = self.upName.text
            vcDest.uid = self.uid
            let nVideos = Int(self.videoamount.text!)!
            vcDest.nPages = nVideos / 100 + (nVideos - nVideos / 100 * 100 == 0 ? 0 : 1)
        } else if segue.identifier == "followList" {
            let vcDest = segue.destination as! UserFollowController
            vcDest.username = self.upName.text
            vcDest.uid = self.uid
            vcDest.type = "followings"
            let nFollows = Int(self.following.text!)!
            vcDest.nPages = nFollows / 100 + (nFollows - nFollows / 100 * 100 == 0 ? 0 : 1)
        } else if segue.identifier == "followerList" {
            let vcDest = segue.destination as! UserFollowController
            vcDest.username = self.upName.text
            vcDest.uid = self.uid
            vcDest.type = "followers"
            let nFollowers = Int(self.follower.text!)!
            vcDest.nPages = nFollowers / 100 + (nFollowers - nFollowers / 100 * 100 == 0 ? 0 : 1)
        }
    }

}
