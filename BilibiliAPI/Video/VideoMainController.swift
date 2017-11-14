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
            (NSNotification) in
            if FavoriteDB.sharedInstance.shouldReload {
                self.favoriteTable.reloadData()
            }
            let videoImages = NSKeyedArchiver.archivedData(withRootObject: FavoriteDB.sharedInstance.videoImgs)
            UserDefaults.standard.set(videoImages, forKey: VideoImgs)
            UserDefaults.standard.set(FavoriteDB.sharedInstance.videoIDs, forKey: VideoIDs)
            UserDefaults.standard.set(FavoriteDB.sharedInstance.videoTitles, forKey: VideoTitles)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoReusedCell", for: indexPath) as! VideoCell
        cell.videoID?.text = FavoriteDB.sharedInstance.videoIDs[indexPath.row]
        cell.videoTitle?.text = FavoriteDB.sharedInstance.videoTitles[indexPath.row]
        cell.videoImg?.image = FavoriteDB.sharedInstance.videoImgs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Are you sure?", message:
                "Do you really want to remove this video?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {
                (action) -> Void in
                FavoriteDB.sharedInstance.shouldReload = false
                FavoriteDB.sharedInstance.videoTitles.remove(at: indexPath.row)
                FavoriteDB.sharedInstance.videoImgs.remove(at: indexPath.row)
                FavoriteDB.sharedInstance.videoIDs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                FavoriteDB.sharedInstance.shouldReload = true
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
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
