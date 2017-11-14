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
    @IBOutlet weak var levelInfoView: UserLevelInfoView!
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
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchPressed))
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
        self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
    }

    @objc func searchPressed(_ sender: UIBarButtonItem) {
        search()
    }
    
    @objc func favoritePressed() {
        if let index = FavoriteDB.sharedInstance.userIDs.index(of: self.uid) {
            self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
            FavoriteDB.sharedInstance.userNames.remove(at: index)
            FavoriteDB.sharedInstance.userImgs.remove(at: index)
            FavoriteDB.sharedInstance.userIDs.remove(at: index)
            let alertController = UIAlertController(title: "Favorite removed", message:
                "This user has been removed from your favorite collection.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            FavoriteDB.sharedInstance.userNames.append(self.upName.text)
            FavoriteDB.sharedInstance.userImgs.append(self.upImage.image)
            FavoriteDB.sharedInstance.userIDs.append(self.uid)
            let alertController = UIAlertController(title: "Favorite added", message:
                "This user has been added to your favorite collection.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func search() {
        self.reset_views()
        self.searchBar.resignFirstResponder()
        
        self.uid = self.searchBar.text
        if Int(self.uid) == nil {
            let alertController = UIAlertController(title: "Error", message:
                "Video ID should be an integer", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.statTable.isHidden = false
            self.upName.text = "Searching user ID " + self.uid
            if FavoriteDB.sharedInstance.userIDs.contains(self.uid) {
                self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            }
            post_request("user_info", "http://space.bilibili.com/ajax/member/GetInfo")
            get_request("video_amount", "http://api.bilibili.com/x/space/navnum?mid=" + self.uid)
            get_request("follow_amount", "http://api.bilibili.com/x/relation/stat?vmid=" + self.uid)
        }
    }
    
    func get_request(_ type: String, _ urlstr: String) {
        let url = URL(string: urlstr)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    DispatchQueue.main.async(execute: {
                        self.displayInfo(type, json)
                    })
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func post_request(_ type: String, _ urlstr: String) {
        let url: NSURL = NSURL(string: urlstr)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let paramString = "mid=" + self.uid
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        request.setValue("https://space.bilibili.com/" + self.uid + "/", forHTTPHeaderField: "Referer")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let data = data/*NSString(data: data!, encoding: String.Encoding.utf8.rawValue)*/ {
                do {
                    // Convert the data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    DispatchQueue.main.async(execute: {
                        self.displayInfo(type, json)
                    })
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func displayInfo(_ type: String, _ json: [String: Any]) {
        if type == "user_info" {
            if json["status"] as! Bool == false {
                // Unknown error
            } else {
                let data = json["data"] as! [String: Any?]
                self.upName.text = data["name"] as? String
                self.set_image(self.upImage, data["face"] as! String)
                let sign = data["sign"] as? String
                self.upsign.text = sign == "" ? "Signature not set" : sign
                
                let levelInfo = data["level_info"] as! [String: Any?]
                self.levelInfoView.curExp = levelInfo["current_exp"] as? Int
                self.levelInfoView.curLevel = levelInfo["current_level"] as? Int
                self.levelInfoView.nextExp = levelInfo["next_exp"] as? Int
                self.levelInfoView.setNeedsDisplay()
                let levelViewWidth = self.levelInfoView.frame.size.width
                self.levelInfoView.frame.size.width = 0
                UIView.animate(withDuration: 1.0, animations: {
                    self.levelInfoView.frame.size.width = levelViewWidth
                })
                
                let gender = ["": "Not set", "男": "Male", "女": "Female"]
                self.gender.text = gender[data["sex"] as! String]
                let birthday = data["birthday"] as! String
                let index = birthday.index(birthday.startIndex, offsetBy: 5)
                self.birthday.text = String(birthday[index...])
                let location = data["place"] as! String
                self.location.text = location == "" ? "Not set" : location
                self.totalview.text = String(data["playNum"] as! Int)
                let timeResult = data["regtime"] as! Int
                let date = NSDate(timeIntervalSince1970: TimeInterval(timeResult))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let localDate = dateFormatter.string(from: date as Date)
                self.regdate.text = localDate
                self.badge.text = data["fans_badge"] as! Bool ? "Available" : "Not Available"
            }
        } else if type == "video_amount" {
            if json["code"] as! Int != 0 {
                //self.videoName.text = "Video not found"
            } else {
                let data = json["data"] as! [String: Any?]
                self.videoamount.text = String(data["video"] as! Int)
            }
        } else if type == "follow_amount" {
            if json["code"] as! Int != 0 {
                //self.videoName.text = "Video not found"
            } else {
                let data = json["data"] as! [String: Any?]
                self.following.text = String(data["following"] as! Int)
                self.follower.text = String(data["follower"] as! Int)
            }
        }
    }
    
    func set_image(_ image_view: UIImageView, _ urlstr: String) {
        if let imgurl = URL(string: urlstr) {
            let img = try? Data(contentsOf: imgurl)
            image_view.image = UIImage(data: img!)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
