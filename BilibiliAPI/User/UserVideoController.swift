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

        navigationItem.title = self.username! + "'s videos".localized
        self.tableView.rowHeight = 100
        if self.nPages > 0 {
            getRequest("1", "space.bilibili.com", "http://space.bilibili.com/ajax/member/getSubmitVideos?mid=" + self.uid + "&pagesize=100&tid=0&page=1")
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
        if let status = json["status"] as? Bool, status,
            let data = json["data"] as? [String: Any?],
            let vlist = data["vlist"] as? [[String: Any?]] {
            for item in vlist {
                videoIDs.append(intToString(item["aid"]))
                videoTitles.append(item["title"] as? String ?? "(Unknown)".localized)
                videoImgs.append(item["pic"] as? String ?? "(Unknown)".localized)
                if let date = item["created"] as? Int {
                    let date = NSDate(timeIntervalSince1970: TimeInterval(date))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    let localDate = dateFormatter.string(from: date as Date)
                    videoDates.append(localDate)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Error".localized, message: String(format: "Failed to load user's %@ list. You may try again.".localized, "video"), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        /*
        if Int(type)! < min(5, self.nPages) {
            let nextPage = String(Int(type)! + 1)
            get_request(nextPage, "http://space.bilibili.com/ajax/member/getSubmitVideos?mid=" + self.uid + "&pagesize=100&tid=0&page=" + nextPage)
        }*/
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoIDs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.nPages > 1 {
            return "Only shows first 100 results".localized
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoReusedCell", for: indexPath) as! VideoCell
        cell.videoID?.text = self.videoIDs[indexPath.row]
        cell.videoTitle?.text = self.videoTitles[indexPath.row]
        cell.videoDate?.text = self.videoDates[indexPath.row]
        if DB.shared.downloadImage, let urlstr = self.videoImgs[indexPath.row] {
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
