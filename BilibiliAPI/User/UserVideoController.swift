//
//  UserVideoController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/14.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserVideoController: UITableViewController {
    
    var username: String!
    var uid: String!
    var nPages: Int!
    var videoIDs: [String] = []
    var videoTitles: [String?] = []
    var videoImgs: [String?] = []
    var videoDates: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = self.username! + "'s videos"
        self.tableView.rowHeight = 100
        if self.nPages > 0 {
            get_request("1", "http://space.bilibili.com/ajax/member/getSubmitVideos?mid=" + self.uid + "&pagesize=100&tid=0&page=1")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
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
        if json["status"] as! Bool != true {
            let alertController = UIAlertController(title: "Error", message:
                "Failed to load user's video list.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let data = json["data"] as! [String: Any?]
            let vlist = data["vlist"] as! [[String: Any?]]
            for item in vlist {
                videoIDs.append(String(item["aid"] as! Int))
                videoTitles.append(item["title"] as? String)
                videoImgs.append(item["pic"] as? String)
                if let date = item["created"] as? Int {
                    let date = NSDate(timeIntervalSince1970: TimeInterval(date))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    let localDate = dateFormatter.string(from: date as Date)
                    videoDates.append(localDate)
                }
            }
        }
        /*
        if Int(type)! < min(5, self.nPages) {
            let nextPage = String(Int(type)! + 1)
            get_request(nextPage, "http://space.bilibili.com/ajax/member/getSubmitVideos?mid=" + self.uid + "&pagesize=100&tid=0&page=" + nextPage)
        }*/
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videoIDs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.nPages > 1 {
            return "Only shows first 100 results"
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoReusedCell", for: indexPath) as! VideoCell
        cell.videoID?.text = self.videoIDs[indexPath.row]
        cell.videoTitle?.text = self.videoTitles[indexPath.row]
        cell.videoDate?.text = self.videoDates[indexPath.row]
        if FavoriteDB.sharedInstance.downloadImage, let urlstr = self.videoImgs[indexPath.row] {
            let url = URL(string: "http:" + urlstr)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async(execute: {
                        cell.videoImg?.image = UIImage(data: data)
                    })
                }
            }
            task.resume()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? VideoCell {
            let vcDest = segue.destination as! VideoSearchController
            vcDest.searchBar.text = cell.videoID?.text
            vcDest.searchButtonPressed = true
        }
    }

}
