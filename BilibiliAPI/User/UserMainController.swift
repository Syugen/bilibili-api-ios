//
//  UserMainController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserMainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        favoriteTable.dataSource = self
        favoriteTable.delegate = self
        favoriteTable.rowHeight = 70
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(UserDBChange), object: FavoriteDB.sharedInstance, queue: nil) {
            (NSNotification) in
            self.favoriteTable.reloadData()
            let userImages = NSKeyedArchiver.archivedData(withRootObject: FavoriteDB.sharedInstance.userImgs)
            UserDefaults.standard.set(userImages, forKey: UserImgs)
            UserDefaults.standard.set(FavoriteDB.sharedInstance.userIDs, forKey: UserIDs)
            UserDefaults.standard.set(FavoriteDB.sharedInstance.userNames, forKey: UserNames)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorite Users"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteDB.sharedInstance.userIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReusedCell", for: indexPath) as! FavoriteUserCell
        cell.userID?.text = FavoriteDB.sharedInstance.userIDs[indexPath.row]
        cell.userName?.text = FavoriteDB.sharedInstance.userNames[indexPath.row]
        cell.userImg?.image = FavoriteDB.sharedInstance.userImgs[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? FavoriteUserCell {
            let vcDest = segue.destination as! UserSearchController
            vcDest.searchBar.text = cell.userID?.text
            vcDest.searchButtonPressed = true
        }
    }

}
