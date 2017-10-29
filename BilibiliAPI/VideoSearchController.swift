//
//  VideoSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/10/15.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoSearchController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var upImage: UIImageView!
    @IBOutlet weak var upName: UILabel!
    @IBOutlet weak var videoamount: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var upsign: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    let searchBar = UISearchBar()
    var info_set = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = searchBar
        self.searchBar.keyboardType = UIKeyboardType.numberPad
        self.searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchPressed))
        self.navigationItem.setRightBarButton(searchButton, animated: true)
        reset_views()
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
        self.info_set = false
    }
    
    @objc func searchPressed(_ sender: UIBarButtonItem) {
        self.reset_views()
        self.videoName.text = "Searching " + searchBar.text!
        self.searchBar.resignFirstResponder()
        get_request("bili_video", "https://api.bilibili.com/archive_stat/stat?aid=" + self.searchBar.text!)
        get_request("jiji_video", "http://www.jijidown.com/Api/AvToCid/" + self.searchBar.text!)
        get_request("webpage", "http://bili.utoptutor.com/videopage?aid=" + self.searchBar.text!)
    }
    
    func get_request(_ type: String, _ urlstr: String) {
        let url = URL(string: urlstr)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.displayInfo(type, json)
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
            if json["code"] as! Int != 0 {
                DispatchQueue.main.async(execute: {
                    self.videoName.text = "Video not found"
                })
            } else {
                // TODO
            }
        } else if type == "jiji_video" {
            if json["code"] as! Int != 0 || json["maxpage"] as! Int == 0 {
                // TODO: set videoimage as defaulf "not found" image
                return
            } else {
                DispatchQueue.main.async(execute: {
                    if self.info_set == false {
                        self.videoName.text = json["title"] as? String
                        self.upName.text = json["up"] as? String
                        self.desc.text = json["desc"] as? String
                        self.set_image(self.upImage, json["upimg"] as! String)
                    }
                    self.info_set = true
                    self.set_image(self.videoImage, json["img"] as! String)
                })
            }
        } else if type == "webpage" {
            if json["error"] as? Bool == true {
                DispatchQueue.main.async(execute: {
                    self.upsign.text = "Failed to uploader infomation"
                    return
                })
            } else {
                DispatchQueue.main.async(execute: {
                    if self.info_set == false {
                        self.videoName.text = json["title"] as? String
                        self.upName.text = json["upName"] as? String
                        self.desc.text = json["description"] as? String
                        self.set_image(self.upImage, json["upAvatar"] as! String)
                    }
                    self.info_set = true
                    self.upsign.text = json["upSign"] as? String
                })
                let uid = json["uid"] as! String
                get_request("video_amount", "http://api.bilibili.com/x/space/navnum?mid=" + uid)
                get_request("follow_amount", "http://api.bilibili.com/x/relation/stat?vmid=" + uid)
            }
        } else if type == "video_amount" {
            if json["code"] as! Int != 0 {
                DispatchQueue.main.async(execute: {
                    //self.videoName.text = "Video not found"
                })
            } else {
                DispatchQueue.main.async(execute: {
                    let data = json["data"] as! [String: Any?]
                    self.videoamount.text = "(" + String(data["video"] as! Int) + " videos)"
                })
            }
        } else if type == "follow_amount" {
            if json["code"] as! Int != 0 {
                DispatchQueue.main.async(execute: {
                    //self.videoName.text = "Video not found"
                })
            } else {
                DispatchQueue.main.async(execute: {
                    let data = json["data"] as! [String: Any?]
                    self.following.text = "Following: " + String(data["following"] as! Int)
                    self.follower.text = "Follower: " + String(data["follower"] as! Int)
                })
            }
        }
    }
    
    func set_image(_ image_view: UIImageView, _ urlstr: String) {
        do {
            let imgurl = URL(string: urlstr)
            let img = try? Data(contentsOf: imgurl!)
            image_view.image = UIImage(data: img!)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            searchBar.resignFirstResponder()
            searchBar.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
}
