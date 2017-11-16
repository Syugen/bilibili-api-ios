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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(VideoDBChange), object: DB.shared, queue: nil) {
            (NSNotification) in
            if DB.shared.shouldReload {
                self.favoriteTable.reloadData()
            }
            let videoImages = NSKeyedArchiver.archivedData(withRootObject: DB.shared.videoImgs)
            UserDefaults.standard.set(videoImages, forKey: VideoImgs)
            UserDefaults.standard.set(DB.shared.videoIDs, forKey: VideoIDs)
            UserDefaults.standard.set(DB.shared.videoTitles, forKey: VideoTitles)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorite Videos".localized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.shared.videoIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoReusedCell", for: indexPath) as! VideoCell
        cell.videoID?.text = DB.shared.videoIDs[indexPath.row]
        cell.videoTitle?.text = DB.shared.videoTitles[indexPath.row]
        cell.videoImg?.image = DB.shared.videoImgs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "", message: "Do you really want to remove this video?".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.destructive, handler: {
                (action) -> Void in
                DB.shared.shouldReload = false
                DB.shared.videoTitles.remove(at: indexPath.row)
                DB.shared.videoImgs.remove(at: indexPath.row)
                DB.shared.videoIDs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DB.shared.shouldReload = true
            }))
            alertController.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: nil))
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
