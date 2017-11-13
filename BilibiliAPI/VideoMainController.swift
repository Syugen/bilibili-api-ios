//
//  VideoMainController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoMainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoriteTable.dataSource = self
        favoriteTable.delegate = self
        favoriteTable.rowHeight = 100
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(VideoDBChange), object: FavoriteDB.sharedInstance, queue: nil) {
            (NSNotification) in self.favoriteTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorite Videos"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteDB.sharedInstance.videoIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoReusedCell", for: indexPath) as! FavoriteVideoCell
        cell.videoID?.text = FavoriteDB.sharedInstance.videoIDs[indexPath.row]
        cell.videoTitle?.text = FavoriteDB.sharedInstance.videoTitles[indexPath.row]
        cell.videoImg?.image = FavoriteDB.sharedInstance.videoImgs[indexPath.row]
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? FavoriteVideoCell {
            let vcDest = segue.destination as! VideoSearchController
            vcDest.searchBar.text = cell.videoID?.text
            vcDest.searchButtonPressed = true
        }
    }

}
