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
        self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
    }

    @objc func searchPressed(_ sender: UIBarButtonItem) {
        search()
    }
    
    @objc func favoritePressed() {
        if let index = FavoriteDB.sharedInstance.videoIDs.index(of: self.uid) {
            self.favoriteIcon.setImage(UIImage(named: "notfavorite"), for: UIControlState.normal)
            FavoriteDB.sharedInstance.userIDs.remove(at: index)
            FavoriteDB.sharedInstance.userNames.remove(at: index)
            FavoriteDB.sharedInstance.userImgs.remove(at: index)
        } else {
            self.favoriteIcon.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
            FavoriteDB.sharedInstance.userIDs.append(self.uid)
            FavoriteDB.sharedInstance.userNames.append(self.upName.text)
            FavoriteDB.sharedInstance.userImgs.append(self.upImage.image)
        }
    }
    
    func search() {
        self.reset_views()
        self.statTable.isHidden = false
        self.uid = self.searchBar.text
        self.upName.text = "Searching " + self.uid
        self.searchBar.resignFirstResponder()
        if Int(self.searchBar.text!) == nil {
            let alertController = UIAlertController(title: "Error", message:
                "Video ID should be an integer", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
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
    
    func displayInfo(_ type: String, _ json: [String: Any]) {
        if type == "bili_video" {
            
        } else if type == "jiji_video" {
            
        } else if type == "webpage" {
            
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
