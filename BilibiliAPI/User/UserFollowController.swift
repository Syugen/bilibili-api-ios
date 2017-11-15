//
//  UserFollowController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/14.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserFollowController: UITableViewController {

    var username: String!
    var uid: String!
    var type: String!
    var nPages: Int!
    var userIDs: [String] = []
    var userNames: [String?] = []
    var userImgs: [String?] = []
    var dates: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = self.username! + "'s " + self.type
        self.tableView.rowHeight = 70
        if self.nPages > 0 {
            let urlPrefix = "http://api.bilibili.com/x/relation/" + self.type + "?vmid=" + self.uid + "&pn="
            get_request("1", urlPrefix + "1")
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
        if json["code"] as! Int != 0 {
            let alertController = UIAlertController(title: "Error", message:
                "Failed to load user's following list. You may try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let data = json["data"] as! [String: Any?]
            let list = data["list"] as! [[String: Any?]]
            for item in list {
                userIDs.append(String(item["mid"] as! Int))
                userNames.append(item["uname"] as? String)
                userImgs.append(item["face"] as? String)
                if let date = item["mtime"] as? Int {
                    let date = NSDate(timeIntervalSince1970: TimeInterval(date))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    let localDate = dateFormatter.string(from: date as Date)
                    dates.append(localDate)
                }
            }
        }
        /*
        if Int(type)! < min(5, self.nPages) {
            let nextPage = String(Int(type)! + 1)
            let urlPrefix = "http://api.bilibili.com/x/relation/" + self.type + "?vmid=" + self.uid + "&pn="
            get_request(nextPage, urlPrefix + nextPage)
        }*/
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userIDs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.nPages > 1 {
            return "Only shows first 100 results"
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReusedCell", for: indexPath) as! UserCell
        cell.uid = self.userIDs[indexPath.row]
        cell.userName?.text = self.userNames[indexPath.row]
        cell.date?.text = self.dates[indexPath.row]
        if FavoriteDB.sharedInstance.downloadImage, let urlstr = self.userImgs[indexPath.row] {
            let url = URL(string: urlstr)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async(execute: {
                        cell.userImg?.image = UIImage(data: data)
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
        if let cell = sender as? UserCell {
            let vcDest = segue.destination as! UserSearchController
            vcDest.searchBar.text = cell.uid
            vcDest.searchButtonPressed = true
        }
    }

}
